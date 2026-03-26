-- =========================================================================
-- HR Analytics Project - 03 Advanced HR Metrics & Analytics
-- Description: Complex queries simulating FAANG-level business intelligence,
-- utilizing Window Functions, CTEs, and predictive risk flags.
-- =========================================================================

USE hr_analytics_db;

-- 1. Employee Salary Percentile & Peer Comparison
-- Evaluates if an employee is paid below their department median and its correlation to attrition.
WITH DepartmentSalaries AS (
    SELECT 
        EmployeeID,
        Department,
        JobRole,
        MonthlyIncome,
        Attrition,
        PERCENT_RANK() OVER(PARTITION BY Department ORDER BY MonthlyIncome) AS salary_percentile,
        AVG(MonthlyIncome) OVER(PARTITION BY Department) AS dept_avg_salary
    FROM employee_data
)
SELECT 
    Department,
    CASE 
        WHEN salary_percentile <= 0.25 THEN 'Bottom 25% Earner'
        WHEN salary_percentile BETWEEN 0.26 AND 0.75 THEN 'Middle 50% Earner'
        ELSE 'Top 25% Earner'
    END AS pay_band,
    COUNT(*) AS employee_count,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS attrition_rate
FROM DepartmentSalaries
GROUP BY Department, pay_band
ORDER BY Department, attrition_rate DESC;

-- 2. Tenure & Promotion Stagnation (Predictive Indicator)
-- Compares YearsAtCompany vs YearsSinceLastPromotion using CTEs
WITH CareerProgression AS (
    SELECT 
        EmployeeID,
        Department,
        YearsAtCompany,
        YearsSinceLastPromotion,
        Attrition,
        CASE 
            WHEN YearsAtCompany >= 5 AND YearsSinceLastPromotion >= 3 THEN 'High Stagnation Risk'
            WHEN YearsAtCompany < 5 AND YearsSinceLastPromotion >= 2 THEN 'Medium Stagnation Risk'
            ELSE 'Healthy Progression'
        END AS progression_status
    FROM employee_data
)
SELECT 
    progression_status,
    COUNT(*) AS cohort_size,
    ROUND((SUM(CASE WHEN Attrition = 'YES' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS cohort_attrition_rate
FROM CareerProgression
GROUP BY progression_status
ORDER BY cohort_attrition_rate DESC;

-- 3. Flight Risk Dashboard Flag (Complex Logic)
-- Creates a view highlighting active employees with multiple compounding risk factors.
CREATE OR REPLACE VIEW v_High_Flight_Risk_Employees AS
SELECT 
    EmployeeID,
    Department,
    JobRole,
    MonthlyIncome,
    DistanceFromHome_km,
    OverTime,
    'High Risk' AS risk_level,
    CONCAT(
        CASE WHEN OverTime = 'YES' THEN 'Consistent Overtime; ' ELSE '' END,
        CASE WHEN DistanceFromHome_km > 20 THEN 'Long Commute (>20km); ' ELSE '' END,
        CASE WHEN MonthlyIncome < 5000 THEN 'Below Average Pay; ' ELSE '' END,
        CASE WHEN YearsSinceLastPromotion >= 3 THEN 'No Promo in 3+ Years;' ELSE '' END
    ) AS risk_drivers
FROM employee_data
WHERE Attrition = 'NO'
  AND (
      (OverTime = 'YES' AND MonthlyIncome < 6000) OR 
      (DistanceFromHome_km > 20 AND YearsSinceLastPromotion >= 3) OR
      (YearsAtCompany > 4 AND NumCompaniesWorked > 4)
  );

-- Sample output of at-risk individuals to proactively target for retention
SELECT * FROM v_High_Flight_Risk_Employees LIMIT 15;
