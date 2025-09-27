/*
DIMENSION EXPLORATION:
Purpose: Explore the structure of the dimension tables to identify dimensions and measures.

Dimension Definition:
- In data analytics, a dimension is a value that categorizes and describes data points, providing context for analysis.
- A good rule of thumb to identify dimensions is to ask two questions: "Is the value numeric?" and "Can I aggregate this value?"
- If the answer to both is yes, then the value is likely a measure, not a dimension.
- If the answer to either is no, then the value is likely a dimension.
 */
-- Explore each table and rerieve a list of unique values for each dimension
--==============================================================================
-- gold.dim_customers
--==============================================================================
-- Explore a sample of the data
SELECT
    customer_key, -- Numeric: Yes, Aggregate: No (Dimension)
    customer_id, -- Numeric: Yes, Aggregate: No (Dimension)
    customer_number, -- Numeric: No, Aggregate: No (Dimension)
    first_name, -- Numeric: No, Aggregate: No (Dimension)
    last_name, -- Numeric: No, Aggregate: No (Dimension)
    country, -- Numeric: No, Aggregate: No (Dimension)
    marital_status, -- Numeric: No, Aggregate: No (Dimension)
    gender, -- Numeric: No, Aggregate: No (Dimension)
    birthdate, -- Numeric: No, Aggregate: No (Dimension) [Age could be a measure]
    create_date -- Numeric: No, Aggregate: No (Dimension)
FROM
    gold.dim_customers
LIMIT
    10
;


--==============================================================================
-- gold.dim_products
--==============================================================================
-- Explore a sample of the data
SELECT
    product_key, -- Numeric: Yes, Aggregate: No (Dimension)
    product_id, -- Numeric: Yes, Aggregate: No (Dimension)
    product_number, -- Numeric: No, Aggregate: No (Dimension)
    product_name, -- Numeric: No, Aggregate: No (Dimension)
    category_id, -- Numeric: No, Aggregate: No (Dimension)
    category, -- Numeric: No, Aggregate: No (Dimension)
    subcategory, -- Numeric: No, Aggregate: No (Dimension)
    maintenance, -- Numeric: No, Aggregate: No (Dimension)
    COST, -- Numeric: Yes, Aggregate: Yes (Measure)
    product_line, -- Numeric: No, Aggregate: No (Dimension)
    start_date -- Numeric: No, Aggregate: No (Dimension)
FROM
    gold.dim_products
LIMIT
    10
;


--==============================================================================
-- gold.fact_sales
--==============================================================================
-- Explore a sample of the data
SELECT
    order_number, -- Numeric: No, Aggregate: No (Dimension)
    product_key, -- Numeric: Yes, Aggregate: No (Dimension)
    customer_key, -- Numeric: Yes, Aggregate: No (Dimension)
    order_date, -- Numeric: No, Aggregate: No (Dimension)
    shipping_date, -- Numeric: No, Aggregate: No (Dimension)
    due_date, -- Numeric: No, Aggregate: No (Dimension)
    sales_amount, -- Numeric: Yes, Aggregate: Yes (Measure)
    quantity, -- Numeric: Yes, Aggregate: Yes (Measure)
    price -- Numeric: Yes, Aggregate: Yes (Measure)
FROM
    gold.fact_sales
LIMIT
    10
;


/*
DIMENSIONS AND MEASURES FOR EACH TABLE:

gold.dim_customers
- Dimensions:
- customer_key
- customer_id
- customer_number
- first_name
- last_name
- country
- marital_status
- gender
- birthdate
- create_date
- Measures:
- None

gold.dim_products
- Dimensions:
- product_key
- product_id
- product_number
- product_name
- category_id
- category
- subcategory
- maintenance
- product_line
- start_date
- Measures:
- COST

gold.fact_sales
- Dimensions:
- order_number
- product_key
- customer_key
- order_date
- shipping_date
- due_date
- Measures:
- sales_amount
- quantity
- price
 */
--==============================================================================
-- Distinct Values
--==============================================================================
-- gold.dim_customers
SELECT DISTINCT
    country
FROM
    gold.dim_customers
;


SELECT DISTINCT
    marital_status
FROM
    gold.dim_customers
;


--==============================================================================
-- gold.dim_products
--==============================================================================
SELECT DISTINCT
    category
FROM
    gold.dim_products
;


SELECT DISTINCT
    subcategory
FROM
    gold.dim_products
;


SELECT DISTINCT
    product_line
FROM
    gold.dim_products
;


--==============================================================================
-- gold.fact_sales
--==============================================================================
SELECT DISTINCT
    order_date
FROM
    gold.fact_sales
;


SELECT DISTINCT
    shipping_date
FROM
    gold.fact_sales
;