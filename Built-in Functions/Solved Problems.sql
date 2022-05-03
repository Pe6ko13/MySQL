SELECT `first_name`, `last_name` FROM employees
WHERE first_name LIKE 'Sa%'
ORDER BY employee_id;


SELECT `first_name`, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;


SELECT `first_name` FROM employees
WHERE department_id IN(3,10) 
AND YEAR(hire_date) BETWEEN 1995 AND 2005
ORDER BY employee_id;


SELECT `employee_id`, `first_name`, `last_name` FROM employees
WHERE job_title NOT LIKE '%engineer%'
order by employee_id;


SELECT `name` FROM towns
WHERE length(name) = 5 Or length(name) = 6
ORDER BY name;


SELECT `town_id`, `name` FROM towns
WHERE name LIKE 'M%' OR name LIKE 'K%' OR name LIKE 'B%' OR name LIKE 'E%'
ORDER BY name;


SELECT `town_id`, `name` FROM towns
WHERE name NOT LIKE 'R%' AND name NOT LIKE 'D%' AND name NOT LIKE 'B%'
ORDER BY name;


CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM employees
WHERE year(hire_date) > 2000;


SELECT `first_name`, `last_name` FROM employees
WHERE length(`last_name`) = 5; 


SELECT `country_name`, `iso_code` FROM countries
WHERE country_name LIKE '%a%a%a%'
ORDER BY `iso_code`;


SELECT p.`peak_name`, r.`river_name`, lower(concat(p.`peak_name`, SUBSTRING(r.`river_name`,2))) AS `mix` FROM peaks AS p, rivers AS r
WHERE right(p.`peak_name`, 1) = LEFT(r.`river_name`, 1)
ORDER BY `mix`;


SELECT `name`, date_format(`start`, '%Y-%m-%d') AS `start` FROM games
WHERE year(`start`) BETWEEN 2011 AND 2012
ORDER BY `start` LIMIT 50;


SELECT `user_name`, substring_index(`email`, '@', -1) AS `Email Provider` FROM users
ORDER BY `Email Provider`, `user_name`;


SELECT `user_name`, `ip_address` FROM users
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`;


SELECT `name` AS `game`,
CASE 
WHEN HOUR(`start`) BETWEEN 0 AND 11 THEN 'Morning'
WHEN HOUR(`start`) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN HOUR(`start`) BETWEEN 18 AND 24 THEN 'Evening'
END AS `Part of the day`,
CASE 
WHEN duration <=3 THEN 'Extra Short'
WHEN duration BETWEEN 3 AND 6 THEN 'Short'
WHEN duration BETWEEN 6 AND 10 THEN 'Long'
ELSE 'Extra Long'
END AS `Duration`
FROM games;


SELECT `product_name`, `order_date`,
DATE_ADD(`order_date`,  INTERVAL 3 DAY) AS `pay_due`,
DATE_ADD(`order_date`,  INTERVAL 1 MONTH) AS `delivery_due`
FROM orders