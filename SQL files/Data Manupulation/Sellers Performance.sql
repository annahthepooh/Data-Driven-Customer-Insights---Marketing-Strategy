# This analyzes the performance of the sellers individually
# Looks at the number of orders per seller, revenue generated per seller, average review score per seller and bad review percent per seller to determine which ones are a liability and need improvement and which ones are not


WITH seller_raw_data AS (
    SELECT 
        OI.seller_id,
        OI.order_id,
        COALESCE(OI.price, 0) AS item_price,
        ORD.review_score
    FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD ON OI.order_id = ORD.order_id
)

SELECT 
    seller_id,
    COUNT(DISTINCT order_id) AS total_orders_fulfilled,
    ROUND(SUM(item_price), 2) AS total_sales_revenue,
    ROUND(AVG(review_score), 2) AS avg_seller_review,
    ROUND(SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) / COUNT(review_score) * 100, 2) AS seller_bad_review_pct
FROM seller_raw_data
WHERE seller_id IS NOT NULL
GROUP BY seller_id
HAVING total_orders_fulfilled >= 10 
ORDER BY total_orders_fulfilled DESC;


# Sellers with less than 10 orders are excluded to reduce the influence of extremely small sample sizes on seller performance comparisons


WITH seller_performance AS(
	SELECT
		OI.seller_id,
        COUNT(OI.order_id) AS total_orders,
        ROUND(SUM(COALESCE(OI.price,0)),2) AS total_revenue,
        ROUND(AVG(ORD.review_score),2) AS avg_review_score,
        ROUND(SUM(CASE
				WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/
                NULLIF(COUNT(ORD.review_score),0)* 100,2) AS bad_review_pct
	FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
	WHERE OI.seller_id IS NOT NULL
    GROUP BY OI.seller_id
    HAVING COUNT(DISTINCT OI.order_id) >=10)
    
    SELECT
		seller_id,
        total_orders,
        total_revenue,
        avg_review_score,
        bad_review_pct,
        CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Poor Reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Good Reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS seller_performance_category
	FROM seller_performance
    ORDER BY total_orders DESC
;
# segment sellers into 4 categories based on the order volume vs the review score
# The segments are : high volume poor review, high volume good review, low volume poor review and low volume good review


WITH seller_performance AS(
	SELECT
		OI.seller_id,
        COUNT(OI.order_id) AS total_orders,
        ROUND(SUM(COALESCE(OI.price,0)),2) AS total_revenue,
        ROUND(AVG(ORD.review_score),2) AS avg_review_score,
        ROUND(SUM(CASE
				WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/
                NULLIF(COUNT(ORD.review_score),0)* 100,2) AS bad_review_pct
	FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
	WHERE OI.seller_id IS NOT NULL
    GROUP BY OI.seller_id
    HAVING COUNT(DISTINCT OI.order_id) >=10),
 
seller_performance_cat AS( 
    SELECT
		seller_id,
        total_orders,
        total_revenue,
        avg_review_score,
        bad_review_pct,
        CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Poor reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Good reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS seller_performance_category
	FROM seller_performance
    ORDER BY total_orders DESC)
    
SELECT 
	*
FROM seller_performance_cat
WHERE seller_performance_category = 'High Volume - Poor Reviews'
ORDER BY total_revenue DESC;
;
# There are 139 sellers with high volume of orders and poor reviews



WITH seller_performance AS(
	SELECT
		OI.seller_id,
        COUNT(OI.order_id) AS total_orders,
        ROUND(SUM(COALESCE(OI.price,0)),2) AS total_revenue,
        ROUND(AVG(ORD.review_score),2) AS avg_review_score,
        ROUND(SUM(CASE
				WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/
                NULLIF(COUNT(ORD.review_score),0)* 100,2) AS bad_review_pct
	FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
	WHERE OI.seller_id IS NOT NULL
    GROUP BY OI.seller_id
    HAVING COUNT(DISTINCT OI.order_id) >=10),
 
seller_performance_cat AS( 
    SELECT
		seller_id,
        total_orders,
        total_revenue,
        avg_review_score,
        bad_review_pct,
        CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Poor reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Good reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS seller_performance_category
	FROM seller_performance
    ORDER BY total_orders DESC)
    
SELECT 
	*
FROM seller_performance_cat
WHERE seller_performance_category = 'High Volume - Good Reviews'
ORDER BY total_revenue DESC;
;
# There are 165 sellers with high order volume and good reviews meaning they are thriving



WITH seller_performance AS(
	SELECT
		OI.seller_id,
        COUNT(OI.order_id) AS total_orders,
        ROUND(SUM(COALESCE(OI.price,0)),2) AS total_revenue,
        ROUND(AVG(ORD.review_score),2) AS avg_review_score,
        ROUND(SUM(CASE
				WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/
                NULLIF(COUNT(ORD.review_score),0)* 100,2) AS bad_review_pct
	FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
	WHERE OI.seller_id IS NOT NULL
    GROUP BY OI.seller_id
    HAVING COUNT(DISTINCT OI.order_id) >=10),
 
seller_performance_cat AS( 
    SELECT
		seller_id,
        total_orders,
        total_revenue,
        avg_review_score,
        bad_review_pct,
        CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Poor reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Good reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS seller_performance_category
	FROM seller_performance
    ORDER BY total_orders DESC)
    
SELECT 
	*
FROM seller_performance_cat
WHERE seller_performance_category = 'Low Volume - Poor Reviews'
ORDER BY total_revenue DESC;
;
# There are 387 sellers with low order volume and poor review


WITH seller_performance AS(
	SELECT
		OI.seller_id,
        COUNT(OI.order_id) AS total_orders,
        ROUND(SUM(COALESCE(OI.price,0)),2) AS total_revenue,
        ROUND(AVG(ORD.review_score),2) AS avg_review_score,
        ROUND(SUM(CASE
				WHEN ORD.review_score <=2 THEN 1 ELSE 0 END)/
                NULLIF(COUNT(ORD.review_score),0)* 100,2) AS bad_review_pct
	FROM order_items_dataset OI
    LEFT JOIN order_reviews_dataset ORD
		ON OI.order_id = ORD.order_id
	WHERE OI.seller_id IS NOT NULL
    GROUP BY OI.seller_id
    HAVING COUNT(DISTINCT OI.order_id) >=10),
 
seller_performance_cat AS( 
    SELECT
		seller_id,
        total_orders,
        total_revenue,
        avg_review_score,
        bad_review_pct,
        CASE 
			WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Poor reviews'
            
            WHEN total_orders >=(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct <(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'High Volume - Good reviews'
            
            WHEN total_orders <(
				SELECT AVG(total_orders)
                FROM seller_performance)
			AND bad_review_pct >=(
				SELECT AVG(bad_review_pct)
                FROM seller_performance)
			THEN 'Low Volume - Poor Reviews'
            
            ELSE 'Low Volume - Good Reviews'
            
            END AS seller_performance_category
	FROM seller_performance
    ORDER BY total_orders DESC)
    
SELECT 
	*
FROM seller_performance_cat
WHERE seller_performance_category = 'Low Volume - Good Reviews'
ORDER BY total_revenue DESC;
;
# There are 580 sellers with low order volume and good review
# That means that there is room for expansion through awareness campaign