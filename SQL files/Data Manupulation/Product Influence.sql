# This looks at the product performance : the revenue generated per product, most ordered product and the products low average review score

WITH products_raw_data AS(
SELECT 
	P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OI.order_id,
    OI.price,
    ORD.review_score
FROM product_category_name_translation PC
RIGHT JOIN products_dataset P ON PC.product_category_name = P.product_category_name
LEFT JOIN order_items_dataset OI ON P.product_id = OI.product_id
LEFT JOIN order_reviews_dataset ORD ON OI.order_id =  ORD.order_id)

SELECT
	COALESCE(product_category_name_english, 'Unknown') AS product_category_name_english,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price),2) AS total_sales_revenue,
    ROUND(SUM(CASE WHEN review_score <=2 THEN 1 ELSE 0 END)/ COUNT(review_score)* 100, 2) AS product_bad_review_pct
FROM products_raw_data
GROUP BY product_category_name_english
ORDER BY total_orders DESC; 
# bed bath table is the category with the most orders 
# health beauty, watches_gifts, bed_bath_table, sports_leisure and computer_accesories are the have the most revenue generation respectively
# security & services, fashion_male_clothing and office_furniture have the worst product_bad_review_pct respectively


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			AVG(ORD.review_score),2) AS avg_review_score,
		ROUND(
			SUM(CASE WHEN ORD.review_score <=2 then 1 ELSE 0 END) / NULLIF(COUNT(ORD.review_score),0)*100,2) AS bad_review_pct
	FROM products_dataset P
    LEFT JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	LEFT JOIN order_items_dataset OI
		ON P.product_id = OI.product_id
	LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
GROUP BY COALESCE(PC.product_category_name_english, 'unknown'))

SELECT
	product_category,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE
		WHEN total_orders >= (
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct >= (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Poor Reviews'
        
        WHEN total_orders >=(
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct < (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Good Reviews'
        
        WHEN total_orders < (
			SELECT AVG(total_orders)
			FROM product_performance)
		AND bad_review_pct >=(
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'Low Demand - Poor Reviews'
        ELSE 'Low Demand - Good Reviews'
        
        END AS product_performance_category
FROM product_performance
;
# Categorizes the product performance into 4 categories based on the order demand and review scores
# The 4 segments are : High demand good reviews, High demand poor reviews, Low demand good reviews and Low demand poor reviews



WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			AVG(ORD.review_score),2) AS avg_review_score,
		ROUND(
			SUM(CASE WHEN ORD.review_score <=2 then 1 ELSE 0 END) / NULLIF(COUNT(ORD.review_score),0)*100,2) AS bad_review_pct
	FROM products_dataset P
    LEFT JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	LEFT JOIN order_items_dataset OI
		ON P.product_id = OI.product_id
	LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
GROUP BY COALESCE(PC.product_category_name_english, 'unknown')),

product_performance_cat AS(
SELECT
	product_category,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE
		WHEN total_orders >= (
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct >= (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Poor Reviews'
        
        WHEN total_orders >=(
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct < (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Good Reviews'
        
        WHEN total_orders < (
			SELECT AVG(total_orders)
			FROM product_performance)
		AND bad_review_pct >=(
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'Low Demand - Poor Reviews'
        ELSE 'Low Demand - Good Reviews'
        
        END AS product_performance_category
FROM product_performance)

SELECT
	*
FROM product_performance_cat
WHERE product_performance_category = 'High Demand - Poor Reviews'
ORDER BY total_revenue DESC;
;
# There are 8 product categories with high demand but poor reviews
# The categories are : bed_bath_table(2), computer_accessories(3), furniture_decor(4), watches_gifts(1), telephony(7), garden_tools(5), baby(6), unknown(8)
# These high demand, high revenue categories are generating sustancial customer satisfaction creating a potential risk of negative customer experiences if marketing efforts drive additional demand before the underlying issues are addressed


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			AVG(ORD.review_score),2) AS avg_review_score,
		ROUND(
			SUM(CASE WHEN ORD.review_score <=2 then 1 ELSE 0 END) / NULLIF(COUNT(ORD.review_score),0)*100,2) AS bad_review_pct
	FROM products_dataset P
    LEFT JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	LEFT JOIN order_items_dataset OI
		ON P.product_id = OI.product_id
	LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
GROUP BY COALESCE(PC.product_category_name_english, 'unknown')),

product_performance_cat AS(
SELECT
	product_category,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE
		WHEN total_orders >= (
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct >= (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Poor Reviews'
        
        WHEN total_orders >=(
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct < (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Good Reviews'
        
        WHEN total_orders < (
			SELECT AVG(total_orders)
			FROM product_performance)
		AND bad_review_pct >=(
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'Low Demand - Poor Reviews'
        ELSE 'Low Demand - Good Reviews'
        
        END AS product_performance_category
FROM product_performance)

SELECT
	*
FROM product_performance_cat
WHERE product_performance_category = 'High Demand - Good Reviews'
ORDER BY total_revenue DESC;
;
# There are 11 products with hight demand and Good reviews


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			AVG(ORD.review_score),2) AS avg_review_score,
		ROUND(
			SUM(CASE WHEN ORD.review_score <=2 then 1 ELSE 0 END) / NULLIF(COUNT(ORD.review_score),0)*100,2) AS bad_review_pct
	FROM products_dataset P
    LEFT JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	LEFT JOIN order_items_dataset OI
		ON P.product_id = OI.product_id
	LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
GROUP BY COALESCE(PC.product_category_name_english, 'unknown')),

product_performance_cat AS(
SELECT
	product_category,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE
		WHEN total_orders >= (
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct >= (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Poor Reviews'
        
        WHEN total_orders >=(
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct < (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Good Reviews'
        
        WHEN total_orders < (
			SELECT AVG(total_orders)
			FROM product_performance)
		AND bad_review_pct >=(
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'Low Demand - Poor Reviews'
        ELSE 'Low Demand - Good Reviews'
        
        END AS product_performance_category
FROM product_performance)

SELECT
	*
FROM product_performance_cat
WHERE product_performance_category = 'Low Demand - Poor Reviews'
ORDER BY total_revenue DESC;
;
# There are 22 products with low demand and poor reviews


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			AVG(ORD.review_score),2) AS avg_review_score,
		ROUND(
			SUM(CASE WHEN ORD.review_score <=2 then 1 ELSE 0 END) / NULLIF(COUNT(ORD.review_score),0)*100,2) AS bad_review_pct
	FROM products_dataset P
    LEFT JOIN product_category_name_translation PC
		ON P.product_category_name = PC.product_category_name
	LEFT JOIN order_items_dataset OI
		ON P.product_id = OI.product_id
	LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
GROUP BY COALESCE(PC.product_category_name_english, 'unknown')),

product_performance_cat AS(
SELECT
	product_category,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE
		WHEN total_orders >= (
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct >= (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Poor Reviews'
        
        WHEN total_orders >=(
			SELECT AVG(total_orders)
            FROM product_performance)
		AND bad_review_pct < (
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'High Demand - Good Reviews'
        
        WHEN total_orders < (
			SELECT AVG(total_orders)
			FROM product_performance)
		AND bad_review_pct >=(
			SELECT AVG(bad_review_pct)
            FROM product_performance)
		THEN 'Low Demand - Poor Reviews'
        ELSE 'Low Demand - Good Reviews'
        
        END AS product_performance_category
FROM product_performance)

SELECT
	*
FROM product_performance_cat
WHERE product_performance_category = 'Low Demand - Good Reviews'
ORDER BY total_revenue DESC;
;
# There are 31 products with low demand and good reviews



WITH product_performance_data_2 AS(
SELECT
	COALESCE(PC.product_category_name_english, 'unknown') AS product_category,
    OI.seller_id,
    COUNT(DISTINCT OI.order_id) AS total_orders,
    ROUND(SUM(OI.price),2) AS total_revenue,
    ROUND(AVG(ORD.review_score),2) AS avg_review_score,
    ROUND(
    SUM(CASE WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/ 
        NULLIF(COUNT(ORD.review_score),0)* 100, 2) AS bad_review_pct
        
FROM order_reviews_dataset ORD
LEFT JOIN order_items_dataset OI
	ON ORD.order_id = OI.order_id
INNER JOIN products_dataset P
	ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
	ON P.product_category_name = PC.product_category_name

GROUP BY PC.product_category_name_english,
	OI.seller_id),

product_to_seller AS(
SELECT 
	product_category,
    seller_id,
    total_orders,
    total_revenue,
    avg_review_score,
    bad_review_pct,
    CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM product_performance_data_2)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM product_performance_data_2)
			THEN 'High Volume - Poor Reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM product_performance_data_2)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM product_performance_data_2)
			THEN 'High Volume - Good reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM product_performance_data_2)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM product_performance_data_2)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS product_performance_category
    
FROM product_performance_data_2
)

SELECT 
    product_category,
    seller_id,
    product_performance_category
FROM product_to_seller
WHERE product_performance_category = 'High Volume - Poor Reviews'
ORDER BY bad_review_pct DESC
;
# This query show the sellers who are high volume low review relative to the average revenue and bad review percentage
# The number of sellers who are causing the high volume low review segment are 348

WITH product_performance AS (
    SELECT
        COALESCE(PC.product_category_name_english, 'unknown') AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND(SUM(OI.price), 2) AS total_revenue,
        ROUND(AVG(ORD.review_score), 2) AS avg_review_score,
        ROUND(
            SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END)
            / NULLIF(COUNT(ORD.review_score), 0) * 100,
            2
        ) AS bad_review_pct
    FROM order_items_dataset OI
    LEFT JOIN products_dataset P
        ON OI.product_id = P.product_id
    LEFT JOIN product_category_name_translation PC
        ON P.product_category_name = PC.product_category_name
    LEFT JOIN order_reviews_dataset ORD
        ON OI.order_id = ORD.order_id
    GROUP BY PC.product_category_name_english
),

high_demand_poor_reviews AS (
    SELECT product_category
    FROM product_performance
    WHERE total_orders >= (
        SELECT AVG(total_orders)
        FROM product_performance
    )
    AND bad_review_pct >= (
        SELECT AVG(bad_review_pct)
        FROM product_performance
    )
)

SELECT
	PC.product_category_name_english AS product_category,
    OI.seller_id,
    COUNT(DISTINCT OI.order_id) AS total_orders,
    ROUND(SUM(OI.price), 2) AS total_revenue,
    ROUND(AVG(ORD.review_score), 2) AS avg_review_score,
    ROUND(
        SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END)
        / NULLIF(COUNT(ORD.review_score), 0) * 100,
        2
    ) AS bad_review_pct

FROM order_items_dataset OI

JOIN products_dataset P
    ON OI.product_id = P.product_id

JOIN product_category_name_translation PC
    ON P.product_category_name = PC.product_category_name

LEFT JOIN order_reviews_dataset ORD
    ON OI.order_id = ORD.order_id

WHERE PC.product_category_name_english IN (
    SELECT product_category
    FROM high_demand_poor_reviews
)

GROUP BY
    PC.product_category_name_english,
    OI.seller_id

ORDER BY
    product_category,
    total_revenue DESC
;
#This is one shows the specific sellers who are responsible for the the high volume low review segemnt
# 