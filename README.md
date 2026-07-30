# HR Workforce & Employee Attrition Analysis

## 📌 Project Overview

This project analyzes **22,214 employee records** to understand workforce composition, employee demographics, hiring patterns, employee tenure, and attrition.

The project was designed as an end-to-end **SQL + Power BI HR Analytics project**, starting with raw HR data preparation and cleaning in MySQL and progressing to business-focused analysis and interactive visualization in Power BI.

The main objective was to transform raw employee data into meaningful insights that could help HR teams understand:

* Workforce composition
* Employee demographics
* Department-wise workforce distribution
* Hiring patterns
* Employee tenure
* Employee attrition and termination rates
* High-turnover departments and job roles
* Differences in attrition across gender and work location

---

## 🎯 Business Objective

The analysis aims to answer key HR business questions such as:

1. How many employees are in the organization?
2. What is the gender distribution of employees?
3. What is the race/ethnicity distribution?
4. How is the workforce distributed across age groups?
5. Which departments have the largest workforce?
6. Which departments have the highest termination rates?
7. What is the average employee tenure?
8. How does attrition vary by gender?
9. How does attrition differ between Headquarters and Remote employees?
10. Which job titles have the largest workforce?
11. Which job titles have comparatively high termination rates?
12. How has hiring changed over time?
13. Which departments show potentially stronger or weaker retention patterns?

---

## 🛠️ Tools & Technologies

| Tool         | Purpose                                          |
| ------------ | ------------------------------------------------ |
| **MySQL**    | Data cleaning, validation and SQL analysis       |
| **Power BI** | Interactive dashboard and data visualization     |
| **DAX**      | Power BI calculated columns and measures         |
| **GitHub**   | Project documentation and portfolio presentation |

---

## 📂 Dataset

The dataset contains **22,214 employee records**.

### Important columns

| Column           | Description               |
| ---------------- | ------------------------- |
| `emp_id`         | Employee identifier       |
| `first_name`     | Employee first name       |
| `last_name`      | Employee last name        |
| `birthdate`      | Employee date of birth    |
| `gender`         | Employee gender           |
| `race`           | Race/ethnicity            |
| `department`     | Employee department       |
| `jobtitle`       | Employee job title        |
| `location`       | Headquarters or Remote    |
| `hire_date`      | Employee hire date        |
| `termdate`       | Employee termination date |
| `location_city`  | Employee city             |
| `location_state` | Employee state            |
| `age`            | Calculated employee age   |

---

# 🧹 Data Cleaning & Preparation

Before performing the analysis, the dataset was cleaned and validated using MySQL.

### Key cleaning steps

### 1. Database creation

A dedicated database was created:

```sql
CREATE DATABASE hranalysis;
USE hranalysis;
```

### 2. Column correction

The imported employee ID column contained an encoding issue, so it was renamed:

```sql
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;
```

### 3. Birthdate standardization

Multiple date formats were converted into a consistent MySQL `DATE` format using `STR_TO_DATE()`.

### 4. Hire-date standardization

Hire dates were similarly converted into a consistent `DATE` format.

### 5. Termination-date cleaning

Termination values were converted from timestamp-style values into dates.

Blank termination values were converted to `NULL` so that they could correctly represent active employees.

### 6. Age calculation

An `age` column was created:

```sql
ALTER TABLE hr
ADD COLUMN age INT;

UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());
```

### 7. Data validation

Several validation checks were performed:

* Duplicate employee records
* Missing employee IDs
* Missing birthdates
* Missing hire dates
* Missing departments
* Termination dates occurring before hire dates

The key validation checks returned **0 problematic records**.

---

# 📊 SQL Analysis

The SQL analysis progressed from basic descriptive analysis to moderate and advanced HR analytics.

## Basic Analysis

The initial analysis focused on understanding the workforce:

* Total employees
* Gender distribution
* Race/ethnicity distribution
* Age distribution
* Department distribution
* Workforce by location
* Active employee distribution
* Top job titles

Example:

```sql
SELECT COUNT(emp_id) AS total_employees
FROM hr;
```

Result:

**22,214 employees**

---

# 📈 Moderate-Level Analysis

The analysis was then extended to business-focused HR questions.

### Department Termination Analysis

Termination counts and termination rates were calculated by department.

### Gender Attrition Analysis

Termination rates were compared across gender groups.

### Location Attrition Analysis

Termination rates were compared between:

* Headquarters
* Remote

### Hiring Trend Analysis

Employee hiring patterns were analyzed by year.

### Employee Tenure

Employee tenure was calculated using hire date and termination date.

For active employees, the current date was used as the end date.

### Job-Level Analysis

The project also analyzed:

* Top 10 job titles by employee count
* Job titles with comparatively high termination rates

---

# 🚀 Advanced SQL Analysis

Advanced SQL techniques were used to make the project more analytical and demonstrate practical SQL skills.

### CTEs

Common Table Expressions were used to create reusable intermediate result sets.

### Window Functions

Examples include:

```sql
RANK()
```

and

```sql
ROW_NUMBER()
```

along with:

```sql
PARTITION BY
```

These were used for department ranking and identifying top roles within departments.

### Final Department Retention Summary

The final SQL analysis combined:

* Total employees
* Terminated employees
* Termination rate
* Average tenure

This provided a consolidated view of employee retention by department.

---

# 📊 Power BI Dashboard

The cleaned HR dataset was imported into Power BI to create an interactive HR analytics dashboard.

### Key dashboard areas

#### Workforce Overview

* Total Employees
* Active Employees
* Terminated Employees
* Termination Rate
* Average Tenure

#### Workforce Demographics

* Gender distribution
* Race/ethnicity distribution
* Age distribution
* Department distribution

#### Attrition & Retention

* Termination Rate by Department
* Termination Rate by Gender
* Termination Rate by Location
* Average Tenure by Department

#### Workforce Structure

* Active Employees by Department
* Top Job Titles
* Hiring Trend by Year

---

# ⚠️ Data Quality Consideration

The source data contained some termination dates extending beyond the intended historical analysis period.

Rather than allowing these future-dated records to distort the historical termination trend, the Power BI termination trend visualization was restricted to **31 December 2025**.

The underlying source data was not artificially modified to change these records.

This was treated as a **data-quality and visualization consideration** during dashboard development.

---

# 🔍 Key Business Findings

### Workforce Size

The organization contains:

**22,214 employees**

---

### Gender Distribution

The overall employee counts were:

| Gender         | Employees |
| -------------- | --------: |
| Male           |     9,328 |
| Female         |     8,455 |
| Non-Conforming |       502 |

---

### Race/Ethnicity

The largest race/ethnicity group was:

**White — 6,328 employees**

followed by:

* Two or More Races — 3,648
* Black or African American — 3,619
* Asian — 3,562
* Hispanic or Latino — 2,501
* American Indian or Alaska Native — 1,327
* Native Hawaiian or Other Pacific Islander — 1,229

---

### Department Distribution

Engineering was the largest department:

**6,686 employees**

followed by:

**Accounting — 3,333 employees**

Auditing was the smallest department:

**52 employees**

---

### Attrition

The overall termination rate calculated during the project was approximately:

**17.2%**

The highest department-level termination rate was:

**Auditing — 23.08%**

The lowest was:

**Marketing — 14.57%**

---

### Engineering

Engineering had the largest workforce:

**6,686 employees**

and the highest number of terminations:

**1,185 employees**

However, its termination rate was:

**17.72%**

This demonstrates why both **absolute termination counts and termination rates** should be considered.

---

### Legal

Legal showed a potentially concerning retention pattern:

* Termination rate: **20.26%**
* Average tenure: **14.09 years**

It had one of the highest termination rates and the lowest average tenure among departments.

---

### Auditing

Auditing had the highest termination rate:

**23.08%**

However, the department contains only **52 employees**, with **12 terminations**.

Therefore, the percentage should be interpreted cautiously because small departments can produce large percentage changes from relatively few employee exits.

---

### Marketing

Marketing recorded the lowest department termination rate:

**14.57%**

with:

* 494 employees
* 72 terminations
* 14.48-year average tenure

---

### Work Location

Termination rates were:

| Location     | Termination Rate |
| ------------ | ---------------: |
| Headquarters |           17.98% |
| Remote       |           16.80% |

The difference between the two groups was relatively modest at approximately **1.18 percentage points**.

---

### Average Tenure

The overall average tenure calculated during the analysis was approximately:

**14.80 years**

Auditing had the highest average tenure:

**15.23 years**

while Legal had the lowest:

**14.09 years**

---

### Hiring Trends

Hiring activity was analyzed across **2000–2020**.

The lowest observed hiring count was:

**2000 — 220 employees**

The highest observed hiring count was:

**2018 — 1,147 employees**

Hiring levels were relatively stable across most years after 2001.

---

### Top Job Titles

The most common job titles included:

| Job Title                     | Employees |
| ----------------------------- | --------: |
| Research Assistant II         |       754 |
| Business Analyst              |       708 |
| Human Resources Analyst II    |       613 |
| Research Assistant I          |       538 |
| Account Executive             |       505 |
| Data Visualization Specialist |       457 |
| Staff Accountant I            |       441 |
| Human Resources Analyst       |       408 |
| Software Engineer I           |       397 |
| Systems Administrator I       |       374 |

---

# 💡 Business Recommendations

Based on the analysis, HR could:

1. Investigate the causes of higher turnover in departments such as Legal and Auditing.
2. Examine high-turnover job titles for potential issues related to workload, career progression, compensation, or management.
3. Monitor Engineering closely because of its large workforce and high absolute number of employee exits.
4. Evaluate retention using both termination rate and employee tenure rather than relying on a single KPI.
5. Compare employee experience and career progression across departments with different retention outcomes.
6. Continue monitoring workforce trends through an interactive Power BI dashboard.

---

# 🧠 Skills Demonstrated

### SQL

* Data cleaning
* Data type conversion
* Date manipulation
* NULL handling
* Data validation
* Aggregation
* `COUNT()`
* `SUM()`
* `AVG()`
* `CASE WHEN`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `DATEDIFF()`
* `TIMESTAMPDIFF()`
* `STR_TO_DATE()`
* CTEs
* Window functions
* `RANK()`
* `ROW_NUMBER()`
* `PARTITION BY`

### Power BI

* Data modeling
* KPI cards
* Bar charts
* Line charts
* Demographic visualizations
* Attrition analysis
* DAX measures
* Calculated columns
* Interactive filtering
* Dashboard design

### Business Analytics

* Workforce analysis
* Employee segmentation
* Attrition analysis
* Retention analysis
* Tenure analysis
* Hiring trend analysis
* KPI development
* Business insight generation

---

# 📁 Suggested Repository Structure

```text
HR-Analytics-SQL-PowerBI/
│
├── README.md
│
├── data/
│   └── hr.csv
│
├── sql/
│   ├── data_cleaning.sql
│   └── hr_analysis.sql
│
├── powerbi/
│   └── HR_Analytics_Dashboard.pbix
│
├── screenshots/
│   ├── dashboard_overview.png
│   ├── attrition_analysis.png
│   └── workforce_analysis.png
│
└── docs/
    └── HR_Analytics_Case_Study.pdf
```

---

# 🎯 Conclusion

This project demonstrates an end-to-end HR analytics workflow:

**Raw HR Data → Data Cleaning → Data Validation → SQL Analysis → Advanced SQL → Power BI → Business Insights**

The project shows how SQL can be used not only to retrieve data but also to identify meaningful workforce and attrition patterns, while Power BI can transform those findings into an interactive dashboard for business stakeholders.

The analysis highlights important retention differences across departments, job roles, gender groups, and work locations and demonstrates the importance of combining **scale, termination rate, and tenure** when evaluating workforce stability.
# HR-Workforce_Anallytics-SQL-PowerBI
End-to-end HR Analytics project using MySQL and Power BI to analyze workforce demographics, hiring trends, employee tenure, and attrition, with interactive dashboards and business insights.
