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

INSERT INTO passports VALUES(
    
);