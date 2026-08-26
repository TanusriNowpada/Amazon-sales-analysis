-- Amazon Sales Analysis
-- Business and Sales Analysis

USE amazon_sales;


-- 1. Overall business KPIs

-- Total sales
SELECT SUM(Amount) AS total_sales
FROM amazon_sale_cleaned;

-- Total orders
SELECT COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned;

-- Total quantity sold
SELECT
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned;

-- Average order value
SELECT
    ROUND(
        SUM(Amount) / COUNT(DISTINCT `Order ID`),2
    ) AS average_order_value
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL;


-- 2. Sales by category

SELECT
    Category,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY Category
ORDER BY total_sales DESC;

-- 4. Sales by state

SELECT
    `ship-state` AS state,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY `ship-state`
ORDER BY total_sales DESC;


-- 5. Top 10 states by sales

SELECT
    `ship-state` AS state,
    SUM(Amount) AS total_sales
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY `ship-state`
ORDER BY total_sales DESC
LIMIT 10;


-- 6. Sales by city

SELECT
    `ship-city` AS city,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY `ship-city`
ORDER BY total_sales DESC
LIMIT 20;


-- 7. Monthly sales trend

SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY month;


-- 8. Monthly sales with month name

SELECT
    YEAR(Date) AS year,
    MONTH(Date) AS month_number,
    MONTHNAME(Date) AS month_name,
    SUM(Amount) AS total_sales
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY
    YEAR(Date),
    MONTH(Date),
    MONTHNAME(Date)
ORDER BY
    year,
    month_number;


-- 9. Sales by fulfilment

SELECT
    Fulfilment,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY Fulfilment
ORDER BY total_sales DESC;


-- 10. Sales by sales channel

SELECT
    `Sales Channel`,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY `Sales Channel`
ORDER BY total_sales DESC;


-- 11. Sales by order status

SELECT
    Status,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
GROUP BY Status
ORDER BY total_orders DESC;


-- 12. Order status distribution

SELECT
    Status,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(
        COUNT(DISTINCT `Order ID`) * 100.0 /
        (SELECT COUNT(DISTINCT `Order ID`)
         FROM amazon_sale_cleaned),
        2
    ) AS order_percentage
FROM amazon_sale_cleaned
GROUP BY Status
ORDER BY total_orders DESC;


-- 13. Courier status analysis

SELECT
    `Courier Status`,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
GROUP BY `Courier Status`
ORDER BY total_orders DESC;


-- 14. Sales by ship service level

SELECT
    `ship-service-level`,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY `ship-service-level`
ORDER BY total_sales DESC;


-- 15. B2B vs non-B2B

SELECT
    B2B,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Amount) AS total_sales,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY B2B
ORDER BY total_sales DESC;


-- 16. Top 10 products by sales

SELECT
    SKU,
    SUM(Amount) AS total_sales,
    SUM(Qty) AS total_quantity,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY SKU
ORDER BY total_sales DESC
LIMIT 10;


-- 17. Top 10 products by quantity

SELECT
    SKU,
    SUM(Qty) AS total_quantity,
    SUM(Amount) AS total_sales
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY SKU
ORDER BY total_quantity DESC
LIMIT 10;


-- 18. Sales by size

SELECT
    Size,
    SUM(Amount) AS total_sales,
    SUM(Qty) AS total_quantity,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY Size
ORDER BY total_sales DESC;


-- 19. Sales by fulfilment and category

SELECT
    Fulfilment,
    Category,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY
    Fulfilment,
    Category
ORDER BY total_sales DESC;


-- 20. Cancelled orders

SELECT
    COUNT(DISTINCT `Order ID`) AS cancelled_orders
FROM amazon_sale_cleaned
WHERE LOWER(Status) = 'cancelled';


-- 21. Cancellation rate

SELECT
    ROUND(
        COUNT(DISTINCT CASE
            WHEN LOWER(Status) = 'cancelled'
            THEN `Order ID`
        END) * 100.0
        / COUNT(DISTINCT `Order ID`),
        2
    ) AS cancellation_rate_percentage
FROM amazon_sale_cleaned;


-- 22. Sales by year

SELECT
    YEAR(Date) AS year,
    SUM(Amount) AS total_sales,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    SUM(Qty) AS total_quantity
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY YEAR(Date)
ORDER BY year;


-- 23. Sales by category and month

SELECT
    DATE_FORMAT(Date, '%Y-%m') AS month,
    Category,
    SUM(Amount) AS total_sales
FROM amazon_sale_cleaned
WHERE Amount IS NOT NULL
GROUP BY
    DATE_FORMAT(Date, '%Y-%m'),
    Category
ORDER BY
    month,
    total_sales DESC;