# This is to calculate the Revenue Contribution per segment

WITH raw_data AS (
    SELECT 
        C.customer_unique_id,
        O.order_id,
        O.order_purchase_timestamp,
        COALESCE(OP.payment_value, 0) AS payment_value
    FROM customers_dataset C
    LEFT JOIN orders_dataset O ON C.customer_id = O.customer_id
    LEFT JOIN order_payment_dataset OP ON O.order_id = OP.order_id
),

RFM_values AS (
    SELECT 
        customer_unique_id,
        DATEDIFF('2018-12-31', DATE(MAX(order_purchase_timestamp))) AS Recency_Value,
        COUNT(DISTINCT order_id) AS Frequency_Value,
        ROUND(SUM(payment_value), 2) AS Monetary_Value
    FROM raw_data
    GROUP BY customer_unique_id 
),
    
RFM_Codes AS (
    SELECT
        customer_unique_id,
        Monetary_Value,
        NTILE(5) OVER(ORDER BY Recency_Value ASC) AS R_Code,
        NTILE(5) OVER(ORDER BY Frequency_Value DESC) AS F_Code,
        NTILE(5) OVER(ORDER BY Monetary_Value DESC) AS M_Code
    FROM RFM_values
),

Segments AS (    
    SELECT 
        customer_unique_id,
        Monetary_Value,
        CASE
            WHEN R_Code >= 4 AND F_Code >= 4 AND M_Code >= 4 THEN 'Champion'
            WHEN R_Code <= 2 AND F_Code >= 4 AND M_Code >= 4 THEN 'Cannot lose them'
            WHEN R_Code >= 3 AND F_Code >= 3 AND M_Code >= 3 THEN 'Loyal customers'
            WHEN R_Code >= 4 AND F_Code <= 1 THEN 'New buyers'
            WHEN R_Code = 3 AND F_Code <= 2 AND M_Code <= 2 THEN 'About to sleep'
            WHEN R_Code <= 2 AND F_Code <= 2 AND M_Code <= 2 THEN 'Lost'
            ELSE 'Regular spontaneous customer'
        END AS marketing_segment
    FROM RFM_Codes
)

SELECT
    marketing_segment,
    ROUND(SUM(Monetary_Value), 2) AS segment_revenue,
    ROUND(SUM(Monetary_Value) / SUM(SUM(Monetary_Value)) OVER () * 100, 2) AS revenue_contribution_pct
FROM Segments
GROUP BY marketing_segment
ORDER BY segment_revenue DESC;
# Regular spontaneous customers contribute the most with 52.16%
# Lost customers are second with 27.93%
# Loyal customers come 3rd with 10.20%
# Champions come next with 5.01%
# About to sleep customers are next with 2.71%
# The least amount of contribution comes from New buyers with 1.98%