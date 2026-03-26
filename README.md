# 📊 HR Attrition & Retention Analytics (End-to-End Data Pipeline)

An enterprise-grade Data Analytics project designed to identify core drivers of employee turnover, model retention risk, and provide actionable, data-driven HR strategies to reduce organizational attrition costs.

---

## 🚀 Executive Summary & Business Impact

**The Problem:** High employee turnover is an expensive drain on organizational resources, costing an estimated $50k-$150k per lost employee in recruitment, onboarding, and lost productivity. 
**The Solution:** This project builds an interactive Power BI dashboard backed by a robust SQL data pipeline to transition HR from 'reactive' reporting to 'proactive' retention strategies.

### 💡 Key Findings & Strategic Recommendations
- **Overtime is Toxic:** Employees working consistent overtime show a **30.53% attrition rate** compared to **10.44%** for non-overtime workers. 
  *👉 Recommendation: Implement hard-caps on weekly overtime hours or introduce mandatory cooling-off periods for high-burnout roles like Sales Reps.*
- **Salary Band Sensitivity:** Attrition in the lowest salary bracket (<$5k) is exceptionally high at **21.76%**.
  *👉 Recommendation: Restructure compensation for entry-level technical roles to match market medians, reducing replacement costs by an estimated 15% annually.*
- **Career Stagnation:** The highest flight risk cohort consists of employees with 4+ years of tenure but no promotions in the last 2-3 years.
  *👉 Recommendation: Institute a structured 2-year rotational or upskilling path for mid-level employees to maintain engagement.*

---

## 🏗️ Architecture & Tech Stack

This project follows an ELT (Extract, Load, Transform) architectural pattern suitable for modern BI environments:

1. **Database / Warehouse:** `MySQL / PostgreSQL` (Raw data ingestion, cleaning, and staging)
2. **Transformations:** Advanced SQL (Window Functions, CTEs, Views)
3. **Data Modeling:** `Power BI / DAX` (Star Schema formulation)
4. **Visualization:** `Power BI` (Interactive Dashboards)

### 📁 Repository Structure
```text
HR-Analytics-Dashboard/
│
├── data/
│   ├── raw_data.csv            # Source dataset (IBM HR Attrition Data)
│   └── data_dictionary.md      # Metadata and column definitions
│
├── sql/
│   ├── 01_data_cleaning.sql    # DDL, schema creation, and standardization
│   ├── 02_exploratory_analysis.sql # EDA, macro-trends, aggregate metrics
│   └── 03_advanced_hr_metrics.sql  # CTEs, Window Functions, predictive risk views
│
├── dashboards/
│   └── HR_Analytics_Final.pbix # Interactive Power BI Dashboard 
│
└── docs/
    └── Dashboard.png           # High-res screenshot of the final report
```

---

## 🛠️ Data Modeling & DAX (Power BI)

The analytical model relies on a robust **Star Schema** to ensure performant querying and cross-filtering:
- **Fact Table:** `Fact_Attrition` (Contains granular employee movement and metrics)
- **Dimension Tables:** `Dim_Demographics`, `Dim_JobRole`, `Dim_Date`

**Key DAX Measures highlighting technical depth:**
- **YTD Attrition Rate:** Tracks running turnover percentages to spot seasonal spikes.
- **Dynamic Title Generation:** Changes based on the selected slicers (e.g., `"Viewing Attrition for: Department [Sales]"`)
- **What-If Parameter (Compensation Strategy):** Allows stakeholders to input a hypothetical % salary hike to simulate its modeled impact on the retention rate.

---

## 📸 Dashboard Preview

![HR Analytics Dashboard](docs/Dashboard.png)

*(The dashboard includes interactive cross-highlighting, tooltips for micro-trends, and drill-through capabilities from Department -> Job Role -> Individual Employee).*

---

## ⚙️ How to Run This Project Locally

1. **Database Setup:**
   - Execute the SQL scripts in the `sql/` folder in sequential order (`01`, `02`, `03`) on your local database server.
   - Use the import wizard of your SQL client to load `data/raw_data.csv` into the `employee_data` table.

2. **Power BI Configuration:**
   - Open `dashboards/HR_Analytics_Final.pbix` using Power BI Desktop.
   - Go to `Transform Data` -> `Data Source Settings` and update the SQL Server connection string to point to your local localhost instance.
   - Click `Refresh` to load the current semantic model.

---

*Author: Urvashi | Built to demonstrate end-to-end analytical engineering and business intelligence.*
