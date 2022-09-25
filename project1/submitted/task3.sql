select f."NAME", p."CLASS_COUNT"
from (
	select c."PROF_ID", count(*) as "CLASS_COUNT" from course c
	join (
		select "COURSE_ID", count(*) as "STUDENT_COUNT" 
		from "course_registration"
		group by "COURSE_ID"
	) cr
	on c."COURSE_ID" = cr."COURSE_ID"
	where c."YEAR" between 2013 and 2018
	and cr."STUDENT_COUNT" > 0.8 * c."MAX_ENROLLEES"
	group by c."PROF_ID"
) p
join faculty f
on p."PROF_ID" = f."ID"
order by p."CLASS_COUNT" desc, f."NAME"