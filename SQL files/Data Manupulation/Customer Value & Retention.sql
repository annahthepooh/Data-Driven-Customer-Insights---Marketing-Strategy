# Answers question 'Which customers are most valuable?'
# Which customer segment generate the most revenue?
# Which segment contains the most number of customers?
# Which valuable customers are at risk of becoming inactive?
# Where should olist prioritize retention efforts


# RFM, Customer segements, Revenue contribution, Repeat purchase rate, At-risk customers

# Recency, Frequency, Monetary Values are calculated

WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id)

SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value ASC,
	Frequency_Value DESC,
    Monetary_Value DESC;
# The most number of days a customer has taken since the last order is 848 days
# The least number of days a customer has taken since the last order is 75 days
    
    
    
SELECT 
	o.order_id,
    c.customer_unique_id,
    ord.review_comment_message,
    ord.review_score
FROM order_reviews_dataset ord 
RIGHT JOIN orders_dataset o 
ON ord.order_id = o.order_id
RIGHT JOIN customers_dataset c
ON o.customer_id = c.customer_id
WHERE c.customer_unique_id = '830d5b7aaa3b6f1e9ad63703bec97d23';
#This specific customer shows NULL payment value and 1 review score meaning they most likely had a bad experience
#It is also 837 days since they shopped



WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id)

SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value DESC,
	Frequency_Value DESC,
    Monetary_Value DESC;
#Used COALESCE function to make the null values on payment value column 0 for RFM calculation
#This query brings back the Recency, Frequency & Monetary values that will be used to calculate the R,F & M codes



WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id),

RFM_values AS(
SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value DESC)
    
SELECT 
	customer_unique_id,
    NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
    NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
    NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
FROM RFM_Values
ORDER BY
	R_Code DESC,
    F_Code DESC,
    M_Code DESC;
#This query is to calculate the R, F & M codes that will be used for segmentation



WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id),

RFM_values AS(
SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value DESC),
    
RFM_Codes AS(
SELECT
	customer_unique_id,
    NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
    NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
    NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
FROM RFM_Values
ORDER BY
	R_Code DESC,
    F_Code DESC,
    M_Code DESC)
    
SELECT 
	customer_unique_id,
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
FROM RFM_Codes;
# This query categorizes the data into 7 marketing segments using RFM codes 
# The 7 segments are: Champion, Can't lose them, loyal customers, new buyers, About to sleep, Lost and regular spontaneous customers

WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id),

RFM_values AS(
SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value DESC),
    
RFM_Codes AS(
SELECT
	customer_unique_id,
    NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
    NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
    NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
FROM RFM_Values),

Segments AS(    
SELECT 
	customer_unique_id,
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
FROM RFM_Codes)

SELECT
	SUM(IF (marketing_segment = 'Champion', 1, 0)) AS champion_count,
    SUM(IF (marketing_segment = 'Cannot lose them',1,0)) AS cannot_lose_count,
    SUM(IF (marketing_segment = 'Loyal customers',1,0)) AS loyal_count,
    SUM(IF (marketing_segment = 'New buyers',1,0)) AS new_buyers_count,
    SUM(IF (marketing_segment = 'About to sleep',1,0)) AS about_to_sleep_count,
	SUM(IF (marketing_segment = 'Lost',1,0)) AS lost_count,
    SUM(IF (marketing_segment = 'Regular spontaneous customer',1,0)) AS regular_count
FROM Segments;
# Regular spontaneous customers are the highest with 46,131
# Loyal customers are 2nd with 18,842
# 3rd on the list are the champions who are 14,440
# 4th are the lost customers who are 14,386
# 5th are the customers who are about to sleep customers who are 1,360
# 6th are the new buyers with 1057
# There are no cannot lose customers



WITH raw_data AS(
SELECT 
	customer_unique_id,
    order_purchase_timestamp,
    O.order_id,
    COALESCE(OI.price,0) AS price,
    C.customer_id
FROM order_items_dataset OI
RIGHT JOIN orders_dataset O 
ON OI.order_id = O.order_id
RIGHT JOIN customers_dataset C
ON O.customer_id = C.customer_id),

RFM_values AS(
SELECT 
	customer_unique_id,
    DATEDIFF('2018-12-31' , DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
    COUNT(DISTINCT order_id) AS Frequency_Value,
    ROUND(SUM(price),2) AS Monetary_Value
FROM raw_data
GROUP BY customer_unique_id
ORDER BY Recency_Value DESC),
    
RFM_Codes AS(
SELECT
	customer_unique_id,
    NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
    NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
    NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
FROM RFM_Values),

Segments AS(    
SELECT 
	customer_unique_id,
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
FROM RFM_Codes)

SELECT
	SUM(IF (marketing_segment = 'Champion', 1, 0)) AS champion_count,
    SUM(IF (marketing_segment = 'Cannot lose them',1,0)) AS cannot_lose_count,
    SUM(IF (marketing_segment = 'Loyal customers',1,0)) AS loyal_count,
    SUM(IF (marketing_segment = 'New buyers',1,0)) AS new_buyers_count,
    SUM(IF (marketing_segment = 'About to sleep',1,0)) AS about_to_sleep_count,
	SUM(IF (marketing_segment = 'Lost',1,0)) AS lost_count,
    SUM(IF (marketing_segment = 'Regular spontaneous customer',1,0)) AS regular_count,
#These are the percentages
	ROUND(SUM(IF (marketing_segment = 'Champion', 1, 0)) / COUNT(*)*100,2) AS per_champion,
    ROUND(SUM(IF (marketing_segment = 'Cannot lose them',1,0)) / COUNT(*)*100,2) AS per_cannot_lose,
    ROUND(SUM(IF (marketing_segment = 'Loyal customers',1,0)) / COUNT(*)*100,2) AS per_loyal,
    ROUND(SUM(IF (marketing_segment = 'New buyers',1,0)) / COUNT(*)*100,2) AS per_new_buyers,
    ROUND(SUM(IF (marketing_segment = 'About to sleep',1,0)) / COUNT(*)*100,2) AS per_bout_to_sleep,
	ROUND(SUM(IF (marketing_segment = 'Lost',1,0)) / COUNT(*)*100,2) AS per_lost_count,
    ROUND(SUM(IF (marketing_segment = 'Regular spontaneous customer',1,0)) / COUNT(*)*100,2) AS per_regular
FROM Segments;
# 48.01% of the customers are regular spontaneuous customers which make up almost half the customer base
# 19.61% are the loyal customers and the gap between them and the first group is massive
# 15.03% are champions and the gap between the second group is not big
# 14.85% are the lost customers and the gap is insignificant 
# 1.42% of the customers are about to sleep 
# 1.10% of the customers are new buyers
# There are no customers who have been loyal and spending buut not bought recently that we don't want to lose





WITH raw_data AS(
	SELECT 
		customer_unique_id,
		order_purchase_timestamp,
		O.order_id,
		COALESCE(OI.price,0) AS price,
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
		ROUND(SUM(price),2) AS Monetary_Value
	FROM raw_data
    GROUP BY customer_unique_id),
    
RFM_Codes AS(
	SELECT
		customer_unique_id,
		NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
		NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
		NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
	FROM RFM_Values),

Segments AS(    
	SELECT 
		customer_unique_id,
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

order_segments AS(
	SELECT DISTINCT 
		RD.order_id,
		S.marketing_segment
	FROM raw_data RD
	LEFT JOIN segments S ON RD.customer_unique_id = S.customer_unique_id)

SELECT
    OS.marketing_segment,
    ROUND(AVG (ORD.review_score), 2) AS average_review_score,
    COUNT(ORD.review_score) AS total_reviews_left,
    ROUND(SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS bad_review_pct
FROM order_segments OS
JOIN order_reviews_dataset ORD ON OS.order_id = ORD.order_id
GROUP BY OS.marketing_segment
ORDER BY average_review_score ASC;
# About to sleep customers gave the most bad reviews at 24.22%
# lost customers were next with 14.49%
# loyal customers 14.80% and regular spontaneaous customers were next 14.69%
# Regular spontaneous customers were next with 14.67%
# New buyers were next with 13.59%
# Champions gave the least amount of bad review points at 12.37%
