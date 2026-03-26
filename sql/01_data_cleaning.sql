-- =========================================================================
-- HR Analytics Project - 01 Data Cleaning & Preparation
-- Description: This script sets up the database, creates the foundational 
-- table, and performs basic data quality checks.
-- =========================================================================

-- 1. Create and Use Database
CREATE DATABASE IF NOT EXISTS hr_analytics_db;
USE hr_analytics_db;

-- 2. Create the unified fact/dimension table
CREATE TABLE IF NOT EXISTS employee_data (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    Department VARCHAR(50),
    DistanceFromHome_km INT,
    EducationField VARCHAR(50),
    Gender VARCHAR(20),
    JobRole VARCHAR(50),
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    NumCompaniesWorked INT,
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    TotalWorkingYears INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT
);

-- Note: Data ingestion from raw_data.csv happens via bulk insert/import wizard here.

-- 3. Data Quality & Profiling Checks
-- Check for null values in critical operational columns
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_dept,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_income
FROM employee_data;

-- 4. Standardizing Text Data
-- Example: Ensure Attrition and OverTime are standardized to 'Yes' / 'No'
UPDATE employee_data
SET Attrition = TRIM(UPPER(Attrition)),
    OverTime = TRIM(UPPER(OverTime));

-- Check distinct values
SELECT DISTINCT Attrition FROM employee_data;
SELECT DISTINCT OverTime FROM employee_data;
