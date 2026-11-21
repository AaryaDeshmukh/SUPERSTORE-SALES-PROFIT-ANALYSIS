CREATE DATABASE superstore_db;
USE superstore_db;

CREATE TABLE superstore_full LIKE superstore;

CREATE TABLE superstore (
    `Row ID` INT PRIMARY KEY,
    `Order ID` VARCHAR(30),
    `Order Date` VARCHAR(20),
    `Ship Date` VARCHAR(20),
    `Ship Mode` VARCHAR(30),
    `Customer ID` VARCHAR(30),
    `Customer Name` VARCHAR(100),
    `Segment` VARCHAR(30),
    `Country` VARCHAR(50),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal Code` INT,
    `Region` VARCHAR(30),
    `Product ID` VARCHAR(30),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(50),
    `Product Name` VARCHAR(255),
    `Sales` DECIMAL(12,2),
    `Quantity` INT,
    `Discount` DECIMAL(5,2),
    `Profit` DECIMAL(12,4)
);

SHOW TABLES;
DESCRIBE superstore;

USE superstore_db;

SELECT COUNT(*) AS total_records
FROM superstore;

SELECT *
FROM superstore
LIMIT 10;

SELECT
    COUNT(*) AS total_records,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore;

#1.	Calculate total sales and total profit.
SELECT
    COUNT(*) AS total_records,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    SUM(Quantity) AS total_quantity
FROM superstore;
#2.	Find the top 10 best-selling products.
SELECT
    `Product Name`,
    SUM(Quantity) AS total_quantity,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Product Name`
ORDER BY total_quantity DESC
LIMIT 10;
#3.	Identify the least profitable products.
SELECT
    `Product Name`,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Product Name`
ORDER BY total_profit ASC
LIMIT 10;
#4.	Calculate sales by region.
SELECT
    Region,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;
#5.	Calculate profit by category.
SELECT
    Category,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Category
ORDER BY total_profit DESC;
#6.	Find average discount by category.
SELECT
    Category,
    AVG(Discount) AS average_discount
FROM superstore
GROUP BY Category;
#7.	Identify the top customers by sales.
SELECT
    `Customer Name`,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;

#8.	Find monthly sales trends.
SELECT
    YEAR(STR_TO_DATE(REPLACE(`Order Date`, '-', '/'), '%m/%d/%Y')) AS year,
    MONTH(STR_TO_DATE(REPLACE(`Order Date`, '-', '/'), '%m/%d/%Y')) AS month_number,
    MONTHNAME(STR_TO_DATE(REPLACE(`Order Date`, '-', '/'), '%m/%d/%Y')) AS month_name,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY year, month_number, month_name
ORDER BY year, month_number;
#9.	Rank products based on profit.
SELECT
    `Product Name`,
    SUM(Profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(Profit) DESC) AS product_rank
FROM superstore
GROUP BY `Product Name`;
#Find the most preferred shipping mode
SELECT
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore
GROUP BY `Ship Mode`
ORDER BY total_orders DESC;

-- 11. Sales by Customer Segment
SELECT
    Segment,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;

-- 12. Profit by Region
SELECT
    Region,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY Region
ORDER BY total_profit DESC;

-- 13. Sales by Sub-Category
SELECT
    `Sub-Category`,
    SUM(Sales) AS total_sales
FROM superstore
GROUP BY `Sub-Category`
ORDER BY total_sales DESC;

-- 14. Profit by Sub-Category
SELECT
    `Sub-Category`,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY total_profit DESC;

-- 15. Calculate Profit Margin
SELECT
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit,
    (SUM(Profit) / SUM(Sales)) * 100 AS profit_margin
FROM superstore;

-- 16. Find Total Orders
SELECT
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM superstore;

-- 17. Find Sales by Shipping Mode
SELECT
    `Ship Mode`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Ship Mode`;

-- 18. Find Products with Negative Profit
SELECT
    `Product Name`,
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore
GROUP BY `Product Name`
HAVING SUM(Profit) < 0
ORDER BY total_profit ASC;

SELECT COUNT(*) AS total_records
FROM superstore;

SELECT
    SUM(Sales) AS total_sales,
    SUM(Profit) AS total_profit
FROM superstore;

USE superstore_db;

SELECT
    COUNT(*) AS total_records,
    MIN(`Row ID`) AS minimum_row_id,
    MAX(`Row ID`) AS maximum_row_id,
    COUNT(DISTINCT `Row ID`) AS unique_row_ids
FROM superstore;

WITH RECURSIVE numbers AS
(
    SELECT 1 AS id

    UNION ALL

    SELECT id + 1
    FROM numbers
    WHERE id < 9994
)
SELECT numbers.id AS missing_row_id
FROM numbers
LEFT JOIN superstore
ON numbers.id = superstore.`Row ID`
WHERE superstore.`Row ID` IS NULL;

CREATE TABLE superstore_full LIKE superstore;

USE superstore_db;

-- Insert only the 300 missing rows from superstore_full into superstore
INSERT INTO superstore
SELECT * FROM superstore_full
WHERE `Row ID` NOT IN (SELECT `Row ID` FROM superstore);

SELECT COUNT(*) AS total_records FROM superstore;

DESCRIBE superstore;

SELECT 
    COUNT(*) AS total_records,
    MIN(`Row ID`) AS min_id,
    MAX(`Row ID`) AS max_id,
    COUNT(DISTINCT `Row ID`) AS unique_ids
FROM superstore;

DROP TABLE IF EXISTS superstore_full;