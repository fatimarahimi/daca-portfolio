-- ==============================================
-- UrbanStyle Data Cleaning Script
-- Domain: Products
-- Week: 2
-- Author: Fatima
-- Purpose: Detect and document data-quality issues
--          in the products table ahead of the board meeting.
-- Process: Test copy -> Diagnose -> Document -> Report
--          (No destructive changes made to production `products`)
-- ==============================================

-- STEP 1: Create a safe test copy (never work on the live table)
CREATE TABLE products_test AS SELECT * FROM products;

-- Row count check
SELECT COUNT(*) AS row_count FROM products_test;
-- Result: 362 rows


-- STEP 2: Find duplicate product names
SELECT product_name, COUNT(*) AS copy_count
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY copy_count DESC;
-- Result: 12 duplicate product names found, each appearing exactly
-- twice (24 rows total affected)


-- STEP 3: Find NULL values in critical fields
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_name,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_category,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_retail_price,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_cost_price
FROM products_test;
-- Result: 0 missing in all four fields - products table is complete
-- on these columns


-- STEP 4: Check for logical pricing errors
-- Negative prices
SELECT COUNT(*) AS negative_price
FROM products_test
WHERE retail_price < 0;
-- Result: 0 negative prices

-- Extreme prices (> EUR 1,000)
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;
-- Result: 0 rows - no extreme prices


-- STEP 5: Check category consistency (spelling/case variants)
SELECT category, COUNT(*) AS count
FROM products_test
GROUP BY category
ORDER BY category;
-- Result: 5 distinct categories, all consistently spelled/cased
-- (aksessuaarid, jalanousid, laste_riided, meeste_riided, naiste_riided)
-- A clean result here is a valid finding, not a failed query.


-- ==============================================
-- STEP 6: Cleaning Report Summary
-- ==============================================
-- | Category                 | Issues found | Description                        |
-- |---------------------------|--------------|-------------------------------------|
-- | Duplicate names           | 12           | Same product name appears twice     |
-- | NULL name/price           | 0            | No missing critical fields          |
-- | Logical errors            | 0            | No negative or extreme prices       |
-- | Inconsistent categories   | 0            | No spelling/case variants           |
-- | TOTAL issues               | 12           |                                      |
--
-- Recommendation for Toomas:
-- The products table is largely clean - no missing data, no pricing
-- errors, and no category inconsistencies. The only issue found is
-- 12 duplicate product names (24 rows). Recommend deduplicating these
-- the same way sales duplicates were handled (keep earliest row via
-- MIN(id), remove the rest) before the board meeting.
