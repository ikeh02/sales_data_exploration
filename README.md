# 🛒 Retail Sales Data Cleaning & Exploratory Data Analysis (EDA) in MySQL

## 📌 Project Overview
This project presents an end-to-end data cleaning, data engineering, and Exploratory Data Analysis (EDA) pipeline executed in **MySQL**. Utilizing a retail dataset containing 1,000 transaction records, the workflow transitions raw data from an unstructured state into a polished, high-performance database optimized for business intelligence reporting and exploratory modeling.

---

## 🛠️ Phase 1: Data Cleaning & Staging Architecture
Raw datasets often contain syntactical inconsistencies, formatting anomalies, and duplicate entries. To preserve data integrity, a multi-stage staging architecture was implemented;

1. **Schema Standardization:** Addressed multi-word attribute conflicts containing spaces (e.g., `Transaction ID`, `Product Category`) by applying explicit backtick identifier boundaries across all DDL and DML operations.
2. **Duplicate Detection via Window Functions:** Engineered custom staging tables (`sales_staging2`) incorporating `ROW_NUMBER() OVER (PARTITION BY ...)` across all primary dimensions to isolate and flag redundant transaction entries.
3. **Temporal Standardization:** Converted raw text-formatted dates into standardized MySQL native `DATE` types utilizing `STR_TO_DATE()` with explicit format specifiers (`%y-%m-%d`) to ensure accurate chronological filtering and aggregation.

---

## 📊 Phase 2: Exploratory Data Analysis & Advanced SQL Queries
Once the dataset was fully standardized, advanced analytical queries and aggregation techniques were deployed to unearth actionable business insights:

* **Category Performance Analysis:** Evaluated total revenue generation, transaction volumes, unit quantities, and average unit pricing (`ROUND(AVG(...), 2)`) across core retail categories (*Beauty*, *Clothing*, and *Electronics*).
* **Cumulative Revenue Modeling:** Built Common Table Expressions (CTEs) combined with window functions (`SUM() OVER (ORDER BY ...)`) to construct month-over-month rolling revenue totals and track financial trajectory over time.
* **Granular Ranking & Segmentation:** Leveraged advanced analytical window functions like `DENSE_RANK()` partitioned by product category to isolate high-value transactions and evaluate performance benchmarks.

---

## 💻 Technical Stack & Environment
* **Relational Database Management System:** MySQL Server 8.0 / MySQL Workbench
* **Query Languages & Concepts:** SQL (DDL, DML, CTEs, Window Functions, Aggregate Functions, String Manipulation)
* **Dataset Scale:** 1,000 Retail Transactions

---

## 🚀 Repository Structure & Execution Guide
1. Clone the repository to your local machine:
   ```bash
   git clone [https://github.com/your-username/retail-sales-mysql-eda.git](https://github.com/your-username/retail-sales-mysql-eda.git)# sales_data_exploration
End-to-end MySQL retail sales project featuring data cleaning, staging schema transformations, window functions, CTEs, and exploratory data analysis (EDA).
