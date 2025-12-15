# HR_SQL_Case_Study
SQL-based HR data cleaning and employee lifecycle analysis

# HR SQL Case Study — Employee Lifecycle Analysis

## 📌 Project Overview
This project simulates a real-world HR data cleaning and analysis scenario using SQL.  
The dataset contains employee join and exit dates with multiple data quality issues such as:
- Missing dates
- Invalid timelines (exit before join)
- Active employees without exit dates

The objective is to identify issues, clean the data, and prepare a final dataset for management reporting.

---

## 🛠 Tools & Skills Used
- SQL (MySQL)
- Data Cleaning & Validation
- CTEs
- Window Functions
- Date Functions
- Business Logic using CASE

---

## 📊 Dataset Details
**Table:** `employees`

| Column Name | Description |
|------------|-------------|
| emp_id | Employee ID |
| emp_name | Employee Name |
| dept | Department |
| join_date | Date of joining |
| exit_date | Date of exit (NULL if active) |

---

## 🗓 Case Study Breakdown

### DAY 1 — Identify Missing Join Dates
Identified employees with missing `join_date` using `IS NULL`.

### DAY 2 — Detect Invalid Timelines
Found employees whose `exit_date` is earlier than `join_date`.

### DAY 3 — Employment Duration
Calculated number of days each employee stayed using `TIMESTAMPDIFF` and `COALESCE`.

### DAY 4 — Employee Classification
Classified employees into:
- Active
- Former
- Missing Data

### DAY 5 — Long-Stayers
Identified employees with tenure greater than 3 years (1095+ days).

### DAY 6 — Temporary Exit Date Handling
Replaced NULL exit dates with `CURRENT_DATE` for interim analysis.

### DAY 7 — Department-wise Average Tenure
Calculated average tenure per department using `AVG()` and `GROUP BY`.

### DAY 8 — Department Seniority Ranking
Used `RANK()` window function to determine employee seniority within departments.

### DAY 9 — Completely Missing Records
Detected unusable records missing both join and exit dates.

### DAY 10 — Final Cleaned Dataset
Created a cleaned dataset using a CTE:
- Replaced missing join dates with `1900-01-01`
- Replaced missing exit dates with `CURRENT_DATE`
- Added `duration_days`
- Added `status` column

---

## ✅ Final Output
The final cleaned dataset is suitable for:
- HR dashboards
- Attrition analysis
- Tenure-based decision making

---

## 📂 Files Included
- `hr_case_study.sql` — Complete SQL queries
- `README.md` — Project explanation

---

## 🙋‍♂️ About Me
I am transitioning into Data Analytics with hands-on SQL, Power BI, and Excel projects focused on real-world business problems.

📌 **LinkedIn:** (add link)  
📌 **GitHub:** (this repo)

