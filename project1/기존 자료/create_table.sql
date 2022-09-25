CREATE TABLE building
(
    "ABBR_NAME" character varying(100) NOT NULL,
    "NAME" character varying(100) NOT NULL,
    "COLLEGE_NAME" character varying(100),
    CONSTRAINT "BUILDING_pkey" PRIMARY KEY ("ABBR_NAME"),
    CONSTRAINT "BUILDING_NAME" UNIQUE ("NAME")
);

CREATE TABLE college
(
    "MAJOR_ID" char(3) NOT NULL,
    "MAJOR_NAME" varchar(20) NOT NULL,
    "COLLEGE_NAME" varchar(20) NOT NULL,
    "CATEGORY" varchar(20) NOT NULL,
    CONSTRAINT "COLLEGES_pkey" PRIMARY KEY ("MAJOR_ID"),
    CONSTRAINT "MAJOR_NAME" UNIQUE ("MAJOR_NAME")
);

CREATE TABLE day_of_week
(
    "DAY_OF_WEEK" character(3) NOT NULL,
    CONSTRAINT "DAY_OF_WEEK_pkey" PRIMARY KEY ("DAY_OF_WEEK")
);

CREATE TABLE lectureroom
(
    "BUILDNO" varchar(10) NOT NULL,
    "ROOMNO" varchar(10) NOT NULL,
    CONSTRAINT "LECTURE_ROOM_pkey" PRIMARY KEY ("BUILDNO", "ROOMNO"),
    CONSTRAINT "BUILD_LECT_ID" FOREIGN KEY ("BUILDNO")
        REFERENCES public.building ("ABBR_NAME") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE semester
(
    "YEAR" integer NOT NULL,
    "SEMESTER" integer NOT NULL,
    "START_DATE" date NOT NULL,
    "END_DATE" date NOT NULL,
    CONSTRAINT "SEMESTER_pkey" PRIMARY KEY ("SEMESTER", "YEAR")
);

CREATE TABLE timetable
(
    "NO" integer NOT NULL,
    "START_TIME" time NOT NULL,
    "END_TIME" time NOT NULL,
    CONSTRAINT "TIMETABLE_pkey" PRIMARY KEY ("NO"),
	CONSTRAINT "END_TIME" UNIQUE ("END_TIME"),
    CONSTRAINT "START_TIME" UNIQUE ("START_TIME")
);

CREATE TABLE faculty
(
    "ID" character(10) NOT NULL,
	"NAME" character varying(20) NOT NULL,
	"MAJOR_ID" character(3) NOT NULL,
    "POSITION" character varying(6) NOT NULL,
    CONSTRAINT "FACULTY_pkey" PRIMARY KEY ("ID"),
    CONSTRAINT "FAC_MAJOR_ID" FOREIGN KEY ("MAJOR_ID")
        REFERENCES public.college ("MAJOR_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE students
(
    "ADMISSION_YEAR" integer NOT NULL,
    "GRADUATE_YEAR" integer,
    "grade" integer NOT NULL,
    "MAJOR_ID" character(3) NOT NULL,
    "STUDENT_ID" character(10) NOT NULL,
    "NAME" character varying(20) NOT NULL,
    CONSTRAINT "STUDENTS_pkey" PRIMARY KEY ("STUDENT_ID"),
    CONSTRAINT "STUDENTS_MAJOR_ID" FOREIGN KEY ("MAJOR_ID")
        REFERENCES public.college ("MAJOR_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE course
(
    "COURSE_ID" integer NOT NULL,
    "YEAR" integer NOT NULL,
    "SEMESTER" integer NOT NULL,
    "COURSE_ID_PREFIX" character(3) NOT NULL,
    "COURSE_ID_NO" character(4) NOT NULL,
    "DIVISION_NO" integer NOT NULL,
    "COURSE_NAME" character varying(100) NOT NULL,
    "PROF_ID" character varying(10) NOT NULL,
    "BUILDNO" character varying(10) NOT NULL,
    "ROOMNO" character varying(10) NOT NULL,
    "CREDIT" integer NOT NULL,
    "MAX_ENROLLEES" integer NOT NULL,
    CONSTRAINT "COURSE_pkey" PRIMARY KEY ("COURSE_ID"),
    CONSTRAINT "UNIQUE_DAY" UNIQUE ("YEAR", "SEMESTER", "COURSE_ID_PREFIX", "COURSE_ID_NO", "DIVISION_NO"),
    CONSTRAINT "COURSE_COLLEGE_ID" FOREIGN KEY ("COURSE_ID_PREFIX")
        REFERENCES public.college ("MAJOR_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "COURSE_FACULTY_ID" FOREIGN KEY ("PROF_ID")
        REFERENCES public.faculty ("ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "COURSE_BUILD_ID" FOREIGN KEY ("BUILDNO", "ROOMNO")
        REFERENCES public.lectureroom ("BUILDNO", "ROOMNO") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE course_registration
(
    "COURSE_ID" integer NOT NULL,
    "STUDENT_ID" character(10) NOT NULL,
    CONSTRAINT "COURSE_REGISTRATION_pkey" PRIMARY KEY ("STUDENT_ID", "COURSE_ID"),
    CONSTRAINT "CO_REG_1" FOREIGN KEY ("COURSE_ID")
        REFERENCES public.course ("COURSE_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "STU_REG_1" FOREIGN KEY ("STUDENT_ID")
        REFERENCES public.students ("STUDENT_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE course_to_time
(
    "COURSE_ID" integer NOT NULL,
    "DAY_OF_WEEK" character(3) NOT NULL,
    "NO" integer NOT NULL,
    CONSTRAINT "CTTU" UNIQUE ("COURSE_ID", "DAY_OF_WEEK", "NO"),
    CONSTRAINT "CTT1" FOREIGN KEY ("COURSE_ID")
        REFERENCES public.course ("COURSE_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CTT2" FOREIGN KEY ("NO")
        REFERENCES public.timetable ("NO") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "CTT3" FOREIGN KEY ("DAY_OF_WEEK")
        REFERENCES public.day_of_week ("DAY_OF_WEEK") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE grade
(
    "COURSE_ID" integer NOT NULL,
    "grade" numeric(2,1) NOT NULL,
    "STUDENT_ID" character(10) NOT NULL,
    CONSTRAINT "GRADE_pkey" PRIMARY KEY ("COURSE_ID", "STUDENT_ID"),
    CONSTRAINT "GRADE_COURSE_ID" FOREIGN KEY ("COURSE_ID")
        REFERENCES public.course ("COURSE_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "GRADE_STUDENTS_ID" FOREIGN KEY ("STUDENT_ID")
        REFERENCES public.students ("STUDENT_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE attendance
(
    "COURSE_ID" integer NOT NULL,
    "STUDENT_ID" character(10) NOT NULL,
    "ABSENCE_TIME" integer NOT NULL,
    CONSTRAINT "ATTENDANCE_pkey" PRIMARY KEY ("COURSE_ID", "STUDENT_ID"),
    CONSTRAINT "ATT_COURSE_ID" FOREIGN KEY ("COURSE_ID")
        REFERENCES public.course ("COURSE_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "ATT_STUDENT_ID" FOREIGN KEY ("STUDENT_ID")
        REFERENCES public.students ("STUDENT_ID") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
