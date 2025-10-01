/*
PRODUCT REPORT:
Purpose:
- This report consolidates key product metrics and behaviours

Highlights:
- This report gather essential fields such as product name, category, subcategory, and cost
- Segments products by revenue to identify high performers, mid-range, or low performers
- This report aggregates product-level metrics
1. total orders
2. total sales
3. total quantity sold
4. total customers (unique)
5. lifespan (in months)
- This report calculates valuble KPIs:
1. recency (months since last sale)
2. average order revenue (AOR)
3. average monthly revenue
 */
--========================================
-- Step 1: Base Query
--========================================
CREATE OR REPLACE VIEW
    gold.report_products AS
WITH
    base_query AS (
        SELECT
            s.order_number,
            s.order_date,
            s.customer_key,
            s.sales_amount,
            s.quantity,
            p.product_key,
            p.product_name,
            p.category,
            p.subcategory,
            p.cost,
            MIN(s.order_date) OVER (
                PARTITION BY
                    p.product_key
            ) AS first_sale,
            MAX(s.order_date) OVER (
                PARTITION BY
                    p.product_key
            ) AS last_sale
        FROM
            gold.fact_sales AS s
            LEFT JOIN gold.dim_products AS p ON p.product_key = s.product_key
        WHERE
            s.order_date IS NOT NULL
    )
    --========================================
    -- Step 2: Aggregation CTE
    --========================================
,
    product_aggregation AS (
        SELECT
            product_key,
            product_name,
            category,
            subcategory,
            COST,
            first_sale,
            last_sale,
            (
                EXTRACT(
                    YEAR
                    FROM
                        age (last_sale, first_sale)
                ) * 12
            ) + (
                EXTRACT(
                    MONTH
                    FROM
                        age (last_sale, first_sale)
                )
            ) AS lifespan_months,
            COUNT(DISTINCT order_number) AS total_orders,
            SUM(sales_amount) AS total_sales,
            SUM(quantity) AS total_quantity_sold,
            COUNT(DISTINCT customer_key) AS total_customers,
            (ROUND(AVG(sales_amount), 2)) / NULLIF(quantity, 0) AS avg_selling_price
        FROM
            base_query
        GROUP BY
            product_key,
            product_name,
            category,
            subcategory,
            COST,
            first_sale,
            last_sale,
            lifespan_months,
            quantity
    )
    --========================================
    -- Step 3: Final Result Query
    --========================================
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    COST,
    last_sale,
    (
        EXTRACT(
            YEAR
            FROM
                age (CURRENT_DATE, last_sale)
        ) * 12
    ) + (
        EXTRACT(
            MONTH
            FROM
                age (CURRENT_DATE, last_sale)
        )
    ) AS recency_in_months,
    CASE
        WHEN total_sales >= 100000 THEN 'High-Performer'
        WHEN total_sales >= 50000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS revenue_segment,
    lifespan_months AS lifespan,
    total_orders,
    total_sales,
    total_quantity_sold,
    total_customers,
    ROUND(avg_selling_price, 2) AS avg_selling_price,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE CAST(total_sales / total_orders AS INT)
    END AS avg_order_revenue,
    CASE
        WHEN lifespan_months = 0 THEN total_sales
        ELSE CAST(total_sales / lifespan_months AS INT)
    END AS avg_monthly_revenue
FROM
    product_aggregation
;