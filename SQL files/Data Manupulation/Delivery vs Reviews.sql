# This query is to segment the orders per seller id in relation to delivery time and reviews
# There are 6 segments : High reviews good delivery good reviews ,High reviews poor delivery good reviews ,High reviews poor delivery poor reviews ,Low reviews good delivery good reviews ,Low reviews poor delivery good reviews ,Low reviews poor delivery poor reviews 


WITH delivery_raw_data AS (
    SELECT 
        OI.order_id AS order_id,
        OI.seller_id,
        DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
        COALESCE(OI.price, 0) AS price,
        DATE(O.order_delivered_customer_date) AS customer_delivery_date,
        ORD.review_score
    FROM orders_dataset O
    INNER JOIN order_items_dataset OI ON O.order_id = OI.order_id
    LEFT JOIN order_reviews_dataset ORD ON OI.order_id = ORD.order_id
    WHERE O.order_status NOT IN ('canceled', 'unavailable')
      AND O.order_delivered_carrier_date IS NOT NULL
),
        
calculated_date AS (
    SELECT 
        seller_id,
        order_id,
        price,
        estimated_delivery_date,
        customer_delivery_date, 
        (estimated_delivery_date - customer_delivery_date) AS date_diff,
        review_score,
        ROUND(COALESCE(SUM(price) OVER(PARTITION BY seller_id), 0), 2) AS total_revenue,
        ROUND(
            SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) OVER(PARTITION BY seller_id) /
            NULLIF(COUNT(review_score) OVER(PARTITION BY seller_id), 0) * 100, 2
        ) AS bad_review_pct
    FROM delivery_raw_data
),

global_averages AS (
    SELECT 
        AVG(total_revenue) AS avg_total_revenue,
        AVG(bad_review_pct) AS avg_bad_review_pct
    FROM calculated_date
)
    
SELECT
    c.seller_id,
    c.order_id,
    c.price,
    c.estimated_delivery_date,
    c.customer_delivery_date,
    c.date_diff,
    c.total_revenue,
    CASE
        WHEN c.total_revenue >= g.avg_total_revenue AND c.date_diff < 0  AND c.bad_review_pct >= g.avg_bad_review_pct THEN 'High Revenue Poor Delivery Poor Reviews'
        WHEN c.total_revenue >= g.avg_total_revenue AND c.date_diff < 0 AND c.bad_review_pct < g.avg_bad_review_pct THEN 'High Revenue Poor Delivery Good Reviews'
        WHEN c.total_revenue >= g.avg_total_revenue AND c.date_diff >= 0 AND c.bad_review_pct < g.avg_bad_review_pct THEN 'High Revenue Good Delivery Poor Reviews'
        WHEN c.total_revenue < g.avg_total_revenue  AND c.date_diff >= 0 AND c.bad_review_pct >= g.avg_bad_review_pct THEN 'Low Revenue Good Delivery Good Reviews'
		WHEN c.total_revenue < g.avg_total_revenue  AND c.date_diff < 0 AND c.bad_review_pct >= g.avg_bad_review_pct THEN 'Low Revenue Poor Delivery Good Reviews'
        WHEN c.total_revenue < g.avg_total_revenue  AND c.date_diff >= 0 AND c.bad_review_pct < g.avg_bad_review_pct THEN 'Low Revenue Good Delivery Poor Reviews'
        WHEN c.total_revenue >= g.avg_total_revenue AND c.date_diff >= 0 AND c.bad_review_pct >= g.avg_bad_review_pct THEN 'High Revenue Good Delivery Good Reviews'
        ELSE 'Low Revenue Poor Delivery Poor Reviews'
    END AS delivery_vs_review_segments
FROM calculated_date c
CROSS JOIN global_averages g
ORDER BY c.date_diff DESC;
