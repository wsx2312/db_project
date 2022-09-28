SELECT
  C."NAME"
  , COUNT(C."ID")
FROM
  faculty AS C
  , course AS D
WHERE
  C."ID" = D."PROF_ID"
  AND D."COURSE_ID" IN (
    SELECT
      A."COURSE_ID"
    FROM
      course AS A
      , course_registration AS B
    WHERE
      A."COURSE_ID" = B."COURSE_ID"
    GROUP BY
      A."COURSE_ID"
    HAVING
      COUNT(B."STUDENT_ID")::decimal / A."MAX_ENROLLEES"::decimal > 0.8)
GROUP BY
  C."ID"
ORDER BY
  COUNT(C."ID") DESC
  , C."NAME" ASC;
