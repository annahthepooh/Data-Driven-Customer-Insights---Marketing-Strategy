SELECT * FROM brazil_ecommerce_dataset.order_reviews_dataset;

DESCRIBE order_reviews_dataset;

UPDATE order_reviews_dataset
SET review_id = TRIM(review_id);

SELECT *
FROM order_reviews_dataset
WHERE review_id = '' OR review_id IS NULL;
#There are no missing review_id

SELECT COUNT(review_id) AS rev_count, review_id,order_id
FROM order_reviews_dataset
GROUP BY order_id, review_id
HAVING rev_count > 1
ORDER BY review_id DESC;
#There are no duplicate revenue_id

UPDATE order_reviews_dataset
SET order_id = TRIM(order_id);

SELECT *
FROM order_reviews_dataset
WHERE review_score = '' OR review_score IS NULL;
#There is no missing review_score

UPDATE order_reviews_dataset
SET review_comment_title = TRIM(review_comment_title);

UPDATE order_reviews_dataset
SET review_comment_message = TRIM(review_comment_title);

UPDATE order_reviews_dataset
SET review_creation_date = TRIM(review_creation_date);

UPDATE order_reviews_dataset
SET review_answer_timestamp = TRIM(review_answer_timestamp);

SELECT COUNT(review_creation_date)
FROM order_reviews_dataset
WHERE review_answer_timestamp IS NULL;