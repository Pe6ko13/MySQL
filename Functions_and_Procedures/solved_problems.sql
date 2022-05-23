01.
DELIMITER ~
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
    SELECT first_name, last_name FROM employees
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END ~

CALL usp_get_employees_salary_above_35000;


02.
DELIMITER $$ 
CREATE PROCEDURE usp_get_employees_salary_above(salary_integer DOUBLE)
BEGIN 
	SELECT first_name, last_name FROM employees
    WHERE salary >= salary_integer
    ORDER BY first_name, last_name, employee_id;
END $$
    
CALL usp_get_employees_salary_above(35000);


03.
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(str_start VARCHAR(45))
BEGIN
	SELECT t.name AS `town_name` FROM towns t
    WHERE t.name LIKE CONCAT(str_start, '%')
    ORDER BY `town_name`;
END $$

CALL usp_get_towns_starting_with('b');


04.
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(45))
BEGIN
    SELECT e.first_name, e.last_name FROM employees e
    JOIN addresses a ON a.address_id = e.address_id
    JOIN towns t ON t.town_id = a.town_id
    WHERE t.name = town_name
    ORDER BY e.first_name, e.last_name, e.employee_id;
END $$

CALL usp_get_employees_from_town('Sofia');


05.
-- DELIMITER ~
-- CREATE FUNCTION  ufn_get_salary_level(salary DOUBLE(10,4))
-- RETURNS VARCHAR(10)
-- READS SQL DATA
-- DETERMINISTIC
-- BEGIN
--     DECLARE result VARCHAR(10);

--     IF salary < 30000 THEN SET result = 'Low';
--     ELSEIF salary BETWEEN 30000 AND 50000 THEN SET result = 'Average';
--     ELSEIF salary > 50000 THEN SET result = 'High';
--     END IF;

--     RETURN result;
-- END ~

CREATE FUNCTION ufn_get_salary_level(salary DOUBLE(19, 4)) 
RETURNS VARCHAR(7) 
RETURN (
    CASE
        WHEN salary < 30000 THEN 'Low'
        WHEN salary <= 50000 THEN 'Average'
        ELSE 'High'
    END
);

SELECT ufn_get_salary_level(20000);


06.
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(45))
BEGIN
    SELECT first_name, last_name FROM employees
    WHERE ufn_get_salary_level(salary) = salary_level
    ORDER BY first_name DESC , last_name DESC;
END $$
DELIMITER $$

CALL usp_get_employees_by_salary_level('High');


07.
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
BEGIN
    DECLARE idx INT;
    DECLARE symbol VARCHAR(1);
    SET idx := 1;

    WHILE idx <= CHAR_LENGTH(word) DO
        SET symbol := SUBstring(word, idx, 1);
        IF LOCATE(symbol, set_of_letters) = 0 THEN
            RETURN 0;
        END IF;
        SET idx := idx + 1;
    END WHILE;
    RETURN 1;
END $$

SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');


08.
DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
    SELECT CONCAT(first_name, ' ', last_name) AS `full_name` FROM account_holders AS ah
    JOIN (
        SELECT DISTINCT a.account_holder_id FROM accounts AS a
    ) AS a ON ah.id = a.account_holder_id
    ORDER BY `full_name`, ah.id;
END $$

CALL usp_get_holders_full_name();