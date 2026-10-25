-- 1. Highest Revenue Region (transaction grain)
WITH transaction_level AS (
    SELECT transaction_id, region, MAX(revenue) AS revenue
    FROM Aurora
    GROUP BY transaction_id, region
)
SELECT region AS Region, ROUND(SUM(revenue), 2) AS Total_Revenue
FROM transaction_level
GROUP BY region
ORDER BY Total_Revenue DESC;

-- 2. Revenue vs Budget by Region
SELECT region AS Region,
       ROUND(SUM(actual_revenue), 2) AS Total_Actual_Revenue,
       ROUND(SUM(budgeted_revenue), 2) AS Total_Budgeted_Revenue,
       ROUND(SUM(actual_revenue - budgeted_revenue), 2) AS Revenue_Variance
FROM Aurora
GROUP BY region
ORDER BY Revenue_Variance DESC;

-- 3. Highest Average Profit by Channel
WITH transaction_level AS (
    SELECT transaction_id, channel, MAX(profit) AS profit
    FROM Aurora
    GROUP BY transaction_id, channel
)
SELECT channel AS Channel, ROUND(AVG(profit), 2) AS Avg_Profit
FROM transaction_level
GROUP BY channel
ORDER BY Avg_Profit DESC;

-- 4. Churn Rate by Customer Segment
WITH customers AS (
    SELECT customer_id, customer_segment,
           MAX(CASE WHEN churn_flag = 'YES' THEN 1 ELSE 0 END) AS churned
    FROM Aurora
    GROUP BY customer_id, customer_segment
)
SELECT customer_segment AS Customer_Segment, COUNT(*) AS Total_Customers,
       SUM(churned) AS Churned_Customers,
       ROUND(100.0 * SUM(churned) / NULLIF(COUNT(*), 0), 2) AS Churn_Rate_Percentage
FROM customers
GROUP BY customer_segment
ORDER BY Churn_Rate_Percentage DESC;

-- 5. Monthly Revenue Trend
WITH transaction_level AS (
    SELECT transaction_id, transaction_date, MAX(revenue) AS revenue
    FROM Aurora
    GROUP BY transaction_id, transaction_date
)
SELECT strftime('%Y-%m', transaction_date) AS Year_Month,
       ROUND(SUM(revenue), 2) AS Monthly_Revenue
FROM transaction_level
GROUP BY Year_Month
ORDER BY Year_Month;

-- 6. Profit Margin by Product Category
WITH transaction_level AS (
    SELECT transaction_id, category, MAX(revenue) AS revenue, MAX(profit) AS profit
    FROM Aurora
    GROUP BY transaction_id, category
)
SELECT category, ROUND(SUM(profit), 2) AS Total_Profit,
       ROUND(SUM(revenue), 2) AS Total_Revenue,
       ROUND(100.0 * SUM(profit) / NULLIF(SUM(revenue), 0), 2) AS Profit_Margin_Percentage
FROM transaction_level
GROUP BY category
ORDER BY Profit_Margin_Percentage ASC;
