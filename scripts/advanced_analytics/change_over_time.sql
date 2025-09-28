/*
CHANGE OVER TIME ANALYSIS:
Purpose:
- The purpose of this script is to analyse how key metrics change over time
- Perform time-series analysis in order to identify trends, seasonality, and
growth or decline over specific periods.
SQL Functions and Clauses used:
- Date Functions: DATEPART(), DATETRUNC()
- Aggregate Functions: SUM(), COUNT(), AVG()
 */
-- Retrieve a summary of sales performance over time
-- Insights:
-- This query provides a summary of sales performance over time, broken down by year and month
SELECT
    DATE_PART('year', order_date) AS order_year,
    CASE (DATE_PART('month', order_date))
        WHEN '1' THEN 'January'
        WHEN '2' THEN 'February'
        WHEN '3' THEN 'March'
        WHEN '4' THEN 'April'
        WHEN '5' THEN 'May'
        WHEN '6' THEN 'June'
        WHEN '7' THEN 'July'
        WHEN '8' THEN 'August'
        WHEN '9' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    gold.fact_sales
WHERE
    order_date IS NOT NULL
GROUP BY
    order_year,
    order_month
ORDER BY
    order_year,
    order_month
;


-- Explore the seasonality of sales by aggregating data on a monthly basis
-- Insights:
-- This query helps to identify seasonal patterns in sales by aggregating data on a monthly basis
-- It provides insights into which months tend to have higher or lower sales, customer activity, and quantity sold
WITH
    cte AS (
        SELECT
            DATE_PART('year', order_date) AS order_year,
            DATE_PART('month', order_date) AS month_number,
            CASE (DATE_PART('month', order_date))
                WHEN '1' THEN 'January'
                WHEN '2' THEN 'February'
                WHEN '3' THEN 'March'
                WHEN '4' THEN 'April'
                WHEN '5' THEN 'May'
                WHEN '6' THEN 'June'
                WHEN '7' THEN 'July'
                WHEN '8' THEN 'August'
                WHEN '9' THEN 'September'
                WHEN '10' THEN 'October'
                WHEN '11' THEN 'November'
                WHEN '12' THEN 'December'
            END AS order_month,
            SUM(sales_amount) AS total_sales,
            COUNT(DISTINCT customer_key) AS total_customers,
            SUM(quantity) AS total_quantity
        FROM
            gold.fact_sales
        WHERE
            order_date IS NOT NULL
        GROUP BY
            order_year,
            month_number
        ORDER BY
            order_year,
            month_number
    )
SELECT
    order_year,
    order_month,
    total_sales,
    total_customers,
    total_quantity
FROM
    cte
;


-- The query can be structured differently using DATE_TRUNC() or FORMAT() for different date grouping needs
-- Using DATE_TRUNC()
SELECT
    DATE_TRUNC('month', order_date) AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM
    gold.fact_sales
GROUP BY
    DATE_TRUNC('month', order_date)
ORDER BY
    DATE_TRUNC('month', order_date)
;