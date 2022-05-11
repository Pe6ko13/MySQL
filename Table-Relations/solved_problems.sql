1. CREATE TABLE passports(
    passport_id INT PRIMARY KEY,
    passport_number VARCHAR(8) UNIQUE NOT NULL
);

CREATE TABLE persons (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL, 
    passport_id INT NOT NULL UNIQUE,
    CONSTRAINT fk_persons_passports
    FOREIGN KEY (passport_id) REFERENCES passports(passport_id)
);

INSERT INTO passports VALUES(101, 'N34FG21B'), (102, 'K65LO4R7'), (103, 'ZE657QP2');

INSERT INTO persons(first_name, salary, passport_id)
VALUES('Roberto', '43300.00', 102),
('Tom', 56100.00, 103), 
('Yana', 60200.00, 101);


2. CREATE TABLE manufacturers(
    manufacturers_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) not NULL,
    established_on DATE
);

INSERT INTO manufacturers(`name`, established_on) 
VALUES('BMW', '1916-03-01'), ('Tesla', '2003-01-09'), ('Lada', '1966-05-01');

CREATE TABLE models (
    model_id INT NOT NULL UNIQUE PRIMARY KEY,
    `name` VARCHAR(25),
    manufacturer_id INT NOT NULL

);

ALTER TABLE models
ADD CONSTRAINT fk_manif_models FOREIGN KEY(manufacturer_id)
REFERENCES manufacturers(manufacturer_id);

INSERT INTO models(model_id, `name`, manufacturer_id) 
VALUES(101, 'X1', 1), (102, 'i6', 1), (103, 'S', 2), (104, 'X', 2),
(105, 'Model 3', 2), (106, 'Niva', 3), (107, 'Vesta', 3);


3. CREATE TABLE students(
    student_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(20) NOT NULL
);

INSERT INTO students (`name`) VALUES('Mila'), ('Toni'), ('Ron');

CREATE TABLE exams (
    exam_id INT not NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) not NULL
);

INSERT INTO exams VALUES(101, 'SpringMVC'), (102,'Neo4j'), (103,'Oracle 11g');

CREATE TABLE students_exams (
    student_id INT not NULL,
    exam_id INT NOT NULL,
    CONSTRAINT fk_students_exams_students
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_students_exams_exams
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

INSERT INTO students_exams VALUES(1, 101), (1, 102), (2, 101), (3, 103), (2, 102), (2, 103);


4. CREATE TABLE teachers (
    teacher_id INT not NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(25) NOT NULL,
    manager_id INT  
) AUTO_INCREMENT = 101;

INSERT INTO teachers (`name`, manager_id) VALUES('John', NULL), ('Maya', 106), ('Silvi', 106), ('Ted', 105), ('Mark', 101), ('Greta', 101);

ALTER TABLE teachers ADD
CONSTRAINT fk_manager_teacher
FOREIGN KEY (manager_id) REFERENCES teachers(teacher_id);


SELECT m.mountain_range, p.peak_name, p.elevation AS `peak_elevation`
FROM `mountains` AS m
JOIN `peaks` AS p ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY `peak_elevation` DESC;