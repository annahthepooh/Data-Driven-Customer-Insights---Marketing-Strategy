SHOW VARIABLES LIKE 'local infile';

CREATE TABLE products_dataset(
product_id TEXT,
product_category_name TEXT,
product_name_lenght INT,
product_description_lenght INT,
product_photo_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT,
product_width_cm INT);

ALTER TABLE products_dataset
RENAME COLUMN product_name_lenght TO product_name_length;

ALTER TABLE products_dataset
RENAME COLUMN product_description_lenght TO product_description_length;

ALTER TABLE products_dataset
RENAME COLUMN product_photo_qty TO product_photos_qty;

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_products_dataset.csv'
INTO TABLE products_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(product_id, 
product_category_name,
@v_name,
@v_description,
@v_photos,
@v_weight,
@v_length,
@v_height,
@v_width)
SET product_name_length = NULLIF(@v_name, ''),
	product_description_length = NULLIF(@v_description, ''),
    product_photos_qty = NULLIF(@v_photos, ''),
    product_weight_g = NULLIF(@v_weight, ''),
    product_length_cm = NULLIF(@v_length, ''),
    product_height_cm = NULLIF(@v_height, ''),
    product_width_cm = NULLIF(@v_width, '');
    
CREATE TABLE sellers_dataset(
seller_id TEXT,
seller_zip_code_prefix INT,
seller_city TEXT,
seller_state TEXT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_sellers_dataset.csv'
INTO TABLE sellers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(seller_id,
 @v_code,
seller_city,
seller_state)
SET seller_zip_code_prefix = NULLIF(@v_code, '');

CREATE TABLE product_category_name_translation(
product_category_name TEXT,
product_category_name_english TEXT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE order_reviews_dataset(
review_id TEXT,
order_id TEXT,
review_score INT,
review_coomment_title TEXT,
review_comment_messgae TEXT,
review_creation_date INT,
review_answer_timestamp INT);

ALTER TABLE order_reviews_dataset
MODIFY review_creation_date DATETIME;

ALTER TABLE order_reviews_dataset 
MODIFY review_answer_timestamp DATETIME;

ALTER TABLE order_reviews_dataset
RENAME COLUMN review_comment_messgae TO review_comment_message;

ALTER TABLE order_reviews_dataset
RENAME COLUMN review_coomment_title TO review_comment_title;


LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_order_reviews_dataset.csv'
INTO TABLE order_reviews_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(review_id,order_id,
review_score,
review_comment_title,
review_comment_message,
review_creation_date,
review_answer_timestamp);

CREATE TABLE orders_dataset(
order_id TEXT,
customer_id TEXT,
order_status TEXT,
order_purchase_timestamp INT,
order_approved_at INT,
order_delivered_carrier_date INT,
order_delivered_customer_date INT,
order_estimated_deilvery_date INT);

ALTER TABLE orders_dataset
MODIFY order_purchase_timestamp DATETIME;

ALTER TABLE orders_dataset
MODIFY order_approved_at DATETIME;

ALTER TABLE orders_dataset
MODIFY order_delivered_carrier_date DATETIME;

ALTER TABLE orders_dataset
MODIFY order_delivered_customer_date DATETIME;

ALTER TABLE orders_dataset
MODIFY order_estimated_deilvery_date DATETIME;

ALTER TABLE orders_dataset
RENAME COLUMN order_estimated_deilvery_date TO order_estimated_delivery_date;

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_orders_dataset.csv'
INTO TABLE orders_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(order_id,
customer_id,
order_status,
@v_purchase,
@v_approved,
@v_carrier,
@v_customer,
@v_estimated)
SET order_purchase_timestamp = NULLIF (@v_purchase, ''),
    order_approved_at = NULLIF (@v_approved, ''),
    order_delivered_carrier_date = NULLIF(@v_carrier, ''),
    order_delivered_customer_date = NULLIF(@v_customer, ''),
    order_estimated_delivery_date = NULLIF(@v_estimated, '');
    
CREATE TABLE order_payment_dataset(
order_id TEXT,
payment_sequential INT,
payment_type TEXT,
payment_installments INT,
payment_value INT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_order_payments_dataset.csv'
INTO TABLE order_payment_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE geolocation_data(
geolocation_zip_code_prefix INT,
geolocation_lat INT,
geolocation_lng INT,
geolocation_city TEXT,
geolocation_state TEXT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_geolocation_dataset.csv'
INTO TABLE geolocation_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE order_items_dataset(
order_id TEXT,
order_item_id INT,
product_id TEXT,
seller_id TEXT,
shipping_limit_date DATETIME,
price INT,
freight_value INT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_order_items_dataset.csv'
INTO TABLE order_items_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE customers_dataset(
customer_id TEXT,
customer_unique_id TEXT,
customer_zip_code_prefix INT,
customer_city TEXT,
customer_state TEXT);

LOAD DATA LOCAL INFILE 'C:\\Users\\HP\\Downloads\\Ann Preparing For  DA interview\\Data-Driven-Customer-Insights-&-Marketing-Strategy\\Raw Data\\olist_customers_dataset.csv'
INTO TABLE customers_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;