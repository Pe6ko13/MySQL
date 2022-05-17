1.
SELECT `e`.employee_id, `e`.job_title, `e`.address_id, `a`.address_text 
FROM employees AS `e`
JOIN addresses AS `a`
ON `e`.address_id = `a`.address_id
ORDER BY `e`.address_id
LIMIT 5;


2.
SELECT e.first_name, e.last_name, t.name AS `town`, a.address_text
FROM employees AS `e`
JOIN addresses AS `a` ON e.address_id = a.address_id
JOIN towns AS `t` ON a.town_id = t.town_id
ORDER BY e.first_name, e.last_name
LIMIT 5;

3.
SELECT e.employee_id, e.first_name, e.last_name, d.name AS `department_name`
FROM employees AS `e`
JOIN departments AS `d` ON e.department_id = d.department_id
WHERE d.name = 'Sales'
ORDER BY e.employee_id DESC;

4.
SELECT e.employee_id, e.first_name, Round(e.salary, 2), d.name AS `department_name`
FROM employees AS `e`
JOIN departments AS `d` ON e.department_id = d.department_id
WHERE e.salary > 15000
ORDER BY d.department_id DESC LIMIT 5;

5.
SELECT e.employee_id, e.first_name FROM employees AS `e`
LEFT JOIN employees_projects AS `ep`
ON ep.employee_id = e.employee_id
WHERE ep.project_id IS NULL
ORDER BY e.employee_id DESC limit 3;

6.
SELECT e.first_name, e.last_name, e.hire_date, d.name AS `dept_name`
FROM employees AS `e`
JOIN departments AS `d` ON e.department_id = d.department_id
WHERE e.hire_date > '1999-01-01' AND d.name = 'Sales' OR  d.name = 'Finance'
ORDER BY e.hire_date;

7.
SELECT e.employee_id, e.first_name, p.name AS `poject_name`
FROM employees AS `e`
JOIN employees_projects AS `ep` ON e.employee_id = ep.employee_id
JOIN projects AS `p` ON ep.project_id = p.project_id
WHERE p.start_date > '2002-08-13' AND p.end_date IS NULL
ORDER BY e.first_name, p.name LIMIT 5;

8.
SELECT e.employee_id, e.first_name, 
    IF(
        year(p.start_date) >= 2005, NULL, p.name
    ) AS `project_name`
FROM employees AS `e`
JOIN employees_projects AS `ep` ON e.employee_id = ep.employee_id
JOIN projects AS `p` ON ep.project_id = p.project_id
WHERE e.employee_id = 24
ORDER BY p.name;

9.
SELECT e.employee_id, e.first_name, e2.employee_id, e2.first_name AS `manager_name`
FROM employees AS e
JOIN employees AS e2 ON e2.employee_id = e.manager_id 
WHERE e.manager_id IN(3, 7)
ORDER BY first_name;

10.
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS `employee_name`,
CONCAT(e2.first_name, ' ', e2.last_name) AS `manager_name`,
d.name AS `department_name` FROM employees AS `e`
JOIN employees AS `e2` ON e2.employee_id = e.manager_id 
JOIN departments AS `d` ON e.department_id = d.department_id
WHERE e.manager_id != 0
ORDER BY e.employee_id LIMIT 5;

11.
SELECT round(MIN(min_avg_salary), 2) AS `min_average_salary`
FROM (
    SELECT AVG(salary) AS `min_avg_salary` FROM employees
    GROUP BY department_id
) AS min_salaries;

12.
SELECT mc.country_code, m.mountain_range, p.peak_name, p.elevation
FROM peaks AS `p`
JOIN mountains AS `m` ON p.mountain_id = m.id
JOIN mountains_countries AS `mc` ON mc.mountain_id = m.id
WHERE mc.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;

13.
SELECT c.country_code, COUNT(mc.mountain_id) AS `mountain_range`
FROM countries AS `c`
JOIN mountains_countries AS `mc` ON c.country_code = mc.country_code
WHERE c.country_code IN ('BG', 'RU', 'US')
GROUP BY c.country_code
ORDER BY mountain_range DESC;

14.
SELECT c.country_name, r.river_name
FROM countries AS `c`
LEFT JOIN countries_rivers AS `cr` ON c.country_code = cr.country_code
LEFT JOIN rivers AS `r` ON r.id = cr.river_id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name;

15.
SELECT c.continent_code, c.currency_code, COUNT(*) AS `currency_usage`
FROM countries AS `c`
GROUP BY c.continent_code, currency_code
HAVING currency_usage > 1 AND currency_usage = (
    SELECT COUNT(*) AS `cnt` FROM countries AS `c2`
    WHERE c2.continent_code = c.continent_code
    GROUP BY c2.currency_code
    ORDER BY cnt DESC 
    LIMIT 1
)
ORDER BY c.continent_code, c.currency_code;


SELECT COUNT(*) AS `country_count` 
FROM (
    SELECT country_code FROM mountains_countries
    GROUP BY country_code
) AS `cc`
RIGHT JOIN countries AS `c` ON c.country_code = cc.country_code
WHERE cc.country_code IS NULL;


SELECT c.country_name, 
    MAX(p.elevation) AS `highest_peak_elevation`,
    MAX(r.length) AS `longest_river_length`
FROM countries AS `c`
JOIN mountains_countries AS `mc` ON mc.country_code = c.country_code
LEFT JOIN peaks AS `p` ON mc.mountain_id = p.mountain_id
JOIN countries_rivers AS `cr` ON cr.country_code = c. country_code
LEFT JOIN rivers AS `r` ON cr.river_id = r.id
GROUP BY c.country_name
ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name
LIMIT 5;


