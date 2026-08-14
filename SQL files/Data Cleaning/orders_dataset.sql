SELECT * FROM brazil_ecommerce_dataset.orders_dataset;

SELECT COUNT(*)
FROM orders_dataset;
#There are 99441 orders in this dataset

DESCRIBE orders_dataset;

UPDATE orders_dataset
SET order_id = TRIM(order_id);

SELECT *
FROM orders_dataset
WHERE order_id = '' OR order_id IS NULL;
#There is no missing order_id

SELECT COUNT(DISTINCT order_id) AS count
FROM orders_dataset
GROUP BY order_id
HAVING count >1
ORDER BY order_id ASC;
#There are no duplicate order_id

UPDATE orders_dataset
SET customer_id = TRIM(customer_id);

SELECT *
FROM orders_dataset
WHERE customer_id = '' OR customer_id IS NULL;
#There are no missing customer_id

SELECT order_id, COUNT(DISTINCT order_id), COUNT(customer_id) AS cus_count
FROM orders_dataset
GROUP BY order_id
HAVING cus_count > 1
ORDER BY cus_count DESC;
#There are no duplicate customer_id

UPDATE orders_dataset
SET order_status = TRIM(order_status);

SELECT *
FROM orders_dataset
WHERE order_status = '' OR order_status IS NULL;
#There are no missing 

SELECT order_id, COUNT(DISTINCT order_id) AS count, order_status,COUNT(order_status) AS count_s 
FROM orders_dataset
GROUP BY order_id , order_status
HAVING count_s >1
ORDER BY count ASC;
#There are no duplicate order_status

UPDATE orders_dataset
SET order_purchase_timestamp = TRIM(order_purchase_timestamp);

SELECT *
FROM orders_dataset
WHERE order_purchase_timestamp IS NULL;
#There are no missing order_purchase_timestamp

UPDATE orders_dataset
SET order_approved_at = TRIM(order_approved_at);

SELECT *
FROM orders_dataset
WHERE order_approved_at IS NULL;
#There are 146 missing approval time

SELECT *
FROM orders_dataset
WHERE order_approved_at IS NULL;

UPDATE orders_dataset
SET order_delivered_carrier_date = TRIM(order_delivered_carrier_date);

SELECT COUNT(order_id)
FROM orders_dataset
WHERE order_delivered_carrier_date IS NULL;
#There are 1783 orders missing carrier delivery date


UPDATE orders_dataset
SET order_delivered_customer_date = TRIM(order_delivered_customer_date);

SELECT COUNT(order_id)
FROM orders_dataset
WHERE order_delivered_customer_date IS NULL;
#There are 2965 orders with missing customer delivery date

UPDATE orders_dataset
SET order_estimated_delivery_date = TRIM(order_estimated_delivery_date);

SELECT COUNT(order_id)
FROM orders_dataset
WHERE order_estimated_delivery_date IS NULL;
#There are no missing estimated delivery date