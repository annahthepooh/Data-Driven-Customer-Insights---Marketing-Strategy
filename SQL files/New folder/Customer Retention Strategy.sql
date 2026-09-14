# This is for customer retention and reactivation strategy

# 93,174 customers made only one purchase
# Only 6,762 customers are repeat customers
# The repeat purchase rate without the cnaceled orders is 3.06%
# 47.68% of the customers fall into the Regular Spontaneous Customers Segment
# 14.97% are Lost
# 1.45% are about to sleep
# 14.99% are champions
# 19.82% are Loyal customers

# Which segments present the most opportunities for retention and reactivation? 


WITH raw_data AS(
	SELECT 
		customer_unique_id,
		order_purchase_timestamp,
		O.order_id,
		COALESCE(OP.payment_value,0) AS payment_value,
		C.customer_id
	FROM order_payment_dataset OP
	RIGHT JOIN orders_dataset O 
	ON OP.order_id = O.order_id
	RIGHT JOIN customers_dataset C
	ON O.customer_id = C.customer_id),

RFM_values AS(
	SELECT 
		customer_unique_id,
		COUNT(DISTINCT order_id) AS Frequency_Value,
		DATEDIFF('2018-12-31', DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
		ROUND(SUM(payment_value),2) AS Monetary_Value
	FROM raw_data
    GROUP BY customer_unique_id),
    
RFM_Codes AS(
	SELECT
		customer_unique_id,
        monetary_value,
        frequency_value,
		NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
		NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
		NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
	FROM RFM_Values),

Segments AS(    
	SELECT 
		customer_unique_id,
        monetary_value,
        frequency_value,
		R_Code,
		F_Code,
		M_Code,
		CASE
			WHEN R_Code >= 4 AND F_Code >= 4 AND M_Code >= 4 THEN 'Champion'
			WHEN R_Code <= 2 AND F_Code >= 4 AND M_Code >= 4 THEN 'Cannot lose them'
			WHEN R_Code >= 3 AND F_Code >= 3 AND M_Code >= 3 THEN 'Loyal customers'
			WHEN R_Code >= 4 AND F_Code <= 1 THEN 'New buyers'
			WHEN R_Code = 3 AND F_Code <= 2 AND M_Code <= 2 THEN 'About to sleep'
			WHEN R_Code <= 2 AND F_Code <= 2 AND M_Code <= 2 THEN 'Lost'
			ELSE 'Regular spontaneous customer'
		END AS marketing_segment
	FROM RFM_Codes),
    
Segment_performance AS(
	SELECT 
		marketing_segment,
		COUNT(DISTINCT customer_unique_id) AS customer_count,
		ROUND(SUM(monetary_value),2) AS total_revenue,
	    ROUND(AVG(monetary_value),2) AS avg_customer_value,
	    ROUND(AVG(frequency_value),2) AS avg_order_per_customer
	FROM Segments
    GROUP BY marketing_segment)
		
SELECT
    marketing_segment,
    ROUND(customer_count / SUM(customer_count) OVER()*100,2) AS customer_pct,
    ROUND(total_revenue / (SUM(total_revenue) OVER())*100,2) AS revenue_pct,
    avg_customer_value,
    avg_order_per_customer
    
FROM Segment_performance
ORDER BY total_revenue DESC;
# Regular spontaneous customers segment generates the most revenue but contains mostly one time customers
# This opens a door to retention strategies
# Lost segment has 310.79 as the avg_customer_value even thougt it covers 14% of the customer base
# 


# STRATEGY 1. Convert one time customers into repeat customers
# prioritizing post-purchase retention campaigns for the regular spontaneous customer segment by using their previous purchase category history to recommend a complimentary product and encourage purchase
 
# STRATEGY 2. Reactivate high value lost customers

# 
# 

WITH raw_data AS(
	SELECT 
		customer_unique_id,
		order_purchase_timestamp,
		O.order_id,
		COALESCE(OI.price,0) AS revenue,
		C.customer_id
    FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O 
		ON OI.order_id = O.order_id
	RIGHT JOIN customers_dataset C
		ON O.customer_id = C.customer_id),

RFM_values AS(
	SELECT 
		customer_unique_id,
		COUNT(DISTINCT order_id) AS Frequency_Value,
		DATEDIFF('2018-12-31', DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
		ROUND(SUM(revenue),2) AS Monetary_Value
	FROM raw_data
    GROUP BY customer_unique_id),
    
RFM_Codes AS(
	SELECT
		customer_unique_id,
        monetary_value,
        frequency_value,
		NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
		NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
		NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
	FROM RFM_Values),

Segments AS(    
	SELECT 
		customer_unique_id,
        monetary_value,
        frequency_value,
		R_Code,
		F_Code,
		M_Code,
		CASE
			WHEN R_Code >= 4 AND F_Code >= 4 AND M_Code >= 4 THEN 'Champion'
			WHEN R_Code <= 2 AND F_Code >= 4 AND M_Code >= 4 THEN 'Cannot lose them'
			WHEN R_Code >= 3 AND F_Code >= 3 AND M_Code >= 3 THEN 'Loyal customers'
			WHEN R_Code >= 4 AND F_Code <= 1 THEN 'New buyers'
			WHEN R_Code = 3 AND F_Code <= 2 AND M_Code <= 2 THEN 'About to sleep'
			WHEN R_Code <= 2 AND F_Code <= 2 AND M_Code <= 2 THEN 'Lost'
			ELSE 'Regular spontaneous customer'
		END AS marketing_segment
	FROM RFM_Codes),
    
Lost_performance AS(
	SELECT
		customer_unique_id,
        monetary_value,
        frequency_value,
        NTILE(4) OVER(ORDER BY monetary_value DESC) AS value_quartile
	FROM Segments
    WHERE marketing_segment = 'Lost')
    
		
SELECT
    CASE 
		WHEN value_quartile = 1
		THEN 'High_value_lost_customer'    
        ELSE 'Low_value_lost_customer'
	END AS lost_customer_segmentation,
	COUNT(DISTINCT customer_unique_id) AS customer_count,
    ROUND(COUNT(DISTINCT customer_unique_id) / SUM(COUNT(DISTINCT customer_unique_id)) OVER()*100,2) AS customer_pct,
    ROUND(SUM(monetary_value),2) AS revenue,
    ROUND(SUM(monetary_value) / SUM(SUM(monetary_value)) OVER()*100, 2) AS  revenue_pct,
    ROUND(AVG(monetary_value),2) AS avg_revenue,
    ROUND(AVG(frequency_value),2) AS avg_order_per_customer
    
FROM Lost_performance

GROUP BY 
	CASE 
		WHEN value_quartile = 1
		THEN 'High_value_lost_customer'    
        ELSE 'Low_value_lost_customer'
	END
ORDER BY revenue DESC;
# There 3,588 customers who are high value meaning they generated high revenue but they stopped ordering 
# That is an opportunity for reactivation campaign
# The top 25% of Lost customers represents 3,588 customers and 2,144,463 in revenue making them the priority audience for a high-value win-back campaign

SELECT 
	PC.product_category_name_english,
	COUNT(OI.order_id) AS product_count
FROM order_items_dataset OI
LEFT JOIN products_dataset  P
	ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
	ON  P.product_category_name = PC.product_category_name
GROUP BY PC.product_category_name_english
ORDER BY product_count DESC;

# The product_category with the most one-time customers is bed_bath_category with 11,115


WITH customer_orders AS(
	SELECT
		C.customer_unique_id,
        COUNT(DISTINCT order_id) AS order_count
	FROM customers_dataset C
    LEFT JOIN orders_dataset O 
		ON C.customer_id = O.customer_id
	GROUP BY C.customer_unique_id),
    
one_time_customers AS(
	SELECT 
		customer_unique_id
	FROM customer_orders
    WHERE order_count = 1),
    
one_time_customer_orders AS(
	SELECT 
		C.customer_unique_id,
        O.order_id,
        COALESCE(OI.price,0) AS price,
        O.order_purchase_timestamp
	FROM customers_dataset C
    LEFT JOIN orders_dataset O 
		ON C.customer_id = O.customer_id
	LEFT JOIN order_items_dataset OI
		ON O.order_id = OI.order_id
	JOIN one_time_customers OT
		ON C.customer_unique_id = OT.customer_unique_id),
	
category_performance AS(
	SELECT
		COALESCE(product_category_name_english, 'unknown') AS product_category,
        COUNT(DISTINCT OTC.customer_unique_id) AS one_time_customers,
        COUNT(DISTINCT OTC.order_id) AS orders,
        ROUND(SUM(OTC.price),2) AS revenue,
        ROUND(AVG(OTC.price),2) AS avg_order_value
	FROM one_time_customer_orders OTC
    INNER JOIN order_items_dataset OI
		ON OTC.order_id = OI.order_id
    JOIN products_dataset P
		ON OI.product_id = P.product_id
	JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	GROUP BY COALESCE(product_category_name_english, 'unknown'))
    
SELECT
	product_category,
    one_time_customers,
    ROUND(one_time_customers / SUM(one_time_customers) OVER()*100,2) AS customer_pct,
    orders,
    revenue,
    avg_order_value
    
FROM category_performance
ORDER BY one_time_customers DESC;
# Bed bath table has the most one time customers with 8543
# Health beauty is next with 8317
# Sports leisure follows with 7106
# computer accessories is next with 6272
# furniture decor is next with 5852
    
    