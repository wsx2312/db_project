-- with graduate_student as (
-- 	select s."STUDENT_ID", sum(g."GRADE" * c."CREDIT") / sum(c."CREDIT") as "AVG_GRADE" from students s
-- 	join grade g
-- 		on g."STUDENT_ID" = s."STUDENT_ID"
-- 	join course c
-- 		on c."COURSE_ID" = g."COURSE_ID"
-- 	where (s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", concat(c."YEAR", c."SEMESTER"))
-- 	in (
-- 		select s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", max(concat(c."YEAR", c."SEMESTER")) "YEAR_SEMESTER" from students s
-- 			join grade g
-- 				on g."STUDENT_ID" = s."STUDENT_ID"
-- 			join course c
-- 				on c."COURSE_ID" = g."COURSE_ID"
-- 		where s."ADMISSION_YEAR" = 2015
-- 		group by (s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO")
-- 	)
-- 	and g."GRADE" != 0
-- 	group by s."STUDENT_ID"
-- 	having sum(c."CREDIT") >= 40
-- )
-- select concat(left(s."NAME", 1), repeat('*', length(s."NAME") - 1)), s."STUDENT_ID", c."MAJOR_NAME", c."COLLEGE_NAME" from graduate_student gs
-- join students s
-- 	on gs."STUDENT_ID" = s."STUDENT_ID"
-- join college c 
-- 	on s."MAJOR_ID" = c."MAJOR_ID"
-- where gs."AVG_GRADE" = (select max("AVG_GRADE") from graduate_student) 
-- 	or gs."AVG_GRADE" = (select min("AVG_GRADE") from graduate_student) 

with grade4_with_no_retake as  (
  select s."STUDENT_ID", g."GRADE", c."CREDIT", s."NAME" from students s 
	join grade g
		on g."STUDENT_ID" = s."STUDENT_ID"
	join course c
		on c."COURSE_ID" = g."COURSE_ID"
	where (s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", concat(c."YEAR", c."SEMESTER"))
	in (
		select s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", max(concat(c."YEAR", c."SEMESTER")) "YEAR_SEMESTER" from students s
			join grade g
				on g."STUDENT_ID" = s."STUDENT_ID"
			join course c
				on c."COURSE_ID" = g."COURSE_ID"
		where s."GRADE" = 4
		group by (s."STUDENT_ID", c."COURSE_ID_PREFIX", c."COURSE_ID_NO")
	)
)
select concat(left(s."NAME", 1), repeat('*', length(s."NAME") - 1)), s."STUDENT_ID", c."MAJOR_NAME", c."COLLEGE_NAME" from (
	select "STUDENT_ID" from grade4_with_no_retake gs
		where "GRADE" != 0
	group by "STUDENT_ID"
	having sum("CREDIT") >= 40
) gs
join
(
	select "STUDENT_ID", sum("GRADE" * "CREDIT") / sum("CREDIT") as "AVG_GRADE" 
		from grade4_with_no_retake gs
	group by "STUDENT_ID"
) ag
	on gs."STUDENT_ID" = ag."STUDENT_ID"
join students s
	on gs."STUDENT_ID" = s."STUDENT_ID"
join college c 
	on s."MAJOR_ID" = c."MAJOR_ID"
where ag."AVG_GRADE" = (select max("AVG_GRADE") from 
		(
			select "STUDENT_ID", sum("GRADE" * "CREDIT") / sum("CREDIT") as "AVG_GRADE" 
				from grade4_with_no_retake gs
			group by "STUDENT_ID"
		) t
	) 
	or ag."AVG_GRADE" = (select min("AVG_GRADE") from 
		(
			select "STUDENT_ID", sum("GRADE" * "CREDIT") / sum("CREDIT") as "AVG_GRADE" 
				from grade4_with_no_retake gs
			group by "STUDENT_ID"
		) t
	) 