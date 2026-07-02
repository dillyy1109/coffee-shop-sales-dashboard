-- 
-- Data Exploration 
--- 

-- Check the data
USE CoffeeShopSales;
SELECT TOP 10 *
FROM coffee_shop_sales;

-- Check row count
SELECT COUNT(*) AS total_rows
FROM coffee_shop_sales;

-- Find unit_price values that cannot convert to numbers
SELECT DISTINCT unit_price
FROM coffee_shop_sales
WHERE TRY_CAST(unit_price AS DECIMAL(10,2)) IS NULL;

UPDATE coffee_shop_sales
SET unit_price_num =
    TRY_CAST(REPLACE(unit_price, ',', '.') AS DECIMAL(10,2));

SELECT TOP 10
    unit_price,
    unit_price_num
FROM coffee_shop_sales;



--
-- Understand the data
--

-- Number of stores
SELECT DISTINCT store_location
FROM coffee_shop_sales;
-- Product categories
SELECT DISTINCT product_category
FROM coffee_shop_sales;
-- Product types
SELECT DISTINCT product_type
FROM coffee_shop_sales
ORDER BY product_type;
-- Date range
SELECT
    MIN(transaction_date) AS first_day,
    MAX(transaction_date) AS last_day
FROM coffee_shop_sales;

--
-- Business KPI
--

-- Total Revenue
SELECT
    SUM(unit_price_num * transaction_qty) AS total_revenue
FROM coffee_shop_sales;
-- Total Transactions
SELECT
    COUNT(*) AS total_transactions
FROM coffee_shop_sales;
-- Total Items Sold
SELECT
    SUM(transaction_qty) AS total_items_sold
FROM coffee_shop_sales;
-- Average Order Value
SELECT
    AVG(unit_price_num * transaction_qty) AS average_order_value
FROM coffee_shop_sales;

--
-- Store Performance 
--
-- Revenue by Store
SELECT
    store_location,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
GROUP BY store_location
ORDER BY revenue DESC;

-- Top 10 Products
SELECT TOP 10
    product_detail,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
GROUP BY product_detail
ORDER BY revenue DESC;

-- Revenue by Category
SELECT
    product_category,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY revenue DESC;


--
-- Time Analysis
--

-- Revenue by month
SELECT
    MONTH(TRY_CONVERT(DATE, transaction_date, 1)) AS month_number,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
WHERE TRY_CONVERT(DATE, transaction_date, 1) IS NOT NULL
GROUP BY MONTH(TRY_CONVERT(DATE, transaction_date, 1))
ORDER BY month_number;

-- Revenue by day of week
SELECT
    DATENAME(WEEKDAY, TRY_CONVERT(DATE, transaction_date, 1)) AS day_of_week,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
WHERE TRY_CONVERT(DATE, transaction_date, 1) IS NOT NULL
GROUP BY DATENAME(WEEKDAY, TRY_CONVERT(DATE, transaction_date, 1))
ORDER BY revenue DESC;

-- Revenue by hour
SELECT
    DATEPART(HOUR, CAST(transaction_time AS TIME)) AS hour_of_day,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
GROUP BY DATEPART(HOUR, CAST(transaction_time AS TIME))
ORDER BY hour_of_day;

-- Transactions by hour
SELECT
    DATEPART(HOUR, CAST(transaction_time AS TIME)) AS hour_of_day,
    COUNT(*) AS total_transactions
FROM coffee_shop_sales
GROUP BY DATEPART(HOUR, CAST(transaction_time AS TIME))
ORDER BY hour_of_day;

--
-- Advanced Product Analysis
--

-- Top categories by revenue and quantity sold
SELECT
    product_category,
    SUM(transaction_qty) AS total_quantity_sold,
    SUM(unit_price_num * transaction_qty) AS revenue
FROM coffee_shop_sales
GROUP BY product_category
ORDER BY revenue DESC;

--
CREATE OR ALTER VIEW vw_coffee_shop_sales_clean AS
SELECT
    transaction_id,
    TRY_CONVERT(DATE, transaction_date, 1) AS transaction_date,
    TRY_CONVERT(TIME, transaction_time) AS transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price_num AS unit_price,
    product_category,
    product_type,
    product_detail,
    unit_price_num * transaction_qty AS revenue,
    MONTH(TRY_CONVERT(DATE, transaction_date, 1)) AS month_number,
    DATENAME(WEEKDAY, TRY_CONVERT(DATE, transaction_date, 1)) AS day_of_week,
    DATEPART(HOUR, TRY_CONVERT(TIME, transaction_time)) AS hour_of_day
FROM coffee_shop_sales
WHERE TRY_CONVERT(DATE, transaction_date, 1) IS NOT NULL;

SELECT TOP 10 *
FROM vw_coffee_shop_sales_clean;

SELECT *
FROM vw_coffee_shop_sales_clean;


