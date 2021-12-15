--MVP
--Q1(a). Find the first name, last name and team name 
--of employees who are members of teams.

SELECT 
e.first_name,
e.last_name,
t."name" 
FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
WHERE e.first_name IS NOT NULL 
AND e.last_name IS NOT NULL 
 

--(b). Find the first name, last name and team name of employees 
-- who are members of teams and are enrolled in the pension scheme.
SELECT 
e.first_name,
e.last_name,
t."name", 
e.pension_enrol
FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
WHERE e.first_name IS NOT NULL 
AND e.last_name IS NOT NULL 
AND e.pension_enrol IS TRUE 

---(c). Find the first name, last name and team name of employees
-- who are members of teams, where their team has a charge cost greater than 80.

SELECT 
e.first_name,
e.last_name,
t."name", 
t.charge_cost 
FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
WHERE  CAST(t.charge_cost AS int) > 80 
AND e.first_name IS NOT NULL 
AND e.last_name IS NOT NULL 


-- Q 2.
--(a). Get a table of all employees details, 
--together with their local_account_no and local_sort_code, if they have them.
SELECT 
e.*,
pd.local_account_no,
pd.local_sort_code 
FROM employees AS e FULL OUTER  JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id 


--(b). Amend your query above to also return the name of the team 
--that each employee belongs to.
SELECT 
e.*,
pd.local_account_no,
pd.local_sort_code ,
t."name" 
FROM (employees AS e FULL OUTER  JOIN pay_details AS pd 
ON e.pay_detail_id = pd.id)
LEFT JOIN teams AS t ON
e.team_id =t.id 

--Q3.
--(a). Make a table, which has each employee id along 
--with the team that employee belongs to.


SELECT 
e.id ,
t."name" 
FROM  employees AS e LEFT JOIN teams AS t 
ON e.team_id =t.id 

--b). Breakdown the number of employees in each of the teams.
SELECT 
t."name" ,
count(e.id) AS no_empl_in_each_team
 FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
GROUP BY t."name" 

--(c). Order the table above by so 
--that the teams with the least employees come first.
SELECT 
t."name" ,
count(e.id) AS no_empl_in_each_team
 FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
GROUP BY t."name" 
ORDER BY  count(e.id);

--Q 4.
--(a). Create a table with the team id, team name and 
--the count of the number of employees in each team.
SELECT 
t.id,
t."name",
count(e.id) AS Num_empl_in_each_team
FROM employees AS e   LEFT JOIN teams AS t   
ON e.team_id = t.id 
GROUP BY t.id 
ORDER BY  count(e.id);

--(b). The total_day_charge of a team is defined as the charge_cost of the team 
--multiplied by the number of employees in the team. 
--Calculate the total_day_charge for each team.

select  
    t.*,
    count(e.team_id) AS num_employe,
cast(t.charge_cost as int) * count(e.team_id) as total_day_charge
from teams as t left join employees as e
on t.id = e.team_id
group by t.id
--(c). How would you amend your query from above to show only 
--those teams with a total_day_charge greater than 5000?

 
SELECT
    t.id,
    t."name",
    t.total_day_charge
FROM (SELECT
    t.id,
    t."name",
    count(e.id) AS num_employe,
    t.charge_cost,
    CAST(t.charge_cost AS int) * count(e.id) AS total_day_charge
FROM teams AS t LEFT  JOIN employees AS e 
ON t.id = e.team_id 
GROUP BY  t.id
) AS t
WHERE total_day_charge > 5000
