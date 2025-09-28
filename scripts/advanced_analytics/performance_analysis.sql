/*
PERFORMANCE ANALYSIS:
Purpose:
- The purpose of this scipt is to measure the performance of products, customers, or regions over time
- It is designed for benchmarking and identifying high-performing entities
- It tracks yearly trends and growth
SQL Functions Used:
- LAG(), AVG(), CASE
 */
-- Generate a report that shows the yearly performance of products by comparing their sales to both the average sales performance of the products
-- and the previous year's sales and average sales performance of the product
WITH
    cte AS (
        SELECT
            p.product_name AS product,
            DATE_PART('year', s.order_date) AS order_year,
            SUM(s.sales_amount) AS total_sales,
            CAST(
                AVG(SUM(s.sales_amount)) OVER (
                    PARTITION BY
                        p.product_name
                ) AS INT
            ) AS avg_sales_per_product
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_products AS p ON s.product_key = p.product_key
        WHERE
            s.order_date IS NOT NULL
        GROUP BY
            p.product_name,
            order_year
        ORDER BY
            p.product_name,
            order_year
    )
SELECT
    product,
    order_year,
    total_sales,
    avg_sales_per_product,
    CASE
        WHEN total_sales - avg_sales_per_product > 0 THEN 'Above Average'
        WHEN total_sales - avg_sales_per_product < 0 THEN 'Below Average'
        ELSE 'Average'
    END AS performance_vs_avg,
    CASE
        WHEN total_sales > LAG(total_sales) OVER (
            PARTITION BY
                product
        ) THEN 'Increase'
        WHEN total_sales < LAG(total_sales) OVER (
            PARTITION BY
                product
        ) THEN 'Decrease'
        WHEN LAG(total_sales) OVER (
            PARTITION BY
                product
        ) IS NULL THEN 'N/A'
        ELSE 'No Change'
    END AS performance_vs_previous_year
FROM
    cte
;