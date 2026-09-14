#Goal is to calculate the Average Order Value (AOV)

# The following have been applied: JOINS, Stored procedure, 

# AOV ( 0 payment values not included and canceled orders)
# AOV (all values included)
# AOV (only canceled orders not included)

# There are 100 orders with 0 payment values
# 4 of them are canceled orders

# The AOV without the 0 payment values is higher(211.0271) than with then 0 values(154.1083). It is lowest without the canceled orders only (153.7118)


SELECT * FROM brazil_ecommerce_dataset.order_payment_dataset;

SELECT *
FROM order_items_dataset
WHERE price = 0;

SELECT *
FROM orders_dataset O
LEFT JOIN order_items_dataset OI
ON O.order_id = OI.order_id
WHERE price = 0 AND order_status = 'canceled';

SELECT *
FROM orders_dataset O
LEFT JOIN order_items_dataset OI
ON O.order_id = OI.order_id
WHERE price = 0 AND order_status = 'delivered';

SELECT *
FROM orders_dataset O
LEFT JOIN order_items_dataset OI
ON O.order_id = OI.order_id
WHERE price = 0 AND order_status = 'shipped';

SELECT *
FROM orders_dataset O
LEFT JOIN order_items_dataset OI
ON O.order_id = OI.order_id
WHERE price = 0 AND order_status = 'processing';

SELECT *
FROM orders_dataset O
LEFT JOIN order_items_dataset OI
ON O.order_id = OI.order_id
WHERE price = 0 AND order_status = 'unavailable';

DELIMITER //
CREATE PROCEDURE calculate_Applicable_AOV_without_0_value()
	BEGIN
		SELECT SUM(price)/ COUNT(O.order_id) AS Average_Order_Value
        FROM orders_dataset O
        LEFT JOIN order_items_dataset OI
		ON O.order_id = OI.order_id
		WHERE order_status != 'canceled'
		AND (order_status != 'delivered' AND price != 0)
		AND (order_status != 'shipped' AND price != 0)
		AND (order_status != 'processing' AND price !=0)
		AND (order_status != 'unavailable' AND price !=0);
	END 
// DELIMITER ;

DROP PROCEDURE IF EXISTS calculate_Applicable_AOV_without_0_value;

CALL calculate_Applicable_AOV_without_0_value;
#The net AOV without the all 0 payment values is 170.5884


DELIMITER //
CREATE PROCEDURE calculate_Applicable_AOV_with_0_value()
	BEGIN
		SELECT SUM(price)/ COUNT(O.order_id) AS Average_Order_Value
		FROM orders_dataset O
        LEFT JOIN order_items_dataset OI
		ON O.order_id = OI.order_id;
	END
// DELIMITER ;

DROP PROCEDURE IF EXISTS calculate_Applicable_AOV_with_0_value;

CALL calculate_Applicable_AOV_with_0_value;
# The AOV with gross revenue including the 0 payment_values is 119.8765

DELIMITER //
CREATE PROCEDURE calculate_Applicable_AOV_without_canceled_values()
	BEGIN
		SELECT SUM(price)/ COUNT(O.order_id) AS Average_Order_Value
        FROM orders_dataset O
        LEFT JOIN order_items_dataset OI
		ON O.order_id = OI.order_id
		WHERE order_status != 'canceled';
	END 
// DELIMITER ;

DROP PROCEDURE IF EXISTS calculate_Applicable_AOV_without_canceled_values;

CALL calculate_Applicable_AOV_without_canceled_values;
#The AOV without canceled orders is 119.7822