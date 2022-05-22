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
DELIMITER $ $ 
CREATE PROCEDURE usp_get_employees_salary_above(salary_integer INT)
BEGIN 
	SELECT first_name, last_name FROM employees
    WHERE salary >= salary_integer
    ORDER BY first_name, last_name, employee_id;
END $ $
    
CALL usp_get_employees_salary_above(35000);