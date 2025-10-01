/*
CUSTOMER REPORT:
Purpose:
- The purpose of this script is to consolidate key customer metrics and behaviours

Highlights:
- This report gathers essential fields, such as names, ages, and transaction details
- This report also segments customers into categories ('VIP', 'Regular', and 'New'), and age groups
- This report aggregates customer-level metrics
1. total orders
2. total sales
3. total quantity purchased
4. total products
5. lifespan (in months)
- This report calculates valuble KPIs:
1. recency (months since last order)
2. average order value
3. average monthly spending
 */

--========================================
-- Step 1: Base Query
--========================================
CREATE OR REPLACE VIEW gold.report_customers AS
with base_query as (
    SELECT
        s.order_number,
        s.product_key,
        s.order_date,
        s.order_number AS order_num,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        EXTRACT(
            YEAR
            FROM
                (age (CURRENT_DATE, c.birthdate))
        ) AS age,
        min(order_date) over(partition by c.customer_key) as first_order,
        max(order_date) over(partition by c.customer_key) as last_order
    FROM
        gold.fact_sales AS s
        LEFT JOIN gold.dim_customers AS c ON s.customer_key = c.customer_key
    WHERE
        s.order_date IS NOT NULL
)
--========================================
-- Step 2: Aggregation CTE
--========================================
, customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        customer_name,
        age,
        count(distinct order_number) as total_orders,
        sum(sales_amount) as total_sales,
        sum(quantity) as total_quantity,
        count(distinct product_key) as products_ordered,
        last_order,
        (extract(year from age(last_order, first_order)) * 12) + (extract(month from age(last_order, first_order))) as lifespan
    FROM base_query
    group by 1, 2, 3, 4, 9, 10
)
--========================================
-- Step 3: Final Result Query
--========================================
SELECT  
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE 
        WHEN age < 20 then 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20 - 29'
        WHEN age BETWEEN 30 AND 39 THEN '30 - 39'
        WHEN age BETWEEN 40 AND 49 THEN '40 - 49'
        WHEN age BETWEEN 50 AND 59 THEN '50 - 59'
        ELSE '60 and Above'
    END AS age_group,
    CASE
        WHEN lifespan >= 12
        AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12
        AND total_sales <= 5000 THEN 'Regular'
        WHEN lifespan < 12 THEN 'New'
        ELSE 'Unidentified'
    END AS customer_segment,
    last_order,
    ((extract(year from age(current_date, last_order))) * 12) + extract(month from age(current_date, last_order)) as recency,
    total_orders,
    total_sales,
    total_quantity, products_ordered,
    lifespan,
    CASE
        WHEN total_orders != 0 THEN total_sales / total_orders
        WHEN total_orders = 0 THEN 0
    END AS avg_order_value,  -- How much product value is each customer ordering
    CASE
        WHEN lifespan != 0 THEN cast(total_sales / lifespan as int)
        WHEN lifespan = 0 THEN total_sales
    END AS avg_monthly_spent
from customer_aggregation
;
