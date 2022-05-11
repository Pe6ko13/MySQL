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