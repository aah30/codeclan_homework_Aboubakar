--MVP
--Q1 How many employee records are lacking 
--both a grade and salary?

SELECT 
count(id) 
FROM employees e 
WHERE grade IS NULL AND salary IS NULL 

--Question 2.
--Produce a table with the two following fields (columns):
--the department the employees full name (first and last name)
--Order your resulting table alphabetically by department, and 
--then by last name

SELECT 
department,
concat(first_name,' ',last_name) AS full_name
FROM employees e 
ORDER BY department ,last_name 

-- Q3 Find the details of the top ten highest paid employees 
--who have a last_name beginning with ‘A’.

SELECT 
last_name,
department,
salary 
FROM employees e 
WHERE last_name LIKE 'A%' AND salary IS NOT NULL 
ORDER BY salary DESC
LIMIT 10;

--Q4 Obtain a count by department of the employees 
--who started work with the corporation in 2003.

SELECT 
department,
count(id) AS num_employee_2003
FROM employees e
WHERE  EXTRACT (YEAR  FROM start_date)= 2003 
group by   department; 

--Q5 
SELECT 
department,
fte_hours,
count(id) AS num_employee
FROM employees e
GROUP BY department, fte_hours 
ORDER BY fte_hours 
 
--Q6 Provide a breakdown of the numbers of 
--employees enrolled, not enrolled, and 
--with unknown enrollment status in the corporation pension scheme. 
  
SELECT  
pension_enrol ,
count(id)   
FROM  employees e 
GROUP BY pension_enrol ;

-- Q7 Obtain the details for the employee 
--with the highest salary in the ‘Accounting’
--department who is not enrolled in the pension scheme?

SELECT *
FROM employees e 
WHERE department ='Accounting' AND pension_enrol IS FALSE 
ORDER BY salary DESC NULLS LAST
LIMIT 1;
 
--Q8--

SELECT 
country,
count(id) AS num_employee,
avg(salary) AS avg_salary
FROM employees e 
GROUP BY country HAVING count(id) > 30
ORDER BY avg_salary DESC NULLs LAST

--Q9--

SELECT
first_name,
last_name,
fte_hours,
salary,
(fte_hours * salary) AS effective_yearly_salary
FROM employees e 
WHERE fte_hours * salary  > 30000
  
----Q10-----

SELECT *
FROM employees AS e LEFT JOIN teams AS t 
ON e.team_id =t.id 
WHERE t."name" IN ('Data Team 1','Data Team 2')

--Q11-----
SELECT 
e.first_name,
e.last_name,
pd.local_tax_code 
FROM employees AS e LEFT JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 
WHERE pd.local_tax_code IS NULL  

--Q12
SELECT *,
 (48 * 35 * CAST(t.charge_cost AS int) - salary) * fte_hours AS expected_profit
FROM employees e
LEFT JOIN teams t ON e.team_id = t.id
WHERE t.charge_cost Is NOT NULL
AND salary IS NOT NULL
AND fte_hours IS NOT NULL;



--Q13---
SELECT
first_name,
last_name,
salary
FROM employees e
WHERE country = 'Japan' AND e.fte_hours = (SELECT min(fte_hours) FROM employees e2)

--Q14---
SELECT 
department,
count(id) AS num_lacking_f_name
FROM employees e 
WHERE first_name IS NULL 
GROUP BY department 
ORDER BY num_lacking_f_name DESC, department; 
 
---Q15---
SELECT  
first_name ,
count(id) AS num_shared_first_name
FROM employees e 
WHERE first_name IS NOT NULL 
GROUP BY first_name HAVING  count(id) > 1
ORDER BY num_shared_first_name DESC ,first_name;

----Q16----
SELECT 
department,
count(*)/ (SELECT 
    count(*)
FROM employees 
GROUP BY department
) --sum(count(id)) over() AS proportion_employees
FROM employees 
GROUP BY department, grade 
HAVING grade = 1

 


