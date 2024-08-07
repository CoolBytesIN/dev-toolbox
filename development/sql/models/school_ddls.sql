/* Table for all academic years info (Standalone) */
CREATE TABLE public.academic_years (
	academic_year_id VARCHAR(10) NOT NULL PRIMARY KEY,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);


/* Table for all schools info (Standalone) */
CREATE TABLE public.schools (
	school_id SERIAL PRIMARY KEY,
	school_name VARCHAR(30) NOT NULL,
	school_location VARCHAR(60),
	contact_number CHAR(10) CHECK(contact_number ~ '^[0-9]{10}$'),
	email_id VARCHAR(255) CHECK(email_id ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
	established_year INT
);


/* Table for all classes info from all schools */
CREATE TABLE public.classes (
	class_id SERIAL PRIMARY KEY,
	class_name VARCHAR(50) NOT NULL,
	school_id INT NOT NULL,
	
	UNIQUE (class_name, school_id),
	-- INFO: A class is generally mapped to a school (even though the name may repeat across schools), hence this constraint.
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table for all sections info from all classes */
CREATE TABLE public.sections (
	section_id SERIAL PRIMARY KEY,
	section_name VARCHAR(10) NOT NULL,
	class_id INT NOT NULL,
	is_active BOOLEAN,
	
	UNIQUE (section_name, class_id),
	-- INFO: A section is generally mapped to a class (even though the name may repeat across classes), hence this constraint.
	FOREIGN KEY (class_id) REFERENCES public.classes(class_id)
);


/* Table for all subjects info */
CREATE TABLE public.subjects (
	subject_id SERIAL PRIMARY KEY,
	subject_name VARCHAR(50) NOT NULL
);


/* Table for all students info (Standalone) */
CREATE TABLE public.students (
	student_id VARCHAR(20) NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	date_of_birth DATE,
	gender VARCHAR(10) CHECK(gender in ('Male', 'Female', 'Other')),
	aadhaar_no CHAR(12) CHECK(aadhaar_no ~ '^[0-9]{12}$'),
	parent_phone_no CHAR(10) CHECK(parent_phone_no ~ '^[0-9]{10}$'),
	parent_aadhaar_no CHAR(12) CHECK(parent_aadhaar_no ~ '^[0-9]{12}$')
);



/* Table for all student enrollments info */
CREATE TABLE public.student_enrollments (
	enrollment_id VARCHAR(20) NOT NULL,
	student_id VARCHAR(20) NOT NULL,
	admission_time TIMESTAMP NOT NULL, 
	exit_time TIMESTAMP,
	-- INFO: Check constraint for is_active to be FALSE, when exit_time is NOT NULL
	is_active BOOLEAN CHECK(is_active = CASE WHEN exit_time IS NOT NULL THEN FALSE ELSE TRUE END),
	school_id INT NOT NULL, 
	
  PRIMARY KEY (enrollment_id, admission_time),
	FOREIGN KEY (student_id) REFERENCES public.students(student_id),
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table for all students roll number info */
CREATE TABLE public.student_roll_numbers (
	roll_no_id SERIAL PRIMARY KEY,
	student_id VARCHAR(20) NOT NULL,
	roll_no VARCHAR(10) NOT NULL,
	academic_year_id VARCHAR(10) NOT NULL,
	assigned_time TIMESTAMP NOT NULL,
	-- INFO: Date when the roll number is unassigned for a particular student, to be made available for another
	-- INFO: App should take care of updating this, when the student is assigned a new roll number
	revoked_time TIMESTAMP NOT NULL,
	section_id INT NOT NULL,
	
  UNIQUE (roll_no, academic_year_id, assigned_time),
	FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(academic_year_id),
	FOREIGN KEY (student_id) REFERENCES public.students(student_id),
	FOREIGN KEY (section_id) REFERENCES public.sections(section_id)
);


/* Table for all exams info */
CREATE TABLE public.exams (
	exam_id INT NOT NULL PRIMARY KEY,
	exam_name VARCHAR(100) NOT NULL,
	exam_type VARCHAR(70) NOT NULL,
	exam_description VARCHAR(255),
	exam_date DATE NOT NULL,
	academic_year_id VARCHAR(10) NOT NULL,
	status VARCHAR(10) DEFAULT 'Scheduled' CHECK(status in ('Scheduled', 'Completed', 'Cancelled')),
	
	FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(academic_year_id)
);


/* Table for all exam subjects info */
CREATE TABLE public.exam_subjects (
	exam_subject_id SERIAL PRIMARY KEY,
	exam_id  INT NOT NULL,
	subject_id INT NOT NULL,
	total_marks NUMERIC(6, 2) NOT NULL,

	UNIQUE (exam_id, subject_id),
	FOREIGN KEY (exam_id) REFERENCES public.exams(exam_id),
	FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id)
);


/* Table for all student marks info */
CREATE TABLE public.student_marks (
	-- INFO: App should take care of inserting this ID, based on roll_no and revoked_time
	roll_no_id INT NOT NULL,
	-- INFO: App should take care of inserting this ID, based on exam_id and subject_id
	exam_subject_id INT NOT NULL,
	marks_obtained NUMERIC(6, 2) NOT NULL,
	
	PRIMARY KEY (roll_no_id, exam_subject_id),
	FOREIGN KEY (roll_no_id) REFERENCES public.student_roll_numbers(roll_no_id),
	FOREIGN KEY (exam_subject_id) REFERENCES public.exam_subjects(exam_subject_id)
);