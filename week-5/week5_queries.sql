-- Week 5: Visualisation Design — UrbanStyle
-- Queries used to check data before building the dashboard

-- 1. Check how far the sales data actually goes
-- Result: last row is 2026-06-28, but data effectively ends Feb 2025
SELECT MAX(sale_date) FROM sales;

-- 2. Monthly row counts — revealed the data gap after Feb 2025
-- Feb 2025 = 347 rows, then only single-digit stray rows
SELECT DATE_TRUNC('month', sale_date) AS month, COUNT(*)
FROM sales
GROUP BY 1
ORDER BY 1 DESC
LIMIT 20;

-- 3. Revenue by store — fed the "Sales by store" chart
-- Blank store_location = online sales, relabelled in Power Query
SELECT store_location, SUM(total_price) AS revenue, COUNT(*) AS transactions
FROM sales
GROUP BY store_location
ORDER BY revenue DESC;

-- 4. Stock by category — fed the "Stock by category" chart
SELECT p.category, SUM(i.quantity_available) AS quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY quantity DESC;

-- 5. Data quality check — found 10 rows with negative stock
-- These were filtered out in Power Query before charting
SELECT COUNT(*) FROM inventory WHERE quantity_available < 0;