SELECT * FROM brazil_ecommerce_dataset.order_items_dataset;

DESCRIBE order_items_dataset;

UPDATE order_items_dataset
SET order_id = TRIM(order_id);

SELECT *
FROM order_items_dataset
WHERE order_id = '' OR order_id IS NULL;
#No order_id is missing

SELECT COUNT(DISTINCT order_id) AS count
FROM order_items_dataset
GROUP BY order_id
HAVING count>1
ORDER BY count ASC;
#There are no duplicate order_id 

UPDATE order_items_dataset
SET order_item_id = TRIM(order_item_id);

SELECT *
FROM order_items_dataset
WHERE order_item_id = '' OR order_item_id IS NULL;
#There is  no missing order_item_id

SELECT COUNT(DISTINCT order_item_id) AS count, order_id,product_id
FROM order_items_dataset
GROUP BY order_id,product_id
HAVING count=1
ORDER BY count ASC;

UPDATE order_items_dataset
SET product_id = TRIM(product_id);

SELECT *
FROM order_items_dataset
WHERE product_id = '' OR product_id IS NULL;
#There is no missing product_id

SELECT *
FROM order_items_dataset;

UPDATE order_items_dataset
SET seller_id = TRIM(seller_id);

SELECT *
FROM order_items_dataset
WHERE seller_id = '' OR seller_id IS NULL;
#There is no missing seller_id

UPDATE order_items_dataset
SET shipping_limit_date = TRIM(shipping_limit_date);

SELECT *
FROM order_items_dataset
WHERE shipping_limit_date IS NULL;
#There is no missing shipping_limit_date

UPDATE order_items_dataset
SET price = TRIM(price);

SELECT *
FROM order_items_dataset
WHERE price = '' OR price IS NULL;
#There is no missing price

UPDATE order_items_dataset
SET freight_value = TRIM(freight_value);

SELECT *
FROM order_items_dataset
WHERE freight_value = '' OR freight_value IS NULL;
#494 orders have 0 freight_value
#Freight value is the amount it costs to transport a specific cargo or shipment from one destination to another