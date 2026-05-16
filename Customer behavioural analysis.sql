use customer_behaviour;
Select * from customer_data;
-- SECTION 1 — CUSTOMER SEGMENTATION ANALYTICS
-- Q1. Which customer segments generate the highest revenue and profitability?

SELECT age_group,gender,COUNT(customer_id) AS total_customers,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
ROUND(SUM(purchase_amount) * 100.0 / SUM(SUM(purchase_amount)) OVER(),2) AS revenue_contribution_pct
FROM customer_data
GROUP BY age_group, gender
ORDER BY total_revenue DESC;

-- Q2. Which customer groups show the strongest loyalty and repeat purchase behavior?

SELECT age_group,subscription_status,frequency_of_purchases,COUNT(customer_id) AS total_customers,
ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer_data
GROUP BY age_group,subscription_status,frequency_of_purchases
ORDER BY avg_previous_purchases DESC,total_revenue DESC;

-- Q3. Does subscription membership improve customer retention and spending?

SELECT subscription_status,COUNT(customer_id) AS total_customers,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(purchase_frequency_days), 2) AS avg_purchase_frequency_days
FROM customer_data
GROUP BY subscription_status;

-- SECTION 2 — PRODUCT & SALES ANALYTICS
-- Q4. Which products and categories drive the highest revenue and customer engagement?

SELECT category,item_purchased,COUNT(customer_id) AS total_orders,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,ROUND(AVG(review_rating), 2) AS avg_review_rating,
ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases
FROM customer_data
GROUP BY category,item_purchased
ORDER BY total_revenue DESC,avg_previous_purchases DESC;
         
-- Q5. Which products are too dependent on discounts?

SELECT category,item_purchased,COUNT(*) AS total_orders,
SUM(CASE WHEN discount_applied = 'Yes' THEN 1
ELSE 0
END) AS discounted_orders,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1
ELSE 0
END) * 100.0 / COUNT(*),2) AS discount_dependency_pct,
SUM(purchase_amount) AS total_revenue
FROM customer_data
GROUP BY category,item_purchased
ORDER BY discount_dependency_pct DESC,total_revenue DESC;
         
-- Q6. Do highly rated products generate stronger customer loyalty?

SELECT category,item_purchased,ROUND(AVG(review_rating), 2) AS avg_review_rating,
ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
COUNT(customer_id) AS total_orders FROM customer_data
GROUP BY category,item_purchased
ORDER BY avg_review_rating DESC, avg_previous_purchases DESC;

-- SECTION 3 — MARKETING & PROMOTION ANALYTICS
-- Q7. Do discounts increase long-term customer value or only short-term purchases?

SELECT discount_applied, COUNT(customer_id) AS total_customers, SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount, ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(purchase_frequency_days), 2) AS avg_purchase_frequency_days 
FROM customer_data
GROUP BY discount_applied;

-- Q8. Which demographics respond best to discounts and promotions?

SELECT  location, COUNT(customer_id) AS total_purchases,
SUM( CASE WHEN discount_applied = 'Yes' THEN 1
ELSE 0
END ) AS discounted_purchases,
ROUND(SUM(CASE WHEN discount_applied = 'Yes' THEN 1
ELSE 0
END) * 100.0 / COUNT(customer_id),2) AS discount_response_pct,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount, ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases
FROM customer_data
GROUP BY location
ORDER BY discount_response_pct DESC,avg_purchase_amount DESC;
         
-- SECTION 4 — OPERATIONAL & CUSTOMER EXPERIENCE ANALYTICS
-- Q9. Does shipping type influence customer spending behavior?

SELECT shipping_type, COUNT(customer_id) AS total_orders, SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount, ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(purchase_frequency_days), 2) AS avg_purchase_frequency_days
FROM customer_data
GROUP BY shipping_type
ORDER BY avg_purchase_amount DESC,total_revenue DESC;

-- Q10. Which payment methods are associated with high-value customers?

SELECT payment_method,COUNT(customer_id) AS total_customers,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(purchase_frequency_days), 2) AS avg_purchase_frequency_days
FROM customer_data
GROUP BY payment_method
ORDER BY avg_purchase_amount DESC,total_revenue DESC;
         
-- SEASONAL & TREND ANALYTICS
-- Q11. Which seasons drive the highest sales and customer engagement?

SELECT season,COUNT(customer_id) AS total_orders,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(review_rating), 2) AS avg_review_rating,ROUND(AVG(purchase_frequency_days), 2) AS avg_purchase_frequency_days
FROM customer_data
GROUP BY season
ORDER BY total_revenue DESC,avg_previous_purchases DESC;
         
-- Q12. Which categories perform best during each season?

SELECT season,category,COUNT(customer_id) AS total_orders,SUM(purchase_amount) AS total_revenue,
ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
ROUND(AVG(review_rating), 2) AS avg_review_rating
FROM customer_data
GROUP BY season,category
ORDER BY season,total_revenue DESC;