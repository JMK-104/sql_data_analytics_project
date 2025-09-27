/*
RANKING ANALYSIS:
Purpose:
- The purpose of this script is to rank items (e.g. products, customers) based on their performance or other metrics.
- This helps in identifying top performers or laggards.
SQL Functions and Clauses used:
- Window Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
- GROUP BY, ORDER BY
 */
-- Retrieve the top 5 products generating the highest revenue
-- Insights:
-- This query shows the top 5 products that generate the highest revenue.
-- This information can help in inventory management, marketing strategies, and product development
SELECT
    p.product_number,
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM
    gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p ON p.product_key = s.product_key
GROUP BY
    p.product_number,
    p.product_name
ORDER BY
    total_revenue DESC
LIMIT
    5
;


-- Query can be structured differently using Window Functions, CTE, or Subquery for more complex ranking needs
WITH
    cte AS (
        SELECT
            p.product_number,
            p.product_name,
            SUM(sales_amount) AS total_revenue,
            RANK() OVER (
                ORDER BY
                    SUM(sales_amount) DESC
            ) AS product_rank
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_products AS p ON p.product_key = s.product_key
        GROUP BY
            p.product_number,
            p.product_name
        ORDER BY
            total_revenue DESC
    )
SELECT
    product_number,
    product_name,
    total_revenue
FROM
    cte
WHERE
    product_rank <= 5
;


-- Retrieve the 5 worst-performing products in terms of sales
-- Insights:
-- This query shows the 5 products that generate the lowest revenue
-- This information can help in identifying products that may need to be discontinued or require marketing efforts to boost sales
SELECT
    p.product_number,
    p.product_name,
    SUM(s.sales_amount) AS total_revenue
FROM
    gold.fact_sales AS s
    LEFT JOIN gold.dim_products AS p ON p.product_key = s.product_key
GROUP BY
    p.product_number,
    p.product_name
ORDER BY
    total_revenue ASC
LIMIT
    5
;


-- Retrieve the top 10 customers who have generated the highest revenue
-- Insights:
-- This query shows the top 10 customers that generate the highest revenue
-- This information can help in identifying high-value customers and tailoring marketing efforts accordingly
SELECT
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(s.sales_amount) AS total_revenue
FROM
    gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c ON c.customer_key = s.customer_key
GROUP BY
    c.customer_key,
    customer_name
ORDER BY
    total_revenue DESC
LIMIT
    10
;


-- Retrieve the 3 customers with the fewest orders placed
-- Insights:
-- This query shows the 3 customers with the fewest orders placed
-- This information can help in identifying customers who may need more engagement or incentives to increase their order frequency
SELECT
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(DISTINCT s.order_number) AS total_orders
FROM
    gold.fact_sales AS s
    LEFT JOIN gold.dim_customers AS c ON c.customer_key = s.customer_key
GROUP BY
    c.customer_key,
    customer_name
ORDER BY
    total_orders ASC
LIMIT
    3
;
