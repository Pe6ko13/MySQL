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
ORDER BY e.hire_date