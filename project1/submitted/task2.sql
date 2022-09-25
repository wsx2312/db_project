select t."COURSE_NAME" 
	from (
		select c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", count(*) as "CLASS_TAKE_COUNT"
			from "course_registration" as cr 
			join "course" as c
			on cr."COURSE_ID" = c."COURSE_ID"
		where c."YEAR" between 2013 and 2018
		group by (c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", cr."STUDENT_ID")
		having count(c."COURSE_ID_NO") > 1
	) t
group by (t."COURSE_NAME", t."COURSE_ID_PREFIX", t."COURSE_ID_NO")
order by SUM("CLASS_TAKE_COUNT") desc
limit 3


--select c."COURSE_NAME", c."COURSE_ID"
--from (
--	select t."COURSE_ID_PREFIX", t."COURSE_ID_NO" 
--		from (
--			select c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", count(*)
--				from "course_registration" as cr 
--				join "course" as c
--				on cr."COURSE_ID" = c."COURSE_ID"
--			group by (c."COURSE_NAME", c."COURSE_ID_PREFIX", c."COURSE_ID_NO", cr."STUDENT_ID")
--			having count(c."COURSE_ID_NO") > 1
--		) t
--	group by (t."COURSE_ID_PREFIX", t."COURSE_ID_NO")
--	order by SUM("count") desc
--	limit 3
--) t
--join course c
--on t."COURSE_ID_PREFIX" = c."COURSE_ID_PREFIX" 
--and t."COURSE_ID_NO" = c."COURSE_ID_NO"



--select t."COURSE_ID_PREFIX", t."COURSE_ID_NO" 
--	from (
--		select c."COURSE_ID_PREFIX", c."COURSE_ID_NO", count(c."COURSE_ID_NO")
--			from "course_registration" as cr 
--			join "course" as c
--			on cr."COURSE_ID" = c."COURSE_ID"
--		group by (c."COURSE_ID_PREFIX", c."COURSE_ID_NO", cr."STUDENT_ID")
--		having count(c."COURSE_ID_NO") > 1
--	) t
--group by (t."COURSE_ID_PREFIX", t."COURSE_ID_NO")
--order by SUM("count") desc


--select c."COURSE_ID_PREFIX", c."COURSE_ID_NO", count(c."COURSE_ID_NO")
--	from "course_registration" as cr 
--	join "course" as c
--	on cr."COURSE_ID" = c."COURSE_ID"
--group by (c."COURSE_ID_PREFIX", c."COURSE_ID_NO", cr."STUDENT_ID")
--having count(c."COURSE_ID_NO") > 1
