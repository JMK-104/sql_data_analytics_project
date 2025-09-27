/*
DATABASE EXPLORATION:
Purpose:
- Explore the structure of the database, including the list of tables and their schemas.
- Inspect the columns and metadata for specific tables.
Tables Used:
- INFORMATION_SCHEMA.TABLES
- INFORMATION_SCHEMA.COLUMNS
 */
-- Explore Table Objects in the Database
-- This query retrieves all tables in the current database along with their catalog, schema, name, and type.
SELECT
    table_catalog,
    table_schema,
    table_name,
    table_type
FROM
    information_schema.tables
WHERE
    table_schema NOT IN ('pg_catalog', 'information_schema') -- Exclude System tables
;


-- Explore Column Objects in the Database
-- This query retrieves all columns in the current database along with their catalog, schema, table name, column name, data type, and nullability.
SELECT
    *
FROM
    information_schema.columns
WHERE
    table_schema NOT IN ('pg_catalog', 'information_schema') -- Exclude System information
;


-- Explore columns for dim_customers
SELECT
    *
FROM
    information_schema.columns
WHERE
    table_name = 'dim_customers'
;


-- Explore columns for dim_products table
SELECT
    *
FROM
    information_schema.columns
WHERE
    table_name = 'dim_products'
;


-- Explore columns for fact_sales table
SELECT
    *
FROM
    information_schema.columns
WHERE
    table_name = 'fact_sales'
;
