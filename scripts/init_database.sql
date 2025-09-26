/*
DATABASE INITIALIZATION:
Script Purpose:
- The purpose of this script is to initialize the data warehouse database for analytics.
- It creates the database, schema, and tables, and populates them with data from CSV files.
Usage:
- First, ensure that you have PostgreSQL installed and running on your machine.
- Update the file paths in the COPY commands to point to the location of your CSV files.
- Execute this script in a PostgreSQL client or command-line interface.
WARNING:
- This script will DROP the existing database named 'data_warehouse_analytics' if it exists.
- Please ensure that you have backed up any important data before running this script.
 */
DROP DATABASE IF EXISTS data_warehouse_analytics
;


CREATE DATABASE data_warehouse_analytics
;


CREATE SCHEMA gold
;


GO
CREATE TABLE
    gold.dim_customers (
        customer_key INT,
        customer_id INT,
        customer_number VARCHAR(50),
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        country VARCHAR(50),
        marital_status VARCHAR(50),
        gender VARCHAR(50),
        birthdate date,
        create_date date
    )
;


GO
CREATE TABLE
    gold.dim_products (
        product_key INT,
        product_id INT,
        product_number VARCHAR(50),
        product_name VARCHAR(50),
        category_id VARCHAR(50),
        category VARCHAR(50),
        subcategory VARCHAR(50),
        maintenance VARCHAR(50),
        COST INT,
        product_line VARCHAR(50),
        start_date date
    )
;


GO
CREATE TABLE
    gold.fact_sales (
        order_number VARCHAR(50),
        product_key INT,
        customer_key INT,
        order_date date,
        shipping_date date,
        due_date date,
        sales_amount INT,
        quantity INT,
        price INT
    )
;


GO
TRUNCATE TABLE gold.dim_customers
;


GO
COPY gold.dim_customers
FROM
    '/Users/justinkakuyo/Desktop/Dev/projects/SQL/sql-data-analytics-project/datasets/csv-files/gold.dim_customers.csv'
WITH
    CSV HEADER
;


GO
TRUNCATE TABLE gold.dim_products
;


GO
COPY gold.dim_products
FROM
    '/Users/justinkakuyo/Desktop/Dev/projects/SQL/sql-data-analytics-project/datasets/csv-files/gold.dim_products.csv'
WITH
    CSV HEADER
;


TRUNCATE TABLE gold.fact_sales
;


GO
COPY gold.fact_sales
FROM
    '/Users/justinkakuyo/Desktop/Dev/projects/SQL/sql-data-analytics-project/datasets/csv-files/gold.fact_sales.csv'
WITH
    CSV HEADER
;
