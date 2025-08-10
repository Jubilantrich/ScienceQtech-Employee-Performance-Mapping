/* Create a database named employee, then import data_science_team.csv proj_table.csv 
and emp_record_table.csv into the employee database from the given resources. */

CREATE DATABASE employee;
USE employee;

CREATE TABLE IF NOT EXISTS emp_record_table (
    EMP_ID VARCHAR(25) NOT NULL,
    FIRST_NAME VARCHAR(100) NOT NULL,
    LAST_NAME VARCHAR(100) NOT NULL,
    GENDER VARCHAR(25) NOT NULL,
    ROLE_ VARCHAR(25) NOT NULL,
    DEPT VARCHAR(25) NOT NULL,
    EXP_ VARCHAR(25) NOT NULL,
    COUNTRY VARCHAR(25) NOT NULL,
    CONTINENT VARCHAR(25) NOT NULL,
    SALARY FLOAT(25) NOT NULL,
    EMP_RATING VARCHAR(25) NOT NULL,
    MANAGER_ID VARCHAR(25) NOT NULL,
    PROJ_ID VARCHAR(25) NOT NULL
)  ENGINE=INNODB;


CREATE TABLE IF NOT EXISTS Proj_table(
	PROJECT_ID INT(25) NOT NULL,
    PROJ_Name VARCHAR(100) NOT NULL,
    DOMAIN VARCHAR(100) NOT NULL,
    START_DATE varchar (25),
    CLOSURE_DATE VARCHAR(25),
    DEV_QTR VARCHAR(25) NOT NULL,
    PROJ_STATUS VARCHAR(25) NOT NULL
	
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Data_science_team (
    EMP_ID INT(25) NOT NULL,
    FIRST_NAME VARCHAR(100) NOT NULL,
    LAST_NAME VARCHAR(100) NOT NULL,
    GENDER VARCHAR(25) NOT NULL,
    ROLE_ VARCHAR(25) NOT NULL,
    EXP_ VARCHAR(25) NOT NULL,
    DEPT VARCHAR(25) NOT NULL,
    COUNTRY VARCHAR(25) NOT NULL,
    CONTINENT VARCHAR(25) NOT NULL
)  ENGINE=INNODB;

/* Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table,
 and make a list of employees and details of their department */
 
USE employee;

SELECT 
	EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
FROM emp_record_table;

/* Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
less than two
greater than four 
between two and four
 */
 
 -- less than two
USE employee;
SELECT 
	EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING 
FROM 
	emp_record_table
WHERE 
	EMP_RATING < 2;
    
-- greater than four
SELECT 
	EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING 
FROM 
	emp_record_table
WHERE 
	EMP_RATING > 4;
    
 -- between two and four   
USE employee;
SELECT 
	EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING 
FROM 
	emp_record_table
WHERE 
	EMP_RATING > 2 AND EMP_RATING < 4;
    
    
/* Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department
 from the employee table and then give the resultant column alias as NAME.
 */
 
USE employee;
SELECT 
	CONCAT(FIRST_NAME," ", LAST_NAME) AS NAME 
FROM 
	emp_record_table
WHERE 
	DEPT = "FINANCE";
	
/* Write a query to list only those employees who have someone reporting to them. Also, 
show the number of reporters (including the President
 */
 
USE employee;
SELECT 
	MANAGER_ID, count(EMP_ID)
FROM 
	emp_record_table

GROUP BY MANAGER_ID;
	
/* Write a query to list down all the employees from the healthcare and finance departments 
using union. Take data from the employee record table.
 */
 
USE employee;
SELECT * FROM emp_record_table WHERE DEPT = "HEALTHCARE"
UNION
SELECT * FROM emp_record_table WHERE DEPT = "FINANCE";

/* Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING 
grouped by dept. Also include the respective employee 
rating along with the max emp rating for the department
 */
 USE employee;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE_, DEPT, EMP_RATING, MAX(EMP_RATING) AS MAX_RATING FROM emp_record_table
GROUP BY DEPT;

/*Write a query to calculate the minimum and the maximum salary of the employees in each role.
 Take data from the employee record table.
 */
 
USE employee;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE_, DEPT, EMP_RATING, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY FROM emp_record_table
GROUP BY ROLE_;

/*Write a query to assign ranks to each employee based on their experience.
 Take data from the employee record table.
 */
USE employee;
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    CAST(EXP_ AS UNSIGNED) AS EXP, -- convert string EXP_ to INTEGER
    RANK() OVER (ORDER BY CAST(EXP_ AS UNSIGNED) DESC) AS Experience_Rank
FROM emp_record_table;

/*Write a query to create a view that displays employees in various countries 
whose salary is more than six thousand. 
Take data from the employee record table.
 */
USE employee;
CREATE VIEW MYVIEW AS 
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

/*Write a query to create a view that displays employees in various countries 
whose salary is more than six thousand. 
Take data from the employee record table.
 */
USE employee;
SELECT 
    EMP_ID,FIRST_NAME,LAST_NAME,EXP_,ROLE_,DEPT
FROM 
    emp_record_table 
WHERE 
    CAST(EXP_ AS UNSIGNED) > (
        SELECT 10
    );
    
/*Write a query to create a stored procedure to retrieve the details of the employees 
whose experience is more than three years. Take data from the employee record table.
 */
USE employee;

DELIMITER $$

CREATE PROCEDURE Exp_Employee()
BEGIN
    SELECT *
    FROM 
        emp_record_table
    WHERE 
        CAST(EXP_ AS UNSIGNED) > 3;
END $$

DELIMITER ;

CALL Exp_Employee();

/*Write a query using stored functions in the project table to check whether the job profile assigned to 
each employee in the data science team matches the organization’s set standard.
 
The standard being:

For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',

For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',

For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',

For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',

For an employee with the experience of 12 to 16 years assign 'MANAGER'.

 */
USE employee;

DELIMITER $$

CREATE FUNCTION GetStandardRole(exp INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE standard_role VARCHAR(30);

    IF exp <= 2 THEN
        SET standard_role = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET standard_role = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET standard_role = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET standard_role = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET standard_role = 'MANAGER';
    ELSE
        SET standard_role = 'N/A'; -- fallback
    END IF;

    RETURN standard_role;
END $$

DELIMITER ;

SELECT 
    e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    CAST(e.EXP_ AS UNSIGNED) AS Experience,
    e.ROLE_ AS Assigned_Role,
    GetStandardRole(CAST(e.EXP_ AS UNSIGNED)) AS Standard_Role,
    CASE
        WHEN TRIM(e.ROLE_) = GetStandardRole(CAST(e.EXP_ AS UNSIGNED)) THEN 'MATCH'
        ELSE 'MISMATCH'
    END AS Role_Status,
    p.PROJECT_ID,
    p.PROJ_NAME,
    p.DOMAIN,
    p.START_DATE,
    p.CLOSURE_DATE,
    p.PROJ_STATUS
FROM 
    emp_record_table e
LEFT JOIN 
    proj_table p ON e.PROJ_ID = p.PROJECT_ID;

/* Create an index to improve the cost and performance of the query to find the 
employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.

 */
USE employee;

CREATE INDEX idx_on_first_name ON emp_record_table(FIRST_NAME);

SELECT * FROM emp_record_table WHERE FIRST_NAME = "Eric";

/* Write a query to calculate the bonus for all the employees, based on their ratings 
and salaries (Use the formula: 5% of salary * employee rating).

 */
USE employee;

SELECT 
    EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EXP_,SALARY,
    EMP_RATING,
    SALARY * EMP_RATING * (0.05) AS BONUS
FROM emp_record_table;

/*Write a query to calculate the average salary distribution based on the 
continent and country. Take data from the employee record table..
*/
USE employee;
SELECT 
     CONTINENT, COUNTRY,
   ROUND( AVG(SALARY),2) AS AVG_SALARY
FROM emp_record_table
GROUP BY
	CONTINENT, COUNTRY;
