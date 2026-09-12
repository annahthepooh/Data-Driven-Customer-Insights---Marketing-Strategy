WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
		DATE(OI.shipping_limit_date) AS shipping_deadline,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		order_id,
		price,
		shipping_deadline,
		customer_delivery_date, 
        shipping_deadline - customer_delivery_date AS date_diff
	FROM delivery_raw_data)
    
SELECT
	order_id,
    price,
    shipping_deadline,
    customer_delivery_date,
    date_diff
FROM calculated_date
WHERE date_diff > 0
ORDER BY date_diff DESC;
# There are 17,997 orders that where delivered earlier than the shipping deadline which is good


WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
		DATE(OI.shipping_limit_date) AS shipping_deadline,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		order_id,
		price,
		shipping_deadline,
		customer_delivery_date, 
        shipping_deadline - customer_delivery_date AS date_diff
	FROM delivery_raw_data)
    
SELECT
	order_id,
    price,
    shipping_deadline,
    customer_delivery_date,
    date_diff
FROM calculated_date
WHERE date_diff < 0
ORDER BY date_diff ASC;
# 72,124 orders were delivered after the shipping limit date an that is not a good sign because that means that they delivery  was late
# There was more late order delivery than the ones delivered on time


WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
		DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		order_id,
		price,
		estimated_delivery_date,
		customer_delivery_date, 
        estimated_delivery_date - customer_delivery_date AS date_diff
	FROM delivery_raw_data)
    
SELECT
	order_id,
    price,
    estimated_delivery_date,
    customer_delivery_date,
    date_diff
FROM calculated_date
WHERE date_diff > 0
ORDER BY date_diff DESC;
# There are 91,063 orders that where delivered before the estimated time



WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
		DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		order_id,
		price,
		estimated_delivery_date,
		customer_delivery_date, 
        estimated_delivery_date - customer_delivery_date AS date_diff
	FROM delivery_raw_data)
    
SELECT
	order_id,
    price,
    estimated_delivery_date,
    customer_delivery_date,
    date_diff
FROM calculated_date
WHERE date_diff < 0
ORDER BY date_diff ASC;
# 6602 orders were delivered after the estimated delivery date

WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
		DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
        DATE(OI.shipping_limit_date) AS shipping_deadline,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		order_id,
		price,
		estimated_delivery_date,
        shipping_deadline,
		customer_delivery_date, 
        estimated_delivery_date - customer_delivery_date AS date_diff,
        shipping_deadline - customer_delivery_date AS date_diff_shipment
        
	FROM delivery_raw_data)
    
SELECT
	order_id,
    price,
    estimated_delivery_date,
    shipping_deadline,
    customer_delivery_date,
    date_diff,
    date_diff_shipment
FROM calculated_date
WHERE date_diff < 0 AND date_diff_shipment < 0
ORDER BY date_diff DESC, date_diff_shipment DESC;
# There are 6,589 orders that where delivered after the estimated time and shipping deadline


WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
        OI.seller_id,
		DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		seller_id,
		order_id,
		delivery_raw_data.price,
		estimated_delivery_date,
		customer_delivery_date, 
        estimated_delivery_date - customer_delivery_date AS date_diff,
        ROUND(COALESCE(SUM(price) OVER(ORDER BY seller_id),0),2) AS total_revenue
	FROM delivery_raw_data)
    
    
SELECT
	seller_id,
	order_id,
    calculated_date.price,
    estimated_delivery_date,
    customer_delivery_date,
    date_diff,
    total_revenue
FROM calculated_date
WHERE date_diff > 0
ORDER BY date_diff DESC;
# This shows the total revenue per seller, the date difference of the customer delivery date to the estimated delivery date and the shipping limit date 


WITH delivery_raw_data AS(
	SELECT 
		DISTINCT OI.order_id AS order_id,
        OI.seller_id,
		DATE(O.order_estimated_delivery_date) AS estimated_delivery_date,
		COALESCE(OI.price, 0) AS price,
		DATE(O.order_delivered_customer_date) AS customer_delivery_date
	FROM order_items_dataset OI
	RIGHT JOIN orders_dataset O
		ON OI.order_id = O.order_id
	WHERE (O.order_status != 'canceled' AND O.order_status != 'unavailable')
		AND O.order_delivered_carrier_date IS NOT NULL),
        
calculated_date AS(
	SELECT 
		seller_id,
		order_id,
		delivery_raw_data.price,
		estimated_delivery_date,
		customer_delivery_date, 
        estimated_delivery_date - customer_delivery_date AS date_diff,
        ROUND(COALESCE(SUM(price) OVER(ORDER BY seller_id),0),2) AS total_revenue
	FROM delivery_raw_data)
    
    
SELECT
	seller_id,
	order_id,
    calculated_date.price,
    estimated_delivery_date,
    customer_delivery_date,
    date_diff,
    total_revenue,
    CASE
		WHEN total_revenue >(
			SELECT AVG(total_revenue)
			FROM calculated_date)
		AND date_diff < 0 
		THEN 'High Revenue Poor Delivery'
	
		WHEN total_revenue <(
			SELECT AVG(total_revenue)
            FROM calculated_date)
		AND date_diff < 0
        THEN 'Low Revenue Good Delivery'
        
        WHEN total_revenue >(
			SELECT AVG(total_revenue)
            FROM calculated_date)
		AND date_diff > 0 
        THEN 'High Revenue Good Delivery'
        
        ELSE 'Low Revenue Poor Delivery'
        
        END AS delivery_date_segments
        
FROM calculated_date
WHERE date_diff > 0
ORDER BY date_diff DESC; 
# This query segments the orders showing the sellers vs the delviery date and the revenue
# The 4 segemnts are High revenue good delivery, high revenue poor delivery, low revenue high delivery, low revenue poor delivery
# The high revenue good delivery are sellers who generate high revenue and deliver the orders on time 
# The high revenue poor delivery are sellers who generate high revenue but delvier the orders later than the expected time
# The low revenue good delivery generate low revenue but deliver on time 
# The low revenue poor delivery generate low revenue and deliver way past the expected time

# These segments are in relation to the average total revenue 