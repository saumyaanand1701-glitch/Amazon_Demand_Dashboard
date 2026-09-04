-- Amazon Product Demand Analysis
-- SQL queries used to analyse cleaned Amazon product listing data

-- Query 1: Sponsored vs Organic demand comparison
SELECT is_sponsored_clean AS listing_type,
       COUNT(*) AS num_products,
       ROUND(AVG(monthly_demand), 0) AS avg_monthly_demand,
       ROUND(AVG(rating_numeric), 2) AS avg_rating
FROM products
GROUP BY is_sponsored_clean;

-- Query 2: Coupon vs No Coupon demand comparison
SELECT has_coupon,
       COUNT(*) AS num_products,
       ROUND(AVG(monthly_demand), 0) AS avg_monthly_demand,
       ROUND(AVG(current_price), 2) AS avg_price
FROM products
GROUP BY has_coupon;

-- Query 3: Demand by rating band
SELECT
    CASE
        WHEN rating_numeric >= 4.5 THEN '4.5-5.0'
        WHEN rating_numeric >= 4.0 THEN '4.0-4.49'
        WHEN rating_numeric >= 3.5 THEN '3.5-3.99'
        ELSE 'Below 3.5'
    END AS rating_band,
    COUNT(*) AS num_products,
    ROUND(AVG(monthly_demand), 0) AS avg_monthly_demand
FROM products
WHERE rating_numeric IS NOT NULL
GROUP BY rating_band
ORDER BY avg_monthly_demand DESC;

-- Query 4: Best seller badge impact
SELECT has_bestseller_badge,
       COUNT(*) AS num_products,
       ROUND(AVG(monthly_demand), 0) AS avg_monthly_demand,
       ROUND(AVG(review_count), 0) AS avg_review_count
FROM products
GROUP BY has_bestseller_badge;

-- Query 5: Demand by price band, ranked (window function)
WITH price_bands AS (
    SELECT *,
        CASE
            WHEN current_price < 15 THEN '1. Under $15'
            WHEN current_price < 30 THEN '2. $15-30'
            WHEN current_price < 60 THEN '3. $30-60'
            WHEN current_price < 120 THEN '4. $60-120'
            ELSE '5. $120+'
        END AS price_band
    FROM products
)
SELECT price_band, COUNT(*) AS num_products,
       ROUND(AVG(monthly_demand), 0) AS avg_monthly_demand,
       RANK() OVER (ORDER BY AVG(monthly_demand) DESC) AS demand_rank
FROM price_bands
GROUP BY price_band
ORDER BY price_band;
