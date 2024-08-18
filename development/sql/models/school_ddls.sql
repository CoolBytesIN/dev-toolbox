/* Table for all academic years info */
CREATE TABLE public.academic_years (
	academic_year_id VARCHAR(10) NOT NULL PRIMARY KEY,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL
);


/* Table for all schools info */
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
	class_desc VARCHAR(255),
	school_id INT NOT NULL,
	
	-- INFO: A class is generally mapped to a school (even though the name may repeat across schools), hence these constraints.
	UNIQUE (class_name, school_id),
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table for all sections info from all classes */
CREATE TABLE public.sections (
	section_id SERIAL PRIMARY KEY,
	section_name VARCHAR(10) NOT NULL,
	section_desc VARCHAR(255),
	class_id INT NOT NULL,
	
	-- INFO: A section is generally mapped to a class (even though the name may repeat across classes), hence these constraints.
	UNIQUE (section_name, class_id),
	FOREIGN KEY (class_id) REFERENCES public.classes(class_id)
);


/* Table for all subjects info */
CREATE TABLE public.subjects (
	subject_id SERIAL PRIMARY KEY,
	subject_name VARCHAR(50) NOT NULL
);


/* Table to contain all students info */
CREATE TABLE public.students (
	student_id VARCHAR(20) NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	date_of_birth DATE,
	gender VARCHAR(10) CHECK(gender IN ('Male', 'Female', 'Other')),
	aadhaar_no CHAR(12) CHECK(aadhaar_no ~ '^[0-9]{12}$'),
	parent_aadhaar_no CHAR(12) CHECK(parent_aadhaar_no ~ '^[0-9]{12}$'),
	parent_phone_no CHAR(10) CHECK(parent_phone_no ~ '^[0-9]{10}$'),
	house_name VARCHAR(255)
);



/* Table to contain all student enrollments info */
CREATE TABLE public.student_enrollments (
	enrollment_id VARCHAR(20) NOT NULL,
	student_id VARCHAR(20) NOT NULL,
	admission_date DATE NOT NULL, 
	exit_date DATE,
	-- INFO: Check constraint for is_active to be False, when exit_date is NOT NULL
	is_active BOOLEAN CHECK(is_active = CASE WHEN exit_date IS NOT NULL THEN FALSE ELSE TRUE END),
	school_id INT NOT NULL, 
	
  PRIMARY KEY (enrollment_id, admission_date),
	FOREIGN KEY (student_id) REFERENCES public.students(student_id),
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table to contain student's placement within a specific academic structure, such as sections or classes, during an academic year. */
CREATE TABLE public.student_academic_records (
	academic_record_id SERIAL PRIMARY KEY,
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


/* Table to contain all exam types - IIT, Olympiad etc. */
CREATE TABLE public.exam_categories (
--	exam_category_id SERIAL PRIMARY KEY,
	exam_category_name VARCHAR(50) PRIMARY KEY
--	UNIQUE (exam_category_name)
);


/* Table to contain all exam set types - Set A, Set B etc. */
CREATE TABLE public.exam_sets (
--	exam_set_id SERIAL PRIMARY KEY,
	exam_set_name VARCHAR(50) PRIMARY KEY
--	UNIQUE (exam_set_name)
);


/* Table to contain all exams info */
CREATE TABLE public.exams (
	exam_id SERIAL PRIMARY KEY,
	exam_name VARCHAR(50) NOT NULL,
	exam_desc VARCHAR(255),
	exam_category_name VARCHAR(50) NOT NULL,
	
	FOREIGN KEY (exam_category_name) REFERENCES public.exam_categories(exam_category_name)
);

/* Table to contain all syllabus info */
CREATE TABLE public.exam_syllabus (
	syllabus_id SERIAL PRIMARY KEY,
	scheduled_date DATE NOT NULL,
	exam_set_name VARCHAR(50) NOT NULL,
	subject_id INT NOT NULL,
	section_id INT NOT NULL,
	subject_syllabus TEXT,
	session_number INT NOT NULL,
	status VARCHAR(20) NOT NULL CHECK(status IN ('Scheduled', 'Conducted', 'Awaiting Results', 'Published', 'Cancelled')),
	total_marks NUMERIC(6, 2) NOT NULL,
	
	UNIQUE (scheduled_date, exam_set_name, subject_id, section_id),
	FOREIGN KEY (exam_set_name) REFERENCES public.exam_sets(exam_set_name),
	FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id),
	FOREIGN KEY (section_id) REFERENCES public.sections(section_id)
);


/* Table to contain all teachers info */
CREATE TABLE public.teachers (
	teacher_id VARCHAR(20) NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50),
	date_of_birth DATE,
	gender VARCHAR(10) CHECK(gender IN ('Male', 'Female', 'Other')),
	aadhaar_no CHAR(12) CHECK(aadhaar_no ~ '^[0-9]{12}$'),
	phone_no CHAR(10) CHECK(phone_no ~ '^[0-9]{10}$'),
	email_id VARCHAR(255) CHECK(email_id ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);


/* Table to contain all teacher enrollments info */
CREATE TABLE public.teacher_enrollments (
	enrollment_id VARCHAR(20) NOT NULL,
	teacher_id VARCHAR(20) NOT NULL,
	hire_date DATE NOT NULL, 
	exit_date DATE,
	-- INFO: Check constraint for is_active to be False, when exit_date is NOT NULL
	is_active BOOLEAN CHECK(is_active = CASE WHEN exit_date IS NOT NULL THEN FALSE ELSE TRUE END),
	school_id INT NOT NULL, 
	
  PRIMARY KEY (enrollment_id, hire_date),
	FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id),
	FOREIGN KEY (school_id) REFERENCES public.schools(school_id)
);


/* Table to contain all teacher placements info */
CREATE TABLE public.teacher_placements (
	teacher_placement_id SERIAL PRIMARY KEY,
	teacher_id VARCHAR(20) NOT NULL,
	subject_id INT NOT NULL,
	section_id INT NOT NULL,
	academic_year_id VARCHAR(10) NOT NULL,
	
	UNIQUE (teacher_id, subject_id, section_id, academic_year_id),
	FOREIGN KEY (teacher_id) REFERENCES public.teachers(teacher_id),
	FOREIGN KEY (subject_id) REFERENCES public.subjects(subject_id),
	FOREIGN KEY (section_id) REFERENCES public.sections(section_id),
	FOREIGN KEY (academic_year_id) REFERENCES public.academic_years(academic_year_id)
);


/* Table to contain all student marks info */
CREATE TABLE public.exam_results (
	academic_record_id INT NOT NULL,
	syllabus_id INT NOT NULL,
	marks_obtained NUMERIC(6, 2) NOT NULL,
	exam_date DATE NOT NULL,
	
	PRIMARY KEY (academic_record_id, syllabus_id),
	FOREIGN KEY (academic_record_id) REFERENCES public.student_academic_records(academic_record_id),
	FOREIGN KEY (syllabus_id) REFERENCES public.exam_syllabus(syllabus_id)
);