WITH grade4_with_no_retake AS (
  SELECT
    s."STUDENT_ID"
    , g."GRADE"
    , c."CREDIT"
    , s."NAME"
  FROM
    students s
    JOIN grade g ON g."STUDENT_ID" = s."STUDENT_ID"
    JOIN course c ON c."COURSE_ID" = g."COURSE_ID"
  WHERE (s."STUDENT_ID"
    , c."COURSE_ID_PREFIX"
    , c."COURSE_ID_NO"
    , CONCAT(c."YEAR"
      , c."SEMESTER")) IN (
    SELECT
      s."STUDENT_ID"
      , c."COURSE_ID_PREFIX"
      , c."COURSE_ID_NO"
      , MAX(CONCAT(c."YEAR"
          , c."SEMESTER")) "YEAR_SEMESTER"
    FROM
      students s
      JOIN grade g ON g."STUDENT_ID" = s."STUDENT_ID"
      JOIN course c ON c."COURSE_ID" = g."COURSE_ID"
    WHERE
      s."GRADE" = 4
    GROUP BY
      (s."STUDENT_ID"
        , c."COURSE_ID_PREFIX"
        , c."COURSE_ID_NO"))
)
, avg_grade AS (
  SELECT
    "STUDENT_ID"
    , SUM("GRADE" * "CREDIT") / SUM("CREDIT") AS "AVG_GRADE"
FROM
  grade4_with_no_retake gs
GROUP BY
  "STUDENT_ID"
)
SELECT
  CONCAT(
  LEFT (s."NAME" , 1) , REPEAT('*' , LENGTH(s."NAME") - 1))
  , s."STUDENT_ID"
  , c."MAJOR_NAME"
  , c."COLLEGE_NAME"
FROM (
  SELECT
    "STUDENT_ID"
  FROM
    grade4_with_no_retake gs
  WHERE
    "GRADE" != 0
  GROUP BY
    "STUDENT_ID"
  HAVING
    SUM("CREDIT") >= 40) gs
  JOIN (
    SELECT
      "STUDENT_ID"
      , SUM("GRADE" * "CREDIT") / SUM("CREDIT") AS "AVG_GRADE"
    FROM
      grade4_with_no_retake gs
    GROUP BY
      "STUDENT_ID") ag ON gs."STUDENT_ID" = ag."STUDENT_ID"
  JOIN students s ON gs."STUDENT_ID" = s."STUDENT_ID"
  JOIN college c ON s."MAJOR_ID" = c."MAJOR_ID"
WHERE
  ag."AVG_GRADE" = (
    SELECT
      MAX("AVG_GRADE")
    FROM
      avg_grade)
  OR ag."AVG_GRADE" = (
    SELECT
      MIN("AVG_GRADE")
    FROM
      avg_grade)
