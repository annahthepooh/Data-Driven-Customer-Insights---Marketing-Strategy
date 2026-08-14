SELECT * FROM brazil_ecommerce_dataset.product_category_name_translation;

DESCRIBE product_category_name_translation;

UPDATE product_category_name_translation
SET product_category_name = TRIM(product_category_name);

UPDATE product_category_name_translation
SET product_category_name_english = TRIM(product_category_name_english);

SELECT *
FROM product_category_name_translation
ORDER BY product_category_name_english ASC;

SELECT *
FROM product_category_name_translation
WHERE product_category_name LIKE ('fashion_roupa_fe%');

UPDATE product_category_name_translation
SET product_category_name_english = 'fashion_female_clothing'
WHERE product_category_name = 'fashion_roupa_feminina';

SELECT COUNT(DISTINCT product_category_name) AS count,product_category_name
FROM product_category_name_translation
GROUP BY product_category_name
ORDER BY count DESC;
#There are no duplicate categories