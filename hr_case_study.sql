CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept VARCHAR(50),
    join_date DATE,
    exit_date DATE
);

INSERT INTO employees VALUES
(1, 'Arjun',     'Sales',      '2020-01-10', '2023-03-15'),
(2, 'Priya',     'HR',         '2021-05-20', NULL),
(3, 'Karan',     'Marketing',  '2022-11-01', '2022-07-01'), -- ERROR: exit before join
(4, 'Meera',     'Finance',    '2019-02-18', '2020-01-01'),
(5, 'Sam',       'Sales',      '2020-08-12', NULL),
(6, 'Divya',     'HR',         NULL,          '2022-12-01'), -- Missing join date
(7, 'Vikram',    'Finance',    '2023-05-01', NULL),
(8, 'Nisha',     'Sales',      NULL,          NULL),         -- Missing both
(9, 'Ruth',      'Marketing',  '2021-01-10', '2021-01-05'),  -- ERROR: exit < join
(10,'Daniel',    'IT',         '2020-10-25', '2025-02-10');

------------------------ Start ---------------------------

/* 🗓️ DAY 1 — Identify Missing Join Dates

📌 Story:
Some employees appear in the system without join dates. HR suspects data corruption.

📝 Challenge:
Write a SQL query to list all employees where join_date IS NULL. */

SELECT * 
FROM employees
	WHERE join_date IS NULL;
    
    

/* 🗓️ DAY 2 — Find “Time Travelers” (Exit Before Join)
📌 Story:
Some employees exited before they joined — impossible in reality.

📝 Challenge:
Find all employees where exit_date < join_date. */

SELECT * 
FROM employees
	where exit_date < join_date;

/* 🗓️ DAY 3 — Calculate Employment Duration

📌 Story:
HR wants the number of days each employee stayed.

📝 Challenge:
Calculate:
DATEDIFF(exit_date OR CURRENT_DATE, join_date)
Use COALESCE for NULL exit dates. */

SELECT emp_id, emp_name, dept,
	COALESCE(timestampdiff(DAY, join_date, exit_date), 0) AS num_of_days
FROM employees;

SELECT 
	emp_id,
    emp_name,
    dept,
    timestampdiff(
		DAY,
        join_date,
        COALESCE(exit_date, CURRENT_DATE)
        ) AS num_of_days
FROM employees;

/*  DAY 4 — Classify Employees

📌 Story:
CEO wants to categorize employees into:

•	“Active” (exit_date is NULL)
•	“Former” (exit_date not NULL)
•	“Missing Data” (join_date OR exit_date is NULL)

📝 Challenge:
Use CASE to create status column. */

SELECT emp_id,
		emp_name,
        dept,
        join_date,
        exit_date,
        CASE	
			WHEN join_date IS NULL OR exit_date IS NULL THEN 'Missing Data'
            WHEN exit_date IS NOT NULL THEN 'Former'
            ELSE 'Active'
		END AS status
FROM employees;

/* 
🗓️ DAY 5 — Detect Long-Stayers (3+ Years)

📌 Story:
Who stayed more than 3 years? HR wants to reward them.

📝 Challenge:
Find employees with > 1095 days difference (using DATEDIFF). */

SELECT emp_id, emp_name, dept, 
		TIMESTAMPDIFF (
			DAY,
            join_date,
            COALESCE(exit_date, CURRENT_DATE)
            ) AS total_days
FROM employees
WHERE TIMESTAMPDIFF (
			DAY,
            join_date,
            COALESCE(exit_date, CURRENT_DATE)
            ) > 1095;
            

/* 🗓️ DAY 6 — Fill Missing Exit Dates

📌 Story:
Some employees never updated exit date.
We temporarily set exit_date = CURRENT_DATE.

📝 Challenge:
Use COALESCE(exit_date, CURDATE()) and show cleaned data. */

SELECT emp_id, emp_name, dept, join_date,
	COALESCE(exit_date, current_date()) as temp_exit_date
FROM employees;


/* 🗓️ DAY 7 — Department-Wise Average Tenure

📌 Story:

Which department retains employees longest?

📝 Challenge:
Use:
•	DATEDIFF
•	AVG
•	GROUP BY dept */

SELECT dept, ROUND(AVG(timestampdiff(DAY, join_date, COALESCE(exit_date, current_date)))) as avg_tenure_days
FROM employees
GROUP BY dept;


/* 
 DAY 8 — Timeline Rank
📌 Story:
HR wants to know seniority inside each department.
📝 Challenge:
Use:
RANK() OVER(PARTITION BY dept ORDER BY join_date ASC) */


SELECT emp_id, emp_name, dept,
	RANK() OVER(PARTITION BY dept ORDER BY join_date) as seniority
FROM employees;

/* 
🗓️ DAY 9 — Detect Gaps in Employee Timeline

📌 Story:
Find employees missing BOTH join and exit date → completely unusable records.

📝 Challenge:
WHERE join_date IS NULL AND exit_date IS NULL */


SELECT * FROM employees
	WHERE join_date IS NULL 
    AND exit_date IS NULL;
    
    
/* 
DAY 10 — Build the Final Cleaned Table

📌 Story:
You must deliver a clean HR dataset back to management.

📝 Challenge:
Using a CTE:
•	Replace NULL join dates with '1900-01-01'
•	Replace NULL exit dates with CURRENT_DATE
•	Add a “duration_days” column
•	Add “status” column using CASE */

select * from employees;


WITH cleaned_employees AS (
    SELECT 
        emp_id,
        emp_name,
        dept,
        COALESCE(join_date, '1900-01-01') AS updated_join_date,
        COALESCE(exit_date, CURRENT_DATE) AS updated_exit_date,
        TIMESTAMPDIFF(
            DAY,
            COALESCE(join_date, '1900-01-01'),
            COALESCE(exit_date, CURRENT_DATE)
        ) AS duration_days,
        CASE
            WHEN join_date IS NULL THEN 'Missing Data'
            WHEN exit_date IS NULL THEN 'Active'
            ELSE 'Former'
        END AS status
    FROM employees
)

SELECT *
FROM cleaned_employees
order by duration_days;

------------------------ END ------------------------

