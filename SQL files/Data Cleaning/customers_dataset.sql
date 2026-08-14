SELECT * FROM brazil_ecommerce_dataset.customers_dataset 
ORDER BY customer_zip_code_prefix ASC;

DESCRIBE customers_dataset;

UPDATE customers_dataset
SET customer_id = TRIM(customer_id);

SELECT *
FROM customers_dataset
WHERE customer_id = '' OR customer_id IS NULL;
#There are no missing customer id

SELECT COUNT(DISTINCT customer_id) AS count, customer_id
FROM customers_dataset
GROUP BY customer_id
HAVING count >1;
#There are no duplicate customer id

UPDATE customers_dataset
SET customer_unique_id = TRIM(cusutomer_unique_id);

SELECT *
FROM customers_dataset
WHERE customer_unique_id = '' OR customer_unique_id IS NULL;
#There are no missing customer unique id

UPDATE customers_dataset
SET customer_zip_code_prefix = TRIM(customer_code_prefix);

SELECT *
FROM customers_dataset
WHERE customer_zip_code_prefix = '' OR customer_zip_code_prefix IS NULL;
#There are no missing customer_zip_code_prefix

UPDATE customers_dataset
SET customer_city = TRIM(customer_city);

SELECT *
FROM customers_dataset
WHERE customer_city = '' OR customer_city IS NULL;
#There are no missing customer cities

UPDATE customers_dataset
SET customer_state = TRIM(customer_state);

SELECT *
FROM customers_dataset
WHERE customer_state = '' OR customer_state IS NULL;
#There are no miissing customer states