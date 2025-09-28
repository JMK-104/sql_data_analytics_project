/*
CUMULATIVE ANALYSIS:
Purpose:
- The purpose of this script is to calulate running totals or moving averages for key metrics
- It is also designed to track performance over time cumulatively
- This is useful for growth analysis or identifying long-term trends
SQL Functions used:
- Window Functions: SUM() OVER(), AVG() OVER()
 */
-- Generate a report that show the total sales per year and the running total of sales over time as well as the moving average of the average price
-- Insights:
-- The running total of sales helps to understand the overall growth trend over the years
-- The moving average of the average price smooths out short-term fluctuations and highlights longer-termn trends in pricing
WITH
    cte AS (
        SELECT
            CAST(DATE_TRUNC('year', order_date) AS date) AS order_date,
            SUM(sales_amount) AS total_sales,
            AVG(price) AS avg_price
        FROM
            gold.fact_sales
        WHERE
            order_date IS NOT NULL
        GROUP BY
            CAST(DATE_TRUNC('year', order_date) AS date)
    )
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY
            order_date
    ) AS running_total_sales,
    ROUND(
        AVG(avg_price) OVER (
            ORDER BY
                order_date
        ),
        2
    ) AS moving_average_price
FROM
    cte
ORDER BY
    order_date
;


-- The same query can be written using subquery instead of CTE
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        ORDER BY
            order_date
    ) AS running_total_sales,
    ROUND(
        AVG(avg_price) OVER (
            ORDER BY
                order_date
        ),
        2
    ) AS moving_average_price
FROM
    (
        SELECT
            CAST(DATE_TRUNC('year', order_date) AS date) AS order_date,
            SUM(sales_amount) AS total_sales,
            AVG(price) AS avg_price
        FROM
            gold.fact_sales
        WHERE
            order_date IS NOT NULL
        GROUP BY
            CAST(DATE_TRUNC('year', order_date) AS date)
    ) t
;


-- This cumulative analysis can be broken down further by month
WITH
    cte AS (
        SELECT
            CAST(DATE_TRUNC('month', order_date) AS date) AS order_date,
            SUM(sales_amount) AS total_sales,
            AVG(price) AS avg_price
        FROM
            gold.fact_sales
        WHERE
            order_date IS NOT NULL
        GROUP BY
            CAST(DATE_TRUNC('month', order_date) AS date)
    )
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (
        PARTITION BY
            DATE_PART('year', order_date)
        ORDER BY
            order_date
    ) AS monthly_running_total_per_year,
    ROUND(
        AVG(avg_price) OVER (
            ORDER BY
                order_date
        ),
        2
    ) AS moving_average_price
FROM
    cte
ORDER BY
    order_date
;