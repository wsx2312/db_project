SELECT
  gt."DAY_OF_WEEK"
  , FORMAT('%s ~ %s' , TO_CHAR(tt."START_TIME" , 'FMHH24:MI') , TO_CHAR(tt."END_TIME" , 'FMHH24:MI'))
  time
FROM ( WITH student_timetable AS (
    SELECT
      ctt."DAY_OF_WEEK"
      , ctt."NO"
      , cr."STUDENT_ID"
    FROM
      course_registration cr
      JOIN course c ON cr."COURSE_ID" = c."COURSE_ID"
      RIGHT JOIN course_to_time ctt ON c."COURSE_ID" = ctt."COURSE_ID"
    WHERE
      c."YEAR" = 2018
      AND c."SEMESTER" = 2
)
    SELECT
      dow."DAY_OF_WEEK"
      , "NO"
    FROM
      day_of_week dow
    CROSS JOIN timetable t
  WHERE
    dow."DAY_OF_WEEK" != 'SAT'
    AND dow."DAY_OF_WEEK" != 'SUN'
  EXCEPT (
    SELECT
      "DAY_OF_WEEK"
      , "NO"
    FROM
      student_timetable
    WHERE
      "STUDENT_ID" = '2018111111'
    UNION
    SELECT
      "DAY_OF_WEEK"
      , "NO"
    FROM
      student_timetable
    WHERE
      "STUDENT_ID" = '2017222222')) gt
JOIN timetable tt ON gt."NO" = tt."NO"
ORDER BY
  CASE WHEN gt."DAY_OF_WEEK" = 'MON' THEN
    1
  WHEN gt."DAY_OF_WEEK" = 'TUE' THEN
    2
  WHEN gt."DAY_OF_WEEK" = 'WED' THEN
    3
  WHEN gt."DAY_OF_WEEK" = 'THU' THEN
    4
  WHEN gt."DAY_OF_WEEK" = 'FRI' THEN
    5
  END ASC
  , gt."NO";
