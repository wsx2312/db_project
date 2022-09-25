select "YEAR" as "연도", "MAJOR_NAME" as "전공명", count(*) as "수업의 개수" 
	from "course" as C1 join "college" as C2 
	on C1."COURSE_ID_PREFIX" = C2."MAJOR_ID"
where "MAJOR_NAME" not like '교양'
group by ("YEAR", "MAJOR_NAME")
order by "연도", "수업의 개수" desc