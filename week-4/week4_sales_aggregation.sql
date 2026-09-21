-- ============================================================
-- Week 4 — SQL Aggregation | UrbanStyle sales analysis
-- Author: Ilija
-- Skills: GROUP BY, aggregate functions, HAVING, WHERE vs HAVING, JOIN
-- ============================================================


-- ------------------------------------------------------------
-- 1. Monthly sales trend (2024)
-- Business question: How does revenue change month by month?
-- Note: limited to 2024 — data after Feb 2025 is incomplete (see query 6)
-- ------------------------------------------------------------
SELECT
    DATE_TRUNC('month', sale_date) AS month,
    COUNT(*) AS orders,
    SUM(total_price) AS revenue,
    ROUND(AVG(total_price), 2) AS average_order
FROM sales
WHERE sale_date >= '2024-01-01' AND sale_date < '2025-01-01'
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month;


-- ------------------------------------------------------------
-- 2. Sales by city
-- Business question: Which cities bring in the most revenue?
-- ------------------------------------------------------------
SELECT
    c.city,
    COUNT(*) AS order_count,
    SUM(s.total_price) AS total_revenue,
    ROUND(AVG(s.total_price), 2) AS avg_order
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 3. High-value customers (HAVING)
-- Business question: Who are our most valuable customers?
-- ------------------------------------------------------------
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    COUNT(s.sale_id) AS order_count,
    SUM(s.total_price) AS total_revenue
FROM customers c
JOIN sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(s.total_price) > 500
ORDER BY total_revenue DESC;

-- 3b. Count them — the Supabase result viewer shows max 100 rows,
--     so counting by eye gives the wrong answer
SELECT COUNT(*) AS customers_over_500
FROM (
    SELECT c.customer_id
    FROM customers c
    JOIN sales s ON c.customer_id = s.customer_id
    GROUP BY c.customer_id
    HAVING SUM(s.total_price) > 500
) t;


-- ------------------------------------------------------------
-- 4. Category volumes (HAVING) — inventory audit for Liis
-- Business question: Which categories sell above the threshold?
-- ------------------------------------------------------------
SELECT
    p.category,
    SUM(s.quantity) AS units_sold,
    ROUND(AVG(p.retail_price), 2) AS avg_price,
    COUNT(DISTINCT p.product_id) AS product_count
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 5000   -- threshold chosen from the unfiltered totals
ORDER BY units_sold DESC;


-- ------------------------------------------------------------
-- 5. WHERE + HAVING together
-- Business question: In 2024, which cities had an average order above €280?
-- WHERE filters rows (2024 only) BEFORE grouping;
-- HAVING filters groups (cities) AFTER grouping.
-- ------------------------------------------------------------
SELECT
    c.city,
    COUNT(*) AS order_count,
    ROUND(AVG(s.total_price), 2) AS avg_order
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
WHERE s.sale_date >= '2024-01-01' AND s.sale_date < '2025-01-01'
GROUP BY c.city
HAVING AVG(s.total_price) > 280
ORDER BY avg_order DESC;


-- ------------------------------------------------------------
-- 6. Data quality check
-- Mar–Nov 2025 has no sales; Dec 2025 onwards has only 1–16 orders/month.
-- Inspect these rows before trusting them.
-- ------------------------------------------------------------
SELECT *
FROM sales
WHERE sale_date >= '2025-03-01'
ORDER BY sale_date;
