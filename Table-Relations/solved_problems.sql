CREATE TABLE passports(
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