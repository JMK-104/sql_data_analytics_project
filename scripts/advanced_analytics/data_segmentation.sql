/*
DATA SEGMENTATION ANALYSIS:
Purpose:
- The purpose of this script is to group data into meaningful categories for targeted insights
- It is designed for customer segmentation, product categorization, or regional analysis
- It is useful for identifying patterns and trends within specific segments

SQL Functions Used:
- CASE
- GROUP BY
 */
-- Generate product cost segments and count products in each segment
-- Insights:
-- Identifies how many products fall into different cost categories
WITH
    product_segments AS (
        SELECT
            product_key,
            product_name,
            cost,
            CASE
                WHEN cost < 100 THEN 'Below 100'
                WHEN cost BETWEEN 100 AND 500 THEN '100 - 500'
                WHEN cost BETWEEN 500 AND 1000 THEN '500 - 1000'
                ELSE 'Above 1000'
            END AS segment
        FROM
            gold.dim_products
        GROUP BY
            product_key,
            product_name,
            segment,
            cost
        ORDER BY
            product_name
    )
SELECT
    segment,
    COUNT(product_key) AS total_products
FROM
    product_segments
GROUP BY
    segment
ORDER BY
    total_products DESC
;


-- Generate customer segmentsbased on spending behaviour ('VIP', 'Regular', and 'New')
-- Insights:
-- Identifies customer groups based on their spending patterns and duration of engagement
WITH
    customer_data AS (
        SELECT
            c.customer_key,
            s.order_number AS order_num,
            s.order_date,
            CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
            MIN(s.order_date) OVER (
                PARTITION BY
                    c.customer_key
            ) AS first_order,
            MAX(s.order_date) OVER (
                PARTITION BY
                    c.customer_key
            ) AS last_order,
            SUM(sales_amount) OVER (
                PARTITION BY
                    c.customer_key
            ) AS total_spent,
            EXTRACT(
                YEAR
                FROM
                    AGE (
                        (
                            MAX(s.order_date) OVER (
                                PARTITION BY
                                    c.customer_key
                            )
                        ),
                        (
                            MIN(s.order_date) OVER (
                                PARTITION BY
                                    c.customer_key
                            )
                        )
                    )
            ) * 12 + EXTRACT(
                MONTH
                FROM
                    AGE (
                        (
                            MAX(s.order_date) OVER (
                                PARTITION BY
                                    c.customer_key
                            )
                        ),
                        (
                            MIN(s.order_date) OVER (
                                PARTITION BY
                                    c.customer_key
                            )
                        )
                    )
            ) AS months_diff
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_customers AS c ON c.customer_key = s.customer_key
    ), customer_segment AS (
    SELECT
        customer_key,
        CASE
            WHEN months_diff >= 12
            AND total_spent > 5000 THEN 'VIP'
            WHEN months_diff >= 12
            AND total_spent <= 5000 THEN 'Regular'
            WHEN months_diff < 12 THEN 'New'
            ELSE 'Unidentified'
        END AS segment
    FROM
        customer_data
    GROUP BY
        segment, customer_key
    )
SELECT 
    segment,
    COUNT(customer_key) AS num_customers 
FROM 
    customer_segment
GROUP BY
    segment
;