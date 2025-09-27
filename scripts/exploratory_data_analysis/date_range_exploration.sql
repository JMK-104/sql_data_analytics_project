/*
DATE RANGE EXPLORATION:
This script explores date ranges in the sales and customer datasets.

Purpose:
- To determine the temporal boundaries of key data points.
- To understand the range of historical data.

SQL Functions Used:
- MIN(), MAX(), EXTRACT(), AGE()
 */
-- Determine the first and last order dates and the total duration in months
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    EXTRACT(
        YEAR
        FROM
            AGE (MAX(order_date), MIN(order_date))
    ) * 12 + EXTRACT(
        MONTH
        FROM
            AGE (MAX(order_date), MIN(order_date))
    ) AS order_range_months
FROM
    gold.fact_sales
LIMIT
    10
;


-- Find the youngest and oldest customers based on birthdate
SELECT
    MIN(birthdate) AS oldest_birthdate,
    EXTRACT(
        YEAR
        FROM
            AGE (CURRENT_DATE, MIN(birthdate))
    ) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    EXTRACT(
        YEAR
        FROM
            AGE (CURRENT_DATE, MAX(birthdate))
    ) AS youngest_age
FROM
    gold.dim_customers
LIMIT
    10
;