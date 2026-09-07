# This looks at the product performance : the revenue generated per product, most ordered product and the products low average review score

WITH products_raw_data AS(
SELECT 
	P.product_id,
    P.product_category_name,
    PC.product_category_name_english,
    OI.order_id,
    OI.price,
    ORD.review_score
FROM product_category_name_translation PC
RIGHT JOIN products_dataset P ON PC.product_category_name = P.product_category_name
LEFT JOIN order_items_dataset OI ON P.product_id = OI.product_id
LEFT JOIN order_reviews_dataset ORD ON OI.order_id =  ORD.order_id)

SELECT
	COALESCE(product_category_name_english, 'Unknown') AS product_category_name_english,
    COUNT(DISTINCT order_id) AS total_products_ordered,
    ROUND(SUM(price),2) AS total_sales_revenue,
    ROUND(SUM(CASE WHEN review_score <=2 THEN 1 ELSE 0 END)/ COUNT(review_score)* 100, 2) AS product_bad_review_pct
FROM products_raw_data
GROUP BY product_category_name_english
ORDER BY product_bad_review_pct DESC; 
# bed bath table is the category with the most orders 
# health beauty, watches_gifts, bed_bath_table, sports_leisure and computer_accesories are the have the most revenue generation respectively
# security & services, fashion_male_clothing and office_furniture have the worst product_bad_review_pct respectively
