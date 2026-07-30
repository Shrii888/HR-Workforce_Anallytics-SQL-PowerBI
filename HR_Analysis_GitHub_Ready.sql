-- ============================================================
-- HR ANALYTICS PROJECT
-- SQL Analysis & Data Cleaning
-- Database: HR_ANALYSIS
-- Table: hr
-- Records: 22,214
-- ============================================================

CREATE DATABASE IF NOT EXISTS HR_ANALYSIS;
USE HR_ANALYSIS;

-- ============================================================
-- 1. INITIAL DATA EXPLORATION
-- ============================================================

SELECT * FROM hr;

SELECT COUNT(*) AS total_rows
FROM hr;

DESCRIBE hr;


-- ============================================================
-- 2. DATA CLEANING
-- ============================================================

-- Rename the imported employee ID column and standardize its type.
ALTER TABLE hr
CHANGE COLUMN `ï»¿id` emp_id VARCHAR(20) NULL;

-- Disable safe updates temporarily for data-cleaning UPDATE statements.
SET SQL_SAFE_UPDATES = 0;


-- ------------------------------------------------------------
-- 2.1 Standardize birthdate
-- ------------------------------------------------------------

UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN
        STR_TO_DATE(birthdate, '%m/%d/%Y')
    WHEN birthdate LIKE '%-%' THEN
        STR_TO_DATE(birthdate, '%m-%d-%Y')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;


-- ------------------------------------------------------------
-- 2.2 Standardize hire_date
-- ------------------------------------------------------------

UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN
        STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date LIKE '%-%' THEN
        STR_TO_DATE(hire_date, '%m-%d-%Y')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;


-- ------------------------------------------------------------
-- 2.3 Clean and standardize termdate
-- ------------------------------------------------------------

-- Inspect the existing termination-date formats.
SELECT DISTINCT termdate
FROM hr
LIMIT 20;

-- Convert UTC timestamp values into date values.
UPDATE hr
SET termdate = DATE(
    STR_TO_DATE(
        REPLACE(termdate, ' UTC', ''),
        '%Y-%m-%d %H:%i:%s'
    )
)
WHERE termdate LIKE '%UTC%';

-- Convert empty strings to NULL.
UPDATE hr
SET termdate = NULL
WHERE termdate = '';

-- The source contained 0000-00-00 for employees who had not been
-- terminated. Convert these values to NULL.
UPDATE hr
SET termdate = NULL
WHERE termdate = '0000-00-00';

-- Verify remaining non-null termination dates.
SELECT termdate
FROM hr
WHERE termdate IS NOT NULL
  AND termdate <> '';

-- Convert termdate from text to DATE.
ALTER TABLE hr
MODIFY COLUMN termdate DATE;


-- ============================================================
-- 3. CREATE AGE COLUMN
-- ============================================================

ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Verify age calculations.
SELECT birthdate, age
FROM hr;

SELECT
    MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr;


-- ============================================================
-- 4. DATA QUALITY CHECKS
-- ============================================================

-- Check for duplicate employee IDs.
SELECT
    emp_id,
    COUNT(*) AS duplicate_count
FROM hr
GROUP BY emp_id
HAVING COUNT(*) > 1;


-- Check for missing key values.
SELECT
    COUNT(*) AS total_rows,
    SUM(emp_id IS NULL) AS missing_id,
    SUM(birthdate IS NULL) AS missing_birthdate,
    SUM(hire_date IS NULL) AS missing_hire_date,
    SUM(department IS NULL) AS missing_department
FROM hr;


-- Check for logically invalid employment dates.
SELECT *
FROM hr
WHERE termdate IS NOT NULL
  AND termdate < hire_date;


-- Re-enable safe updates after cleaning.
SET SQL_SAFE_UPDATES = 1;


-- ============================================================
-- 5. HR BUSINESS ANALYSIS
-- ============================================================


-- ------------------------------------------------------------
-- Q1. How many total employees are in the company?
-- ------------------------------------------------------------

SELECT COUNT(emp_id) AS total_employees
FROM hr;


-- ------------------------------------------------------------
-- Q2. What is the gender breakdown of active employees aged 18+?
-- ------------------------------------------------------------

SELECT
    gender,
    COUNT(*) AS employee_count
FROM hr
WHERE age >= 18
  AND termdate IS NULL
GROUP BY gender
ORDER BY employee_count DESC;


-- ------------------------------------------------------------
-- Q3. What is the race/ethnicity breakdown of employees?
-- ------------------------------------------------------------

SELECT
    race,
    COUNT(*) AS employee_count
FROM hr
GROUP BY race
ORDER BY employee_count DESC;


-- ------------------------------------------------------------
-- Q4. What is the age distribution of employees?
-- ------------------------------------------------------------

SELECT
    age,
    COUNT(*) AS employee_count
FROM hr
GROUP BY age
ORDER BY age;


-- ------------------------------------------------------------
-- Q5. How many employees work in each department?
-- ------------------------------------------------------------

SELECT
    department,
    COUNT(*) AS employee_count
FROM hr
GROUP BY department
ORDER BY employee_count DESC;


-- ------------------------------------------------------------
-- Q6. Which departments have the highest number of terminated employees?
-- ------------------------------------------------------------

SELECT
    department,
    COUNT(*) AS terminated_employees
FROM hr
WHERE termdate IS NOT NULL
GROUP BY department
ORDER BY terminated_employees DESC;


-- ------------------------------------------------------------
-- Q7. What is the termination rate for each department?
-- ------------------------------------------------------------

SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN termdate IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS terminated_employees,
    ROUND(
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS termination_rate
FROM hr
GROUP BY department
ORDER BY termination_rate DESC;


-- ------------------------------------------------------------
-- Q8. What is the average tenure of employees in the company?
-- ------------------------------------------------------------

SELECT
    ROUND(
        AVG(
            CASE
                WHEN termdate IS NOT NULL
                    THEN DATEDIFF(termdate, hire_date) / 365.25
                ELSE DATEDIFF(CURDATE(), hire_date) / 365.25
            END
        ),
        2
    ) AS average_tenure_years
FROM hr;


-- ------------------------------------------------------------
-- Q9. How has the company's hiring trend changed over the years?
-- ------------------------------------------------------------

SELECT
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS employees_hired
FROM hr
GROUP BY YEAR(hire_date)
ORDER BY hire_year;


-- ------------------------------------------------------------
-- Q10. What is the termination rate for each gender?
-- ------------------------------------------------------------

SELECT
    gender,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN termdate IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS terminated_employees,
    ROUND(
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS termination_rate
FROM hr
GROUP BY gender
ORDER BY termination_rate DESC;


-- ------------------------------------------------------------
-- Q11. What is the termination rate for Headquarters vs Remote employees?
-- ------------------------------------------------------------

SELECT
    location,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN termdate IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS terminated_employees,
    ROUND(
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS termination_rate
FROM hr
GROUP BY location
ORDER BY termination_rate DESC;


-- ------------------------------------------------------------
-- Q12. Which departments have the highest and lowest average tenure?
-- ------------------------------------------------------------

SELECT
    department,
    ROUND(
        AVG(
            CASE
                WHEN termdate IS NOT NULL
                    THEN DATEDIFF(termdate, hire_date) / 365.25
                ELSE DATEDIFF(CURDATE(), hire_date) / 365.25
            END
        ),
        2
    ) AS average_tenure_years
FROM hr
GROUP BY department
ORDER BY average_tenure_years DESC;


-- ------------------------------------------------------------
-- Q13. Which departments have the highest number of active employees?
-- ------------------------------------------------------------

SELECT
    department,
    COUNT(*) AS active_employees
FROM hr
WHERE termdate IS NULL
GROUP BY department
ORDER BY active_employees DESC;


-- ------------------------------------------------------------
-- Q14. What are the top 10 job titles by number of employees?
-- ------------------------------------------------------------

SELECT
    jobtitle,
    COUNT(*) AS employee_count
FROM hr
GROUP BY jobtitle
ORDER BY employee_count DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q15. Which job titles have the highest termination rates?
-- Only job titles with at least 50 employees are considered.
-- ------------------------------------------------------------

SELECT
    jobtitle,
    COUNT(*) AS total_employees,
    SUM(
        CASE
            WHEN termdate IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS terminated_employees,
    ROUND(
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS termination_rate
FROM hr
GROUP BY jobtitle
HAVING COUNT(*) >= 50
ORDER BY termination_rate DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q16. How do departments rank based on employee termination rate?
-- Uses RANK() window function.
-- ------------------------------------------------------------

WITH department_stats AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) AS terminated_employees,
        ROUND(
            SUM(
                CASE
                    WHEN termdate IS NOT NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS termination_rate
    FROM hr
    GROUP BY department
)
SELECT
    department,
    total_employees,
    terminated_employees,
    termination_rate,
    RANK() OVER (
        ORDER BY termination_rate DESC
    ) AS termination_rate_rank
FROM department_stats
ORDER BY termination_rate_rank;


-- ------------------------------------------------------------
-- Q17. What are the top 3 most common job titles within each department?
-- Uses ROW_NUMBER() with PARTITION BY.
-- ------------------------------------------------------------

WITH job_counts AS (
    SELECT
        department,
        jobtitle,
        COUNT(*) AS employee_count
    FROM hr
    GROUP BY department, jobtitle
),
ranked_jobs AS (
    SELECT
        department,
        jobtitle,
        employee_count,
        ROW_NUMBER() OVER (
            PARTITION BY department
            ORDER BY employee_count DESC
        ) AS job_rank
    FROM job_counts
)
SELECT
    department,
    jobtitle,
    employee_count,
    job_rank
FROM ranked_jobs
WHERE job_rank <= 3
ORDER BY department, job_rank;


-- ------------------------------------------------------------
-- Q18. Which departments show the strongest and weakest employee
-- retention based on termination rate and average tenure?
-- ------------------------------------------------------------

WITH department_analysis AS (
    SELECT
        department,
        COUNT(*) AS total_employees,
        SUM(
            CASE
                WHEN termdate IS NOT NULL THEN 1
                ELSE 0
            END
        ) AS terminated_employees,
        ROUND(
            SUM(
                CASE
                    WHEN termdate IS NOT NULL THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS termination_rate,
        ROUND(
            AVG(
                CASE
                    WHEN termdate IS NOT NULL
                        THEN DATEDIFF(termdate, hire_date) / 365.25
                    ELSE DATEDIFF(CURDATE(), hire_date) / 365.25
                END
            ),
            2
        ) AS average_tenure_years
    FROM hr
    GROUP BY department
)
SELECT
    department,
    total_employees,
    terminated_employees,
    termination_rate,
    average_tenure_years
FROM department_analysis
ORDER BY termination_rate DESC;


-- ============================================================
-- END OF HR ANALYTICS SQL ANALYSIS
-- ============================================================
