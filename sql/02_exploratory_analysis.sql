-- =========================================================================
-- HR Analytics Project - 02 Exploratory Data Analysis (EDA)
-- Description: SQL queries designed to uncover macro-level trends in 
-- employee turnover across different business dimensions.
-- =========================================================================

USE hr_analytics_db;

-- 1. Overall Attrition Rate
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS attrited_employees,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS overall_attrition_rate
FROM employee_data;

-- 2. Attrition by Department 
SELECT 
    Department,
    COUNT(*) AS employee_count,
    SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS dept_attrition_rate
FROM employee_data
GROUP BY Department
ORDER BY dept_attrition_rate DESC;

-- 3. Attrition by Job Role
SELECT 
    JobRole,
    Department,
    COUNT(*) AS total_roles,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS role_attrition_rate
FROM employee_data
GROUP BY JobRole, Department
HAVING COUNT(*) > 10  -- Filter out statistical anomalies with low sample sizes
ORDER BY role_attrition_rate DESC;

-- 4. The Impact of Overtime on Turnover
SELECT 
    OverTime,
    COUNT(*) AS group_size,
    SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM employee_data
GROUP BY OverTime;

-- 5. Salary Band Attrition Profiling
WITH SalaryBands AS (
    SELECT 
        EmployeeID,
        Attrition,
        MonthlyIncome,
        CASE 
            WHEN MonthlyIncome <= 5000 THEN 'Low (< $5k)'
            WHEN MonthlyIncome BETWEEN 5001 AND 15000 THEN 'Medium ($5k - $15k)'
            WHEN MonthlyIncome > 15000 THEN 'High (> $15k)'
        END AS income_band
    FROM employee_data
)
SELECT 
    income_band,
    COUNT(*) AS total_headcount,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM SalaryBands
GROUP BY income_band
ORDER BY attrition_rate DESC;
