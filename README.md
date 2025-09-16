# Walmart Sales Analysis & Dashboarding
### 📌Project Overview

This project is an end-to-end data analytics pipeline that covers everything from raw data cleaning to dashboarding. The main objective was to analyze Walmart sales data, solve business problems, and present insights through an interactive Power BI dashboard.

The project is divided into three major stages:

### Python (Data Cleaning & EDA)

Used Python to clean and preprocess the dataset (10,000+ records).

Tasks included handling missing values, renaming inconsistent columns, fixing data types, and basic exploratory analysis.

Libraries used:

pandas – data manipulation and cleaning

numpy – numerical operations

mysql.connector – to connect Python directly to MySQL

sqlalchemy – to push cleaned data from Pandas DataFrame into MySQL

✅ Instead of manually importing the dataset into MySQL (which would have taken almost an hour), I automated the process using mysql.connector to establish a connection and sqlalchemy to load the cleaned dataset directly. This saved a lot of time and made the workflow efficient.

### SQL (Business Problem Solving)

Once the data was loaded into MySQL, I designed queries to answer key business questions.

Queries covered areas such as:

Top products and sub-categories by sales and orders

Regional and city-level sales performance

Most common payment methods

Monthly revenue trends and year-over-year comparisons

Profitability by segment and category

Seasonal trends and weekday vs weekend performance

Advanced SQL concepts used:

CTEs (Common Table Expressions)

Window Functions (RANK, LAG, etc.)

Subqueries

File: sql query.sql

### Power BI (Visualization & Dashboarding)

Built a 3-page interactive Power BI dashboard connected to MySQL:

Page 1: Sales Overview

KPI cards for Sales, Profit, Profit Margin, Avg Price, and Delivery Time.

Line charts for Monthly Sales and Profit (YoY).

Bar charts for Sales by Category and Sub-Category.

Donut charts for Segment, Region, and Payment Mode.

Map visualization for Sales by City.

Page 2: Customer Insights

KPIs for Total Customers and Orders.

Top/Bottom customers by Sales and Profit.

Profit distribution by Region and State (map).

Returns analysis chart.

Page 3: Sales Forecasting

Forecasting of Monthly Sales using Power BI’s built-in forecast model.

Future projections tied back to categories and segments for better decision-making.

Dashboard file: Walmart Sales Dashboard.pbix

### 🛠️Tech Stack

Python: pandas, numpy, mysql.connector, sqlalchemy

SQL (MySQL): Queries, CTEs, Window functions, Subqueries

Power BI: KPI cards, Line charts, Bar/Donut charts, Maps, Forecasting

### ✅Key Insights

COD was the most preferred payment method, followed by Online transactions.

Phones and Machines were the top-performing sub-categories.

The West region contributed the highest sales.

Certain customers generated negative profit, highlighting risk areas.

Forecasts indicated steady growth for the next 6 months.
