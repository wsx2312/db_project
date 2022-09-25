select concat(left(s."NAME", 1), repeat('*', length(s."NAME") - 1)), s."STUDENT_ID", c."MAJOR_NAME", c."COLLEGE_NAME" from
(
	(
		select s."STUDENT_ID" from students s 
			join grade g
				on g."STUDENT_ID" = s."STUDENT_ID"
			join course c
				on c."COURSE_ID" = g."COURSE_ID"
		where s."ADMISSION_YEAR" = 2015
		and g."GRADE" != 0 
		group by s."STUDENT_ID"
		having sum(c."CREDIT") >= 40
		order by avg(g."GRADE") desc
		limit 1
	)
	union
	(
		select s."STUDENT_ID" from students s 
			join grade g
				on g."STUDENT_ID" = s."STUDENT_ID"
			join course c
				on c."COURSE_ID" = g."COURSE_ID"
		where s."ADMISSION_YEAR" = 2015
		and g."GRADE" != 0 
		group by s."STUDENT_ID"
		having sum(c."CREDIT") >= 40
		order by avg(g."GRADE") asc
		limit 1
	)
) mms
join students s
	on mms."STUDENT_ID" = s."STUDENT_ID"
join college c 
	on s."MAJOR_ID" = c."MAJOR_ID"

