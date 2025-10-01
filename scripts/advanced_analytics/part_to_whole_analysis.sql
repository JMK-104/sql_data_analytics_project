/*
PART-TO-WHOLE ANALYSIS:
Purpose:
- The purpose of this script is to compare performance or metrics across dimensions or time periods
- It is designed to evaluate differences between categories
- It is useful for A/B testing or regional comparisons

SQL Functions Used:
- SUM(), AVG()
- Window Functions: SUM() OVER()
 */
-- Generate a report that shows which categories contribute the most to overall sales
-- Insights:
-- This query helps to identify the top performing categories in terms of sales contribution
-- It provides a clear view of how each category performs relative to the total sales
WITH
    category_sales AS (
        SELECT
            p.category,
            SUM(s.sales_amount) AS category_sales
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_products AS p ON p.product_key = s.product_key
        GROUP BY
            p.category
    )
SELECT
    category,
    category_sales,
    SUM(category_sales) OVER () AS overall_sales,
    CONCAT(
        (
            ROUND(
                (100 * category_sales) / SUM(category_sales) OVER (),
                2
            )
        ),
        '%'
    ) AS category_contribution
FROM
    category_sales
;


-- Generate a report that shows the sales performance of countries by comparing their sales to the total sales performance of all regions
-- Insights:
-- This query helps to identify the top performing countries in terms of sales contribution
-- It provides a clear view of how each country performs relative to the total sales
-- This query shows that most of the sales revenue comes from the United States, followed by Australia, then the United Kingdom
WITH
    country_performance AS (
        SELECT
            c.country,
            SUM(s.sales_amount) AS country_sales
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_customers AS c ON c.customer_key = s.customer_key
        WHERE
            c.country != 'n/a'
        GROUP BY
            c.country
    )
SELECT
    country,
    country_sales,
    (
        SELECT
            SUM(sales_amount)
        FROM
            gold.fact_sales
    ) AS overall_sales,
    CONCAT(
        (
            ROUND(
                (100 * country_sales) / SUM(country_sales) OVER (),
                2
            )
        ),
        '%'
    ) AS country_contribution
FROM
    country_performance
ORDER BY
    country_sales DESC
;