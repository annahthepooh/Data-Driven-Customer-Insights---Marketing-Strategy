SELECT *
FROM order_reviews_dataset;

SELECT 
	review_score,
	COUNT(review_score) AS review_count,
    ROUND(COUNT(review_score) / SUM(COUNT(review_score)) OVER() *100, 2) AS review_count_pct
FROM order_reviews_dataset
GROUP BY review_score
ORDER BY review_count DESC;
# This is if we use all comments including blank ones
# 5 was the most used point with 57.78%
# 4 followed with 19.29% and that was a really huge gap
# 1 was next with 11.51%
# 3 was 8.24%
# 2 was 3.18%

# More than 70% of the customers gave good review score showing a good sign

SELECT
	COUNT(review_comment_message) AS message_count
FROM order_reviews_dataset
WHERE review_comment_message != '' AND review_comment_message IS NOT NULL;
# There are only 11,566 review comments 


SELECT 
    review_score,
    review_comment_message,
    COUNT(*) OVER(PARTITION BY review_score) AS score_total_count,
    ROUND(
        COUNT(*) OVER(PARTITION BY review_score) * 100.0 / 
        COUNT(*) OVER(), 
        2) AS review_score_global_pct
        
FROM order_reviews_dataset
WHERE review_comment_message IS NOT NULL 
  AND TRIM(review_comment_message) != ''
ORDER BY review_score ASC;
# Score 5 is 57.55% percent of all filled comments
# Score 4 is 15%
# Score 3 is 7.22%
# Score 2 is 4.13%
# Score 1 is 16.9%
# This is when we are working with filled comments only
# The highest is 5, followed by 1, then closely by 4, then 3, then 2

#The customers who were either satisfied and enthusiastic or not satisfied at all were the ones commenting the most



# This below calculates the Net Promoter Score 
WITH SentimentCounts AS (
    SELECT 
        COUNT(*) AS total_count,
        SUM(CASE WHEN review_score = 5 THEN 1 ELSE 0 END) AS promoters,
        SUM(CASE WHEN review_score = 4 THEN 1 ELSE 0 END) AS passives,
        SUM(CASE WHEN review_score <= 3 THEN 1 ELSE 0 END) AS detractors
    FROM order_reviews_dataset
)
SELECT 
    promoters,
    passives,
    detractors,
    ROUND((promoters / total_count * 100) - (detractors / total_count * 100), 2) AS proxy_nps_score
FROM SentimentCounts;
# The proxy_nps_score is 34.84%


-- You would place this at the very end of your long RFM query, replacing your old final SELECT statement:
SELECT
    marketing_segment,
    ROUND(AVG(review_score), 2) AS average_review_score,
    COUNT(review_score) AS total_reviews_left,
    -- Percentage of reviews in this segment that were bad (1 or 2 stars)
    ROUND(SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS bad_review_pct
FROM Segments S
JOIN order_reviews_dataset R ON S.customer_unique_id = R.customer_id -- (Or your matching key)
GROUP BY marketing_segment
ORDER BY average_review_score ASC;
