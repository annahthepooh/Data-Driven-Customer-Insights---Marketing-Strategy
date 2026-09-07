# Answers question 'Who are our customers?'
#This is to understand what our customer demographic consists of 

# The following have been applied: GROUP BY , CTE, chaining CTE, JOINS, Window function: ROW_NUMBER
# There are more acquisition opportunities than retention opportunities

SELECT * 
FROM customers_dataset;

SELECT COUNT(DISTINCT customer_id) AS customer_count
FROM customers_dataset;

#There are 99,441 unique customers

SELECT COUNT(DISTINCT customer_city) AS city_count
FROM customers_dataset;
#There are customers from unique 4119 cities

SELECT COUNT(DISTINCT customer_state) AS state_count
FROM customers_dataset;
#There are customers in 27 distinct states

SELECT COUNT(customer_id) AS customer_count,
	customer_state
FROM customers_dataset
GROUP BY customer_state
HAVING customer_state IN(
	SELECT DISTINCT customer_state 
    FROM customers_dataset)
ORDER BY customer_count DESC;
# Sao Paulo (SP) state is leading with 41,746 customers 
# Rio De Janeiro(RJ) comes second with 12,852 customers
# Minas Gerais(MG) is 3rd with 11,635 customers
# Roraima(RR), Amapa(AP) and Acre(AC) have the least number of customers with 46,68 and 81 customers respectively

SELECT *
FROM customers_dataset;

SELECT SUM(i.price) AS total_per_state,
    c.customer_state
FROM customers_dataset c
LEFT JOIN orders_dataset o
ON c.customer_id = o.customer_id
LEFT JOIN order_items_dataset i
ON o.order_id = i.order_id
GROUP BY c.customer_state
ORDER BY total_per_state DESC;
#Sao Paulo with 5,205,192 has the most revenue generation 
#Rio De Janeiro is 2nd with 1,824,815 
#Minas Gerais comes 3rd with 1,585,942
# The last 3 states with the least revenue generation are AC with 15,988 , AP with 13476 and RR with 7,834 respectively.

SELECT COUNT(order_id) AS orders_count,
	c.customer_state,
    c.customer_unique_id
FROM orders_dataset o
LEFT JOIN customers_dataset c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id,
	c.customer_state
ORDER BY orders_count DESC;
#There customer with the highest order count had ordered 17 times and they were from SP
#The 2nd one shopped 9 times and they were from SP

WITH CTE AS (
SELECT COUNT(order_id) AS orders_count,
	c.customer_state,
    c.customer_unique_id
FROM orders_dataset o
LEFT JOIN customers_dataset c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id,
	c.customer_state
HAVING orders_count = 1
ORDER BY orders_count DESC)

SELECT SUM(orders_count)
FROM CTE;
# 93,174 customers did a one time purchase

WITH CTE AS (
SELECT COUNT(order_id) AS orders_count,
	c.customer_state,
    c.customer_unique_id
FROM orders_dataset o
LEFT JOIN customers_dataset c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id,
	c.customer_state
HAVING orders_count != 1
ORDER BY orders_count DESC)

SELECT SUM(orders_count)
FROM CTE;
# 6,267 customers are repeat customers
#There are more one-time-purchase customers than repeat customers

SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
LEFT JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
LEFT JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name;

WITH joint AS (
SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
INNER JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
LEFT JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name)

SELECT COUNT(DISTINCT customer_unique_id) AS customer_count,
	payment_type
FROM joint
GROUP BY payment_type
ORDER BY customer_count DESC;

#Most customers use credit cards to pay for the orders, followed by boleto then vouchers and debit cards
#There is a very huge gap betweeen credit card users and the rest of the payment methods 
#There is also a great gap between the people who use boleto which is the second most used payment method and the vouchers and debit cards

SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
LEFT JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
LEFT JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name;

WITH joint AS (
SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type,
    O.order_status,
    O.order_purchase_timestamp,
    O.order_approved_at,
    O.order_delivered_carrier_date
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
INNER JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
LEFT JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name)

SELECT customer_id,
    product_id,
    product_category_name_english,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date
FROM joint
WHERE payment_type = 'not_defined';
# 3 orders have payment methods that are not defined because they cancelled the orders before they could be approved

WITH joint_data AS (
SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type,
    O.order_status,
    O.order_purchase_timestamp,
    O.order_approved_at,
    O.order_delivered_carrier_date
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
INNER JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
INNER JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name),

sales_by_location AS(
SELECT customer_state,
	product_category_name_english,
    product_id,
    COUNT(order_id) AS total_orders
    FROM joint_data
    GROUP BY customer_state,
		product_category_name_english,
        product_id),
        
ranked_sales AS(
SELECT customer_state,
	product_category_name_english,
    product_id,
    total_orders,
    ROW_NUMBER() OVER(PARTITION BY customer_state
					ORDER BY total_orders DESC) AS sales_rank
FROM sales_by_location)
                    
SELECT customer_state AS state,
	product_id,
	product_category_name_english AS product,
    total_orders AS units_sold
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY units_sold DESC;

# Sao Paulo's number 1 product is funiture decor(268)
# 10 states have health & beauty as their top order
# 5 states have computer accessories as the leading product being purchased
# 5 states have garden tools as their top product order
# 2 states have furniture decor as their top product order
# 1 state has auto as their top product order 
# 1 state has sports leisure as their number one product category
# 1 state has fixed telephony as their number one product category
# 1 state has books general interest as their number one product category
# 1 state has home apppliances as their number one product category


WITH joint_data AS (
SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type,
    O.order_status,
    O.order_purchase_timestamp,
    O.order_approved_at,
    O.order_delivered_carrier_date
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
INNER JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
INNER JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name),

sales_by_payment_method AS(
SELECT payment_type,
    COUNT(order_id) AS total_orders
    FROM joint_data
    GROUP BY payment_type),
        
ranked_sales AS(
SELECT payment_type,
    total_orders,
    ROW_NUMBER() OVER(PARTITION BY payment_type
					ORDER BY total_orders DESC) AS sales_rank
FROM sales_by_payment_method)
                    
SELECT payment_type AS payment,
    total_orders AS units_sold
FROM ranked_sales
WHERE sales_rank = 1
ORDER BY units_sold DESC;

#Customers use credit cards the most to pay for orders, followed by boleto, vouchers then debit cards

WITH joint_data AS (
SELECT C.customer_id,
	C.customer_unique_id,
    C.customer_city,
    C.customer_state,
    O.order_id,
    P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OP.payment_installments,
    OP.payment_type,
    O.order_status,
    O.order_purchase_timestamp,
    O.order_approved_at,
    O.order_delivered_carrier_date
FROM customers_dataset C 
LEFT JOIN orders_dataset O
ON C.customer_id = O.customer_id
INNER JOIN order_payment_dataset OP
ON O.order_id = OP.order_id
LEFT JOIN order_items_dataset OI
ON OP.order_id = OI.order_id
INNER JOIN products_dataset P
ON OI.product_id = P.product_id
LEFT JOIN product_category_name_translation PC
ON P.product_category_name = PC.product_category_name),

payment_by_state AS(
SELECT customer_state,
	payment_type,
    COUNT(payment_type) AS payment_count
    FROM joint_data
    GROUP BY customer_state,
		payment_type),
        
ranked_payment AS(
SELECT customer_state,
	payment_type,
	payment_count,
    ROW_NUMBER() OVER(PARTITION BY customer_state
					ORDER BY payment_count DESC) AS payment_rank
FROM payment_by_state)
                    
SELECT customer_state AS state,
	payment_type,
	payment_count
FROM ranked_payment
WHERE payment_rank = 1
ORDER BY payment_count DESC;

#The use of credit cards as 1st priority is dominant in all the 27 states
