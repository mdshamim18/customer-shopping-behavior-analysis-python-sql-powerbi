# Customer Shopping Behavior Analysis

## 📌 Overview
This project demonstrates an end-to-end data analytics workflow using retail customer transaction data.  
The objective is to analyze customer purchasing behavior, subscription trends, discount impact, and loyalty patterns to support data-driven business decisions.

The project simulates real-world responsibilities of a data analyst by combining data preparation, analysis, and visualization in a structured and practical manner.

---

## 🔄 Project Workflow

![Project Workflow](assets/project_workflow.png)

The workflow followed in this project covers the complete analytics lifecycle — from business understanding to insight communication and reporting.

---

## 🛠️ Tools & Technologies
- **Python** (pandas, numpy) – data cleaning, transformation, and feature engineering  
- **SQL** – analytical queries and customer segmentation  
- **Power BI** – interactive dashboards and insight visualization  

---

## 📂 Dataset Summary
- **Records:** ~3,900 customer purchase transactions  
- **Columns:** 18 features including:
  - Customer demographics (age, gender, location, subscription status)
  - Purchase details (product, category, season, purchase amount)
  - Shopping behavior (discounts, reviews, shipping type, purchase frequency)

---

## 🔍 Work Performed

### 1️⃣ Data Preparation & EDA (Python)
- Imported and explored raw customer data using pandas
- Handled missing values and standardized column formats
- Engineered features such as age groups and purchase frequency
- Prepared cleaned data for loading into a SQL database

### 2️⃣ Data Analysis (SQL)
- Loaded processed data into a SQL database
- Wrote analytical queries to:
  - Segment customers into new, returning, and loyal groups
  - Analyze repeat purchases and subscription behavior
  - Identify high-spending and discount-driven products
  - Compare revenue across demographics and shipping types

### 3️⃣ Data Visualization (Power BI)
- Built an interactive Power BI dashboard to visualize:
  - Key KPIs (total customers, average spend, average rating)
  - Customer segments and subscription trends
  - Revenue distribution across product categories and age groups
- Enabled slicers and filters for deeper analysis

---

## 📊 Key Insights
- Subscribers and repeat buyers contribute significantly to overall revenue
- Certain product categories show high dependency on discounts
- Young adult and middle-aged customer segments generate the highest revenue
- Customers using express shipping tend to have higher average purchase values

---

## 📁 Project Structure
