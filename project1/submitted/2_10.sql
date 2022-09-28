SELECT
  A."COURSE_NAME"
FROM
  course AS A
  , course_registration AS B
WHERE
  A."COURSE_ID" = B."COURSE_ID"
  AND B."STUDENT_ID" IN (
    SELECT
      D."STUDENT_ID"
    FROM
      course AS C
      , course_registration AS D
    WHERE
      C."COURSE_ID" = D."COURSE_ID"
    GROUP BY
      D."STUDENT_ID"
    HAVING
      COUNT(D."STUDENT_ID") > 1)
GROUP BY
  A."COURSE_NAME"
ORDER BY
  COUNT(B."STUDENT_ID") DESC
LIMIT 3;
