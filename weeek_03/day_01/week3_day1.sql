/* MVP */

/* Q1 Question 1.
Find all the employees who work in the ‘Human Resources’ department.
*/

 SELECT *
FROM employees e 
WHERE department ='Human Resources'

/* Q2 Question 2.
Get the first_name, last_name, and country of the employees
 who work in the ‘Legal’ department.
*/
 SELECT 
first_name,
last_name ,
country
FROM employees e 
WHERE department ='Legal'

/* Q3 Question 3.
Count the number of employees based in Portugal
*/
 SELECT 
 count(id) AS No_of_employees_in_Portugal
FROM employees e 
WHERE country ='Portugal'

/* Q4 Question 4.
Count the number of employees based in either Portugal or Spain.
*/
 SELECT 
 count(id) AS No_of_employees_in_Portugal_or_Spain
FROM employees e 
WHERE country ='Portugal'  OR   country ='Spain'

/* Q5 Question 5.
Count the number of pay_details records lacking a local_account_no.
*/
SELECT * 
FROM pay_details pd ;

 SELECT 
 count(id) AS lacking_local_account_no
FROM pay_details pd 
 WHERE local_account_no IS  NULL 
 
 /* Q6 Question 6.
Are there any pay_details records lacking both a local_account_no and iban number?
*/
  SELECT 
 count(id) AS lacking_local_account_no_and_iban
FROM pay_details pd 
 WHERE local_account_no IS NULL  AND   iban IS  NULL 
 
  /* Q7 Question 7.
Get a table with employees first_name and last_name ordered alphabetically 
by last_name (put any NULLs last).
*/
 SELECT 
 first_name,
 last_name
 FROM employees e 
 ORDER BY last_name ASC NULLS LAST
 
   /* Q8 Question 8.
Get a table of employees first_name, last_name and country,
 ordered alphabetically first by country and then by last_name (put any NULLs last).
 */
  SELECT 
 first_name,
 last_name,
 country
 FROM employees e 
 ORDER BY country, last_name ASC NULLS LAST

    /* Q9 Question 9.
Find the details of the top ten highest paid employees in the corporation.
 */
SELECT *
FROM employees e 
WHERE salary IS NOT NULL 
ORDER BY salary DESC 
LIMIT 10

  /* Q10 Question 10
Find the first_name, last_name and salary of the lowest paid employee in Hungary.
*/
SELECT 
 first_name,
 last_name,
 salary
 FROM employees e 
 WHERE country ='Hungary'
 ORDER BY salary ASC 
 
  /* Q11 Question 11
How many employees have a first_name beginning with ‘F’?
*/
SELECT 
count(id) AS total_no_of_first_name_start_with_F
FROM employees 
WHERE  first_name LIKE 'F%'

  /* Q12 Question 12
Find all the details of any employees with a ‘yahoo’ email address?
*/
SELECT *
 FROM employees 
WHERE  email    ~*'yahoo';

  /* Q13 Question 13
   Count the number of pension enrolled employees 
   not based in either France or Germany.
 */

SELECT 
count(id) AS pen_enrolled_emp_not_in_france_Germany
FROM employees 
WHERE pension_enrol = TRUE  AND (country !='France' OR  country !='Germany')

  /* Q14 Question 14
What is the maximum salary among those employees 
in the ‘Engineering’ department who work 1.0 full-time equivalent hours (fte_hours)?
 */

SELECT 
max(salary) AS Max_salary
FROM employees e  
WHERE department ='Engineering' AND fte_hours >=1.0;

  /* Q15 Question 15
Return a table containing each employees first_name, last_name, 
full-time equivalent hours (fte_hours),salary, and 
a new column effective_yearly_salary which should contain fte_hours 
multiplied by salary.
 */
select 
        first_name ,
        last_name ,
        fte_hours ,
        salary ,
      concat(salary * fte_hours)  AS  effective_yearly_salary 
from employees e 

/*2 Extension */

  /* Q16 Question 16
*/

SELECT 
first_name , 
last_name,
department,
concat(first_name, ' ', last_name,'-',department) AS badge_label -- united
FROM  employees 
WHERE first_name IS NOT NULL 
AND last_name IS NOT NULL 
AND department IS NOT NULL 