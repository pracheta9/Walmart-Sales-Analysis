select * from salesdata;

ALTER TABLE salesdata
RENAME COLUMN `Order ID` TO order_id,
rename column `Order Date` to order_date,
rename column `Ship Date` to ship_date,
rename column `Ship Mode` to ship_mode,
rename column `Customer ID` to customer_id,
rename column `Customer Name` to customer_name,
rename column `Product ID` to product_id,
rename column `Sub-Category` to sub_category,
rename column `Product Name` to product_name,
rename column `Payment Mode` to payment_mode ;



-- -------------------------BUSINESS PROBLEMS-------------------------------------------------------------------

-- Q1) Find for different paymnet method the no of transactions and the no of quantity sold
select `Payment Mode`, count(*) as No_of_Transactions, sum(Quantity) as total_qty_sold
from salesdata
group by `Payment Mode`;

-- Q2) What are the top 5 product sub-categories by number of transactions?
select sub_category, count(*) as no_of_orders
from salesdata
group by sub_category
order by no_of_orders desc
limit 5;

-- Q3) Which cities have the highest sales (total_amount)?
select City, sum(Sales) as total_sales from salesdata
group by City
order by total_sales desc
limit 5;

-- Q4) Determine the average, minimun, maximum profit of products for each city. List the city, avg_rating, min_rating, and max_rating:

select 
    City , 
    Category,
    avg(`Profit Margin(%)`) as avg_profit_margin,
    min(`Profit Margin(%)`) as min_profit_margin,
    max(`Profit Margin(%)`) as max_profit_margin
from sales_data
group by 1,2;

-- Q5) Calculate total profits for each Segment. List segment, total profits ordered from highest to lowest profit

select 
      Segment,
      sum(Sales) as sales,
      sum(Profit) as profit
from salesdata
group by 1
order by profit desc;    

-- Q6) Which Region has the highest profit margin on average?
select Region, round(avg(`Profit Margin(%)`),2) as Avg_profit_margin
from sales_data
group by 1
order by Avg_profit_margin desc;


-- Q7) Monthly Revenue Trend analysis:
select 
    date_format(order_date, '%Y-%m') as Month,
    round(SUM(Sales), 2) as Revenue
from salesdata
group by month
order by month;

 -- Q8) Identify highest avg priced category in each Region, displaying the branch, category,avg price
 
select * 
from
 (  select Region, 
    sub_category, 
    round(avg(`Price(/unit)`),2) as avg_price,
    rank() over(partition by Region order by round(avg(`Price(/unit)`),2) desc) as Region_Rank                       #Added a window function
from salesdata
group by 1,2
) as Ranked_category
where Region_Rank = 1 ;                                                                                              #Added a subquery

-- Q9) Identify the busiest day for each state based on the no of transaction:

select * from
(select 
    State,
    dayname(order_date) as formated_data ,                        #Firstly converting date from text to date format and then extracting dayname
    count(*) as no_of_Transactions,
    rank() over (partition by State order by count(*) desc) as Busiest_rank
from salesdata
group by 1, 2
order by 1, 3 desc
) as ranked_branch                                                                                   #Created subquery
where Busiest_rank = 1;

-- Q10) Determine the most common payment method for each Region using CTE. Display branch and the preferred payment method:

with cte                                                                                          #Creating a cte column
as
(select
     Region,
     payment_mode,
     count(*) as total_trans,
     rank() over(partition by Region order by count(*) desc) as ranked_method
from salesdata
group by 1, 2
)
select * from cte
where ranked_method = 1;

-- Q11) Categorize sales into 4 groups Winter, Spring, Summer, Autumn (or similar) and count invoices per category for different cities

SELECT 
   City,
case
   when month(order_date) in (12,1,2) then 'Winter'
   when month(order_date) in (3,4,5) then 'Spring'
   when month(order_date) in (6,7,8) then 'Summer'
   else 'Autumn'
end as season,
count(distinct order_id) as no_of_invoice
from salesdata
group by 1 , 2
order by 1, 3 desc;

-- Q12) Compare profit margin by category and identify underperforming ones

WITH avg_profit AS (
    SELECT sub_category, avg(Profit/Sales) AS avg_margin
    FROM salesdata
    GROUP BY sub_category
)
SELECT * FROM avg_profit
WHERE avg_margin < 0.4
ORDER BY avg_margin;


-- Q13) Identify the most profitable product category per State (using CTE + window function)

with category_profit as (
    select State, Category, 
           sum(Profit) AS total_profit
    from salesdata
    group by 1,2
),
ranked_categories as (
    select *, 
           rank() over (partition by State order by total_profit desc) as profit_rank
    from category_profit
)
select State, Category, total_profit
from ranked_categories
where profit_rank = 1;

-- Q14) Find top 3 performing months (by total sales) across entire USA (using window function)

WITH monthly_sales AS (
    SELECT 
        month(order_date) AS Month,
        SUM(Sales) AS total_sales
    FROM salesdata
    GROUP BY Month
),
ranked_month AS (
    SELECT *, 
           RANK() OVER (ORDER BY total_sales DESC) AS month_rank
    FROM monthly_sales
)
SELECT Month, total_sales
FROM ranked_month
WHERE month_rank <= 3;

-- Q15) Get revenue difference month-over-month using LAG()

WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(order_date,'%Y-%m') AS month,
        SUM(Sales) AS revenue
    FROM salesdata
    GROUP BY month
),
growth_calc AS (
    SELECT month, revenue,
           revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
    FROM monthly_sales
)
SELECT * FROM growth_calc;

-- Q16) Compare weekend vs weekday performance (using subqueries & CASE)

SELECT 
  City,
  SUM(CASE 
        WHEN DAYOFWEEK(order_date) IN (1, 7) THEN Sales
        ELSE 0
      END) AS weekend_sales,
  SUM(CASE 
        WHEN DAYOFWEEK(order_date) BETWEEN 2 AND 6 THEN Sales
        ELSE 0
      END) AS weekday_sales
FROM salesdata
GROUP BY City;












-- Q18) Identify 5 States with highest decrease ratio in revenue comapre to last year (USING GROUP BY AND CTE)	

-- 2019 Sales
with revenue_2019                                                                   #creating last year sales 2022 table
as
(
select State,
	 sum(Sales) as revenue
from salesdata
 where year(order_date) = 2019
 group by 1
 ),
 
 revenue_2020                                                                       #Creating cyrrent year sales 2023 table
 as
 (
 select State,
	 sum(Sales) as revenue
from salesdata
 where year(order_date) = 2020
 group by 1
 )

select 
      ls.state,
      ls.revenue as last_yr_revenue,
      cs.revenue as current_yr_revenue,
      round(((ls.revenue - cs.revenue)/ls.revenue*100),2) as revenue_decrease_ratio
from revenue_2019 as ls
join
revenue_2020 as cs
on ls.state = cs.state
where ls.revenue > cs.revenue
order by 4 desc
limit 5;