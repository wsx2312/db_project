select "YEAR", "MAJOR_NAME", count(*) as "CLASS_COUNT" from "course" as c1
	join "college" as c2 
		on c1."COURSE_ID_PREFIX" = c2."MAJOR_ID"
where c2."MAJOR_NAME" != '교양'
group by (c1."YEAR", c2."MAJOR_NAME")
order by "YEAR", "CLASS_COUNT" desc;