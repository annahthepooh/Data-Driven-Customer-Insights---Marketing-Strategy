#This is to calculate the Repeat Purchase Rate
#The first is with all orders included
#The second one is with canceled orders removed 

WITH data AS (
    SELECT 
        C.customer_unique_id,
        O.order_id,
        O.order_status
    FROM orders_dataset O
    LEFT JOIN customers_dataset C ON O.customer_id = C.customer_id
    WHERE O.order_status != 'canceled' 
),
    
orders_count AS (
    SELECT 
        customer_unique_id,
        COUNT(order_id) AS order_count
    FROM data
    GROUP BY customer_unique_id
),
    
infinity AS (
    SELECT 
        COUNT(customer_unique_id) AS total_customers,
        SUM(IF(order_count > 1, 1, 0)) AS repeat_customers,
        ROUND(SUM(IF(order_count > 1, 1, 0)) / COUNT(customer_unique_id) * 100, 2) AS repeat_purchase_rate
    FROM orders_count
)

SELECT 
    repeat_purchase_rate,
    total_customers,
    repeat_customers
FROM infinity;
#The repeat purchase rate with the canceled orders removed is 3.06%


WITH data AS (
    SELECT 
        C.customer_unique_id,
        O.order_id,
        O.order_status
    FROM orders_dataset O
    LEFT JOIN customers_dataset C ON O.customer_id = C.customer_id
),
    
orders_count AS (
    SELECT 
        customer_unique_id,
        COUNT(order_id) AS order_count
    FROM data
    GROUP BY customer_unique_id
),
    
infinity AS (
    SELECT 
        COUNT(customer_unique_id) AS total_customers,
        SUM(IF(order_count > 1, 1, 0)) AS repeat_customers,
        -- 💡 Fixed the math: SUM of repeat customers divided by total customers
        ROUND(SUM(IF(order_count > 1, 1, 0)) / COUNT(customer_unique_id) * 100, 2) AS repeat_purchase_rate
    FROM orders_count
)

SELECT 
    repeat_purchase_rate,
    total_customers,
    repeat_customers
FROM infinity;
#The repeat purchase rate with every order including the canceled ones is 3.12%

#The repeat purchase rate with all orders included is more than the repeat purchase rate without the canceled orders