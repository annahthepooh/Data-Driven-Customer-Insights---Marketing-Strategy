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