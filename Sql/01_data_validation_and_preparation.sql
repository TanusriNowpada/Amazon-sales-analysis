-- Amazon Sales Analysis
-- Data Validation and Preparation

USE amazon_sales;


-- 1. Initial data validation

-- Check the total number of imported rows
SELECT COUNT(*) AS total_rows
FROM amazon_sale_cleaned;

-- Check the table structure and data types
DESCRIBE amazon_sale_cleaned;

-- Check index range and uniqueness
SELECT
    MIN(`index`) AS min_index,
    MAX(`index`) AS max_index,
    COUNT(DISTINCT `index`) AS unique_indexes
FROM amazon_sale_cleaned;


-- 2. Index cleanup and validation

-- Rename the incorrectly encoded first column
-- Original: ï»¿index
-- Correct: index
ALTER TABLE amazon_sale_cleaned
RENAME COLUMN `ï»¿index` TO `index`;

-- Check for duplicate index values
SELECT
    `index`,
    COUNT(*) AS duplicate_count
FROM amazon_sale_cleaned
GROUP BY `index`
HAVING COUNT(*) > 1;


-- 3. Amount validation and preparation

-- Check missing Amount values before conversion
SELECT
    COUNT(*) AS total_rows,
    COUNT(Amount) AS non_blank_amounts,
    SUM(Amount = '') AS blank_amounts
FROM amazon_sale_cleaned;

-- Check whether non-blank Amount values are numeric
SELECT Amount
FROM amazon_sale_cleaned
WHERE Amount <> ''
AND Amount NOT REGEXP '^[0-9]+(\.[0-9]+)?$'
LIMIT 10;

-- Convert empty Amount values to NULL
UPDATE amazon_sale_cleaned
SET Amount = NULL
WHERE Amount = '';

-- Convert Amount from TEXT to DECIMAL
ALTER TABLE amazon_sale_cleaned
MODIFY COLUMN Amount DECIMAL(10,2);

-- Validate Amount after conversion
SELECT
    COUNT(*) AS total_rows,
    COUNT(Amount) AS non_null_amounts,
    SUM(Amount IS NULL) AS null_amounts
FROM amazon_sale_cleaned;


-- 4. Date validation and preparation

-- Check the Date values
SELECT Date
FROM amazon_sale_cleaned
WHERE Date IS NOT NULL
LIMIT 10;

-- Check for invalid Date values
SELECT Date
FROM amazon_sale_cleaned
WHERE Date IS NOT NULL
AND Date <> ''
AND STR_TO_DATE(Date, '%d-%b-%y') IS NULL
LIMIT 10;

-- Convert text dates into DATE-compatible values
UPDATE amazon_sale_cleaned
SET Date = DATE_FORMAT(
    STR_TO_DATE(Date, '%d-%b-%y'),
    '%Y-%m-%d'
)
WHERE Date IS NOT NULL
AND Date <> '';

-- Convert Date column from TEXT to DATE
ALTER TABLE amazon_sale_cleaned
MODIFY COLUMN Date DATE;


-- 5. Order-level validation

-- Compare total rows with unique orders
SELECT
    COUNT(DISTINCT `Order ID`) AS unique_orders,
    COUNT(*) AS total_rows
FROM amazon_sale_cleaned;

-- Count orders that appear on multiple rows
SELECT
    COUNT(*) AS orders_with_multiple_rows
FROM (
    SELECT `Order ID`
    FROM amazon_sale_cleaned
    GROUP BY `Order ID`
    HAVING COUNT(*) > 1
) AS repeated_orders;


-- 6. Final table structure

-- Verify the final data types
DESCRIBE amazon_sale_cleaned;