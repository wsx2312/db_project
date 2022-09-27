SELECT C."NAME", COUNT(C."ID") 
FROM faculty as C, course as D 
WHERE C."ID" = D."PROF_ID" and D."COURSE_ID" in (
SELECT A."COURSE_ID" 
FROM course as A, course_registration as B 
WHERE A."COURSE_ID" = B."COURSE_ID" 
GROUP BY A."COURSE_ID" 
HAVING COUNT(B."STUDENT_ID")::decimal / A."MAX_ENROLLEES"::decimal > 0.8) 
GROUP BY C."ID" 
ORDER BY COUNT(C."ID") desc, C."NAME" asc;