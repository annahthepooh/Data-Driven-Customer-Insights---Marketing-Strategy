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
			SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END),2) AS avg_review_score,
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
			SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END),2) AS avg_review_score,
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
ORDER BY total_orders DESC;
;
# There are 8 product categories with high demand but poor reviews



WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END),2) AS avg_review_score,
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
ORDER BY total_orders DESC;
;
# There are 11 products with hight demand and Good reviews


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END),2) AS avg_review_score,
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
ORDER BY total_orders DESC;
;
# There are 22 products with low demand and poor reviews


WITH product_performance AS(
	SELECT 
		COALESCE(product_category_name_english, 'unknown')AS product_category,
        COUNT(DISTINCT OI.order_id) AS total_orders,
        ROUND (SUM(OI.price),2) AS total_revenue,
        ROUND(
			SUM(CASE WHEN ORD.review_score <= 2 THEN 1 ELSE 0 END),2) AS avg_review_score,
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
ORDER BY total_orders DESC;
;
# There are 31 products with low demand and good reviews
