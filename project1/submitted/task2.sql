select t."COURSE_NAME" 
from (
		select c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", count(*) as "CLASS_RETAKE_COUNT"
			from "course_registration" as cr 
			join "course" as c
				on cr."COURSE_ID" = c."COURSE_ID"
		where c."YEAR" between 2013 and 2018
		group by (c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", cr."STUDENT_ID")
		having count(c."COURSE_ID_NO") > 1
) t
group by (t."COURSE_NAME", t."COURSE_ID_PREFIX", t."COURSE_ID_NO")
order by SUM("CLASS_RETAKE_COUNT") desc
limit 3