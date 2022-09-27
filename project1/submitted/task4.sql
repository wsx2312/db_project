SELECT
  g."AVG_GRADE"
  , g."STUDENT_ID"
  , g."GRADE"
  , g."MAJOR_NAME"
  , g."COLLEGE_NAME"
FROM (
  SELECT
    g."STUDENT_ID"
    , g."AVG_GRADE"
    , s."GRADE"
    , c."MAJOR_NAME"
    , c."COLLEGE_NAME"
    , c."MAJOR_ID"
  FROM (
    SELECT
      g."STUDENT_ID"
      , SUM(g."GRADE" * c."CREDIT") / SUM(c."CREDIT") AS "AVG_GRADE"
    FROM
      course c
      JOIN grade g ON c."COURSE_ID" = g."COURSE_ID"
    WHERE
      c."YEAR" = 2018
      AND c."SEMESTER" = 2
    GROUP BY
      g."STUDENT_ID") g
    JOIN students s ON g."STUDENT_ID" = s."STUDENT_ID"
    JOIN college c ON s."MAJOR_ID" = c."MAJOR_ID"
  WHERE
    s."GRADE" BETWEEN 1 AND 4) g
  JOIN (
    SELECT
      s."GRADE"
      , s."MAJOR_ID"
      , MAX(g."AVG_GRADE") AS "HIGHEST_GRADE"
    FROM (
      SELECT
        g."STUDENT_ID"
        , SUM(g."GRADE" * c."CREDIT") / SUM(c."CREDIT") AS "AVG_GRADE"
      FROM
        course c
        JOIN grade g ON c."COURSE_ID" = g."COURSE_ID"
      WHERE
        "YEAR" = 2018
        AND "SEMESTER" = 2
      GROUP BY
        g."STUDENT_ID") g
      JOIN students s ON g."STUDENT_ID" = s."STUDENT_ID"
    WHERE
      s."GRADE" BETWEEN 1 AND 4
    GROUP BY
      (s."GRADE"
        , s."MAJOR_ID")) mg ON g."AVG_GRADE" = mg."HIGHEST_GRADE"
  AND g."GRADE" = mg."GRADE"
  AND g."MAJOR_ID" = mg."MAJOR_ID"
ORDER BY
  g."MAJOR_NAME"
  , g."GRADE"
  , g."STUDENT_ID";
