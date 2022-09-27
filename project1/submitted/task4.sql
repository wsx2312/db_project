select g."AVG_GRADE", g."STUDENT_ID", g."GRADE", g."MAJOR_NAME", g."COLLEGE_NAME"
from (
	select g."STUDENT_ID", g."AVG_GRADE", s."GRADE", c."MAJOR_NAME", c."COLLEGE_NAME", c."MAJOR_ID"
	from (
		select g."STUDENT_ID", sum(g."GRADE" * c."CREDIT") / sum(c."CREDIT") as "AVG_GRADE"
			from course c join grade g 
			on c."COURSE_ID" = g."COURSE_ID"
		where c."YEAR" = 2018 and c."SEMESTER" = 2
		group by g."STUDENT_ID"
	) g
	join students s
		on g."STUDENT_ID" = s."STUDENT_ID"
	join college c
		on s."MAJOR_ID" = c."MAJOR_ID"
	where s."GRADE" between 1 and 4
		
) g
join (
	select s."GRADE", s."MAJOR_ID", max(g."AVG_GRADE") as "HIGHEST_GRADE"
	from (
		select g."STUDENT_ID", sum(g."GRADE" * c."CREDIT") / sum(c."CREDIT") as "AVG_GRADE"
			from course c join grade g 
			on c."COURSE_ID" = g."COURSE_ID"
		where "YEAR" = 2018 and "SEMESTER" = 2
		group by g."STUDENT_ID"
	) g
	join students s
	on g."STUDENT_ID" = s."STUDENT_ID"
	where s."GRADE" between 1 and 4
	group by (s."GRADE", s."MAJOR_ID")
) mg
on g."AVG_GRADE" = mg."HIGHEST_GRADE"
	and g."GRADE" = mg."GRADE"
	and g."MAJOR_ID" = mg."MAJOR_ID"
order by g."MAJOR_NAME", g."GRADE", g."STUDENT_ID";
