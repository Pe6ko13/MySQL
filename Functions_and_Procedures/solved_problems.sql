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


09.
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money_number DOUBLE)
BEGIN
    SELECT ah.first_name, ah.last_name FROM account_holders AS `ah`
    JOIN accounts AS `a` ON a.account_holder_id = ah.id
    GROUP BY ah.id 
    HAVING SUM(a.balance) > money_number
    ORDER BY a.id;
END $$

CALL usp_get_holders_with_balance_higher_than(7000);


10.
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(init_sum DOUBLE, rate DOUBLE, years INT)
RETURNS DOUBLE(19, 4)
BEGIN
    DECLARE future_value DOUBLE(19, 4);

    SET future_value := init_sum * POW(1 + rate, years);

    RETURN future_value;
END $$

SELECT ufn_calculate_future_value(1000, 0.1, 5);


11.
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(acc_id INT, int_rate DOUBLE(19, 4))
BEGIN
    SELECT ah.id AS `account_id`,
    ah.first_name, ah.last_name,
    a.balance AS `current_balance`,
    ufn_calculate_future_value(a.balance, int_rate, 5) AS `balance_in_5_years`
    FROM account_holders AS ah
    JOIN accounts AS a ON a.account_holder_id = ah.id   
    WHERE ah.id = acc_id;
END $$

CALL usp_calculate_future_value_for_account(1, 0.1);


12.
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount > 0 THEN START TRANSACTION;
        UPDATE accounts AS `a`
        SET a.balance = a.balance + money_amount
        WHERE a.id = account_id;

        IF (SELECT a.balance FROM accounts AS `a`
            WHERE a.id = account_id) < 0 THEN ROLLBACK;
        ELSE COMMIT;
        END IF;
    END IF;
END $$

CALL usp_deposit_money(1, 10);


13.
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
    IF money_amount <= 0 THEN ROLLBACK;
    ELSEIF (SELECT balance FROM accounts
            WHERE id = account_id) >= money_amount THEN 
            UPDATE accounts
            SET balance = balance - money_amount
            WHERE id = account_id;
    END IF;
END $$

CALL usp_withdraw_money(1, 10);


14.
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount decimal(19, 4))
BEGIN 
    START TRANSACTION;
    IF from_account_id NOT IN(
        SELECT id FROM accounts
    ) THEN ROLLBACK;

    ELSEIF to_account_id NOT IN (
        SELECT id FROM accounts
    ) THEN ROLLBACK;

    ELSEIF from_account_id = to_account_id THEN ROLLBACK;

    ELSEIF amount <= 0 THEN ROLLBACK;

    ELSEIF (
        SELECT balance FROM accounts
        WHERE id = from_account_id) < amount THEN ROLLBACK;
    
    ELSE 
        UPDATE accounts
        SET balance = balance - amount
        WHERE id = from_account_id;

        UPDATE accounts
        SET balance = balance + amount
        WHERE id = to_account_id;
    END IF;
    COMMIT;
END $$

CALL usp_transfer_money(1, 2, 10);
    

15.
CREATE TABLE `logs` (
    log_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    account_id INT(11) NOT NULL,
    old_sum DECIMAL(19, 4) NOT NULL,
    new_sum DECIMAL(19, 4) NOT NULL
);

DELIMITER $$
CREATE Trigger `tr_balance_updated`
AFTER UPDATE ON accounts
FOR EACH ROW 
BEGIN
    IF OLD.balance <> NEW.balance THEN
    INSERT INTO logs (account_id, old_sum, new_sum ) 
    VALUES(OLD.id, OLD.balance, NEW.balance);
    END IF;
END $$

call usp_transfer_money(1, 2, 10);


16.
CREATE TABLE notification_emails (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipient INT,
    `subject` VARCHAR(50),
    body TEXT
);

CREATE TRIGGER tr_logs_inserted_emails
AFTER INSERT ON `logs` 
FOR EACH ROW 
BEGIN
    INSERT INTO notification_emails (recipient, `subject`, body)
    VALUES (new.account_id,
            concat('Balance change for account: ', new.account_id),
            concat('On ', DATE(curdate()), 'your balance was changed from',
                new.old_sum, ' to ', new.new_sum)
            );
END

call usp_transfer_money(1, 2, 10);