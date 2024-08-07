/* Table for all academic years info (Standalone Metadata) */
CREATE TABLE public.academic_years (
	academic_year_id VARCHAR(10) NOT NULL PRIMARY KEY,
	start_date DATE NOT NULL,
	-- CONSIDER: Generally, Academic Years end dates should be known upfront, hence NOT NULL constraint.
	end_date DATE NOT NULL
);


/* Table for all schools info (Standalone Metadata) */
CREATE TABLE public.schools (
	-- CONSIDER: Make this auto-increment since it has no business meaning
	school_id int NOT NULL PRIMARY KEY,
	school_name varchar(30) NOT NULL,
	school_location varchar(60),
	contact_number varchar(20),
	email_id varchar(64),
	established_year int
);


/* Table for all classes info of all schools */
CREATE TABLE public.classes (
	-- CONSIDER: Make this auto-increment since it has no business meaning
	class_id int NOT NULL PRIMARY KEY,
	-- CONSIDER: class_name can also be made primary key, without the need for an arbitrary class_id
	-- CONSIDER: Do classes need to be linked to a particular school? (Done in school_class_sections. Instead it could be just sections?)
	class_name varchar(50) NOT NULL,
	school_id int NOT NULL,
	
	-- INFO: A class is generally mapped to a school (even though the name may repeat across schools), hence this constraint.
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table for all sections info of all classes */
CREATE TABLE public.sections (
	-- CONSIDER: Make this auto-increment since it has no business meaning
	section_id int NOT NULL PRIMARY KEY,
	-- CONSIDER: section_name can also be made primary key, without the need for an arbitrary section_id
	section_name varchar(10) NOT NULL,
	class_id int NOT NULL,
	is_active Boolean,
	
	-- INFO: A section is generally mapped to a class (even though the name may repeat across classes), hence this constraint.
	FOREIGN KEY (class_id) REFERENCES public.classes(class_id)
);


/* Table for all subjects info of all classes/sections? */
CREATE TABLE public.subjects (
	-- CONSIDER: Make this auto-increment since it has no business meaning
	subject_id int NOT NULL PRIMARY KEY,
	-- CONSIDER: subject_name can also be made primary key, without the need for an arbitrary subject_id
	subject_name varchar(50) NOT NULL
	-- CONSIDER: Check if any foreign key constraints to be enforced
);


/* Table to contain all students info (Standalone Metadata) */
CREATE TABLE public.students (
	-- INFO: Even though Student_ID and Enrollment_ID are same, separate ID is created to avoid this dependency for future use cases. 
	student_id VARCHAR(20) NOT NULL PRIMARY KEY,
	-- INFO: No Foreign Key here since student_enrollments table already references this. Application should take care of this when a student's enrollment_id changes.
	-- CONSIDER: Is this even needed here, when this can be derived from student_enrollments and with exit_date NULL or is_active column?
	current_enrollment_id VARCHAR(20) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50),
	date_of_birth date,
	-- CONSIDER: CHECK constraint is good to avoid invalid values from being inserted
	gender VARCHAR(10) CHECK(gender in ('Male', 'Female', 'Other')),
	-- CONSIDER: If current_enrollment_id is dropped, is_active can be derived from student_enrollments table, so this is redundant
	is_active boolean
);



/* Table to contain all student enrollments info */
CREATE TABLE public.student_enrollments (
	enrollment_id VARCHAR(20) NOT NULL,
	student_id VARCHAR(20) NOT NULL,
	admission_date date NOT NULL, 
	exit_date date,
	-- INFO: Check constraint for is_active to be False, when exit_date is NOT NULL
	is_active Boolean CHECK(is_active = CASE WHEN exit_date IS NOT NULL THEN FALSE ELSE TRUE END),
	school_id int NOT NULL, 
	
  PRIMARY KEY (enrollment_id, admission_date),
	FOREIGN KEY (student_id) REFERENCES public.students(student_id),
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table to contain all students roll number info */
CREATE TABLE public.student_roll_numbers (
	-- CONSIDER: Make this auto-increment since it has no business meaning
	roll_no_id int NOT NULL PRIMARY KEY,
	student_id VARCHAR(20) NOT NULL,
	roll_no varchar(10) NOT NULL,
	academic_year_id VARCHAR(10) NOT NULL,
	assigned_date DATE NOT NULL,
	-- INFO: Date when the roll number is unassigned for a particular student, to be made available for another
	-- INFO: App should take care of updating this, when the student is assigned a new roll number
	revoked_date DATE NOT NULL,
	-- CONSIDER: Redundant since revoked_date = NULL indicates the same.
	is_active Boolean,
	-- INFO: The following field and its Foreign Key constraint is not really required, but good to have to ensure that entered data is valid.
	-- CONSIDER: Evaluate if this needs to be school or class or section
	section_id int NOT NULL,
	
  UNIQUE (roll_no, academic_year_id, assigned_date),
	FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(academic_year_id),
	FOREIGN KEY (student_id) REFERENCES public.students(student_id),
	FOREIGN KEY (section_id) REFERENCES public.sections(section_id)
);


/* Table to contain all exams info */
CREATE TABLE public.exams (
	exam_id int NOT NULL PRIMARY KEY,
	exam_name varchar(100) NOT NULL,
	exam_type varchar(70) NOT NULL,
	-- CONSIDER: Use varchar(255) for better performance
	exam_description TEXT,
	exam_date date NOT NULL,
	academic_year_id VARCHAR(10) NOT NULL,
	status VARCHAR(10) DEFAULT 'Scheduled' CHECK(status in ('Scheduled', 'Completed', 'Cancelled')),
	-- CONSIDER: Total marks is missing?
	
	FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(academic_year_id)
);


/* Table to contain all student marks info */
-- CONSIDER: Changed table name to a simpler one
CREATE TABLE public.student_marks (
	exam_id int NOT NULL,
	subject_id int NOT NULL,
	-- CONSIDER: Application should take care of inserting this ID, based on roll_no and is_active state
	roll_no_id int NOT NULL,
	marks_obtained NUMERIC(10, 2) NOT NULL,
	
	PRIMARY KEY (exam_id, subject_id, roll_no_id),
	FOREIGN KEY (exam_id) REFERENCES public.exams(exam_id),
	FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id),
	FOREIGN KEY (roll_no_id) REFERENCES public.student_roll_numbers(roll_no_id)
);