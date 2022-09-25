select gt."DAY_OF_WEEK", format('%s ~ %s', to_char(tt."START_TIME", 'FMHH24:MI'), to_char(tt."END_TIME", 'FMHH24:MI')) time
from
(
	select dow."DAY_OF_WEEK", "NO" from day_of_week dow 
	cross join timetable t 
	where dow."DAY_OF_WEEK" != 'SAT' 
	and dow."DAY_OF_WEEK" != 'SUN'
	except 
	(
		select ctt."DAY_OF_WEEK", ctt."NO" from course_registration cr
		join course c on cr."COURSE_ID" = c."COURSE_ID"
		right join course_to_time ctt on c."COURSE_ID" = ctt."COURSE_ID"
		where "STUDENT_ID" = '2018111111' and 
		c."YEAR" = 2018 and c."SEMESTER" = 2
		
		union
		
		select ctt."DAY_OF_WEEK", ctt."NO" from course_registration cr
		join course c on cr."COURSE_ID" = c."COURSE_ID"
		right join course_to_time ctt on c."COURSE_ID" = ctt."COURSE_ID"
		where "STUDENT_ID" = '2017222222' and 
		c."YEAR" = 2018 and c."SEMESTER" = 2
	)
) gt
join timetable tt
on gt."NO" = tt."NO"
order by
	case
		when gt."DAY_OF_WEEK" = 'MON' then 1
		when gt."DAY_OF_WEEK" = 'TUE' then 2
		when gt."DAY_OF_WEEK" = 'WED' then 3
		when gt."DAY_OF_WEEK" = 'THU' then 4
		when gt."DAY_OF_WEEK" = 'FRI' then 5
     end asc, 
     gt."NO"