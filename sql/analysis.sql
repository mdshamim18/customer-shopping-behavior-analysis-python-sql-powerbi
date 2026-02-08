USE RetailDB;
GO

-- Q1. Total Revenue by Gender
-- Insight: Basic segmentation check.
SELECT gender, SUM(purchase_amount_usd) as total_revenue
FROM retail_sales_clean
GROUP BY gender;

-- Q2. "High Spenders" with Discounts
-- Insight: Customers who used a discount but still spent above average.
SELECT customer_id, purchase_amount_usd 
FROM retail_sales_clean 
WHERE discount_applied = 'Yes' 
  AND purchase_amount_usd >= (SELECT AVG(purchase_amount_usd) FROM retail_sales_clean);

-- Q3. Top 5 Products by Rating
-- Insight: Converted to DECIMAL for accurate average calculation.
SELECT TOP 5 
    item_purchased, 
    ROUND(AVG(CAST(review_rating AS DECIMAL(10,2))), 2) as avg_rating
FROM retail_sales_clean
GROUP BY item_purchased
ORDER BY avg_rating DESC;

-- Q4. Shipping Type Analysis
-- Insight: Compare average spend between standard and express.
SELECT shipping_type, 
       ROUND(AVG(purchase_amount_usd), 2) as avg_purchase_value
FROM retail_sales_clean
WHERE shipping_type IN ('Standard','Express')
GROUP BY shipping_type;

-- Q5. Subscriber Value Analysis
-- Insight: Do subscribers actually spend more on average?
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount_usd), 2) AS avg_spend,
       ROUND(SUM(purchase_amount_usd), 2) AS total_revenue
FROM retail_sales_clean
GROUP BY subscription_status
ORDER BY total_revenue DESC;

-- Q6. Discount Dependency (Top 5 Products)
-- Insight: Which products rely most heavily on discounts?
SELECT TOP 5 
    item_purchased,
    ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate
FROM retail_sales_clean
GROUP BY item_purchased
ORDER BY discount_rate DESC;

-- Q7. Customer Segmentation (New vs Returning vs Loyal)
-- Insight: Validating customer loyalty tiers.
WITH CustomerSegments AS (
    SELECT customer_id, 
           previous_purchases,
           CASE 
               WHEN previous_purchases = 1 THEN 'New'
               WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM retail_sales_clean
)
SELECT customer_segment, COUNT(*) AS customer_count
FROM CustomerSegments 
GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Q8. Top 3 Products Per Category
-- Insight: Using Window Functions to rank items within categories.
WITH ItemRanks AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS rank_id
    FROM retail_sales_clean
    GROUP BY category, item_purchased
)
SELECT category, item_purchased, total_orders
FROM ItemRanks
WHERE rank_id <= 3;

-- Q9. Repeat Buyers & Subscription Correlation
-- Insight: Are loyal buyers also subscribers?
SELECT subscription_status,
       COUNT(customer_id) AS heavy_buyers_count
FROM retail_sales_clean
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. Revenue by Age Group
-- Insight: Validates our Python 'age_group' logic.
SELECT age_group,
       SUM(purchase_amount_usd) AS total_revenue
FROM retail_sales_clean
GROUP BY age_group
ORDER BY total_revenue DESC;


-- Q11. Monthly Sales Trend (Critical for Line Charts)
-- Insight: Validates the synthetic 'transaction_date'.
SELECT 
    FORMAT(transaction_date, 'yyyy-MM') AS sales_month, 
    SUM(purchase_amount_usd) AS monthly_revenue
FROM retail_sales_clean
GROUP BY FORMAT(transaction_date, 'yyyy-MM')
ORDER BY sales_month;

-- Q12. Seasonality Analysis
-- Insight: Which season drives the most value?
SELECT season, 
       COUNT(customer_id) as transactions,
       ROUND(AVG(purchase_amount_usd), 2) as avg_spend
FROM retail_sales_clean
GROUP BY season
ORDER BY avg_spend DESC;

-- Q13. Frequency Analysis (Days Gap)
-- Insight: Validates 'frequency_days' logic.
SELECT frequency_of_purchases, 
       AVG(frequency_days) as avg_days_gap,
       SUM(purchase_amount_usd) as total_value
FROM retail_sales_clean
GROUP BY frequency_of_purchases
ORDER BY avg_days_gap;