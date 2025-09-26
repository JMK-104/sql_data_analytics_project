/*
MEASURE EXPLORATION:

Purpose:
- To calculate aggregated metrics (e.g., totals, averages) for quick insights.
- To identify overall trends or spot anomalies.
SQL Functions Used:
- COUNT(), SUM(), AVG(), UNION ALL

As defined on the dimension_exploration.sql file, a measure is a numeric value that can be aggregated.
 */
-- Find the Total Sales (Measure)
SELECT
    SUM(sales_amount) AS total_sales -- Total sales amount (Measure)
FROM
    gold.fact_sales
;


-- Find the total number of Orders
SELECT
    SUM(quantity) AS total_items_sold -- Total quantity of items sold (Measure)
FROM
    gold.fact_sales
;


-- Find the average selling price
SELECT
    ROUND(AVG(price), 2) AS average_price -- Average Selling Price
FROM
    gold.fact_sales
;


-- Find the total number of orders
SELECT
    COUNT(DISTINCT order_number) AS total_orders -- Total number of unique orders (Measure)
FROM
    gold.fact_sales
;


-- Find the total number of products
SELECT
    COUNT(product_name) AS total_products_listed -- Total number of products listed (Measure)
FROM
    gold.dim_products
;


-- Find the total number of customers
SELECT
    COUNT(DISTINCT customer_key) AS total_customers -- Total number of unique customers
FROM
    gold.dim_customers
;

-- Find the total number of customers that have placed an order
SELECT
    COUNT(DISTINCT customer_key) AS total_customers_placed_order
FROM
    gold.fact_sales
WHERE
    order_date IS NOT NULL
;


-- Find the total number of customers that have NOT placed any orders
SELECT
    COUNT(DISTINCT customer_key) - (
        SELECT
            COUNT(DISTINCT customer_key) AS total_customers_placed_order
        FROM
            gold.fact_sales
        WHERE
            order_date IS NOT NULL
    ) AS customers_with_no_orders
FROM
    gold.fact_sales
;


-- Generate a comprehensive report that shows all key metrics of the business
SELECT
    'Total Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM
    gold.fact_sales
UNION ALL
SELECT
    'Total Quantity',
    SUM(quantity)
FROM
    gold.fact_sales
UNION ALL
SELECT
    'Average Price',
    ROUND(AVG(price), 2)
FROM
    gold.fact_sales
UNION ALL
SELECT
    'Total Orders',
    COUNT(DISTINCT order_number)
FROM
    gold.fact_sales
UNION ALL
SELECT
    'Total Products',
    COUNT(DISTINCT product_name)
FROM
    gold.dim_products
UNION ALL
SELECT
    'Total Customers',
    COUNT(customer_key)
FROM
    gold.dim_customers
;
