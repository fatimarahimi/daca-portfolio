-- ============================================================
-- Week 3: SQL JOINs — Role D: Sales Channel Analysis
-- UrbanStyle Data Analyst Career Accelerator
-- Business question (Anna, Marketing Lead):
-- "Which sales channels and cities are working?"
-- ============================================================

-- 1. How many different sales channels are there?
SELECT DISTINCT channel
FROM sales
ORDER BY channel;
-- Result: online, pood (2 channels)


-- 2. Which channel brings the most sales?
SELECT
    s.channel AS sales_channel,
    COUNT(DISTINCT s.customer_id) AS customers,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue
FROM sales s
GROUP BY s.channel
ORDER BY total_revenue DESC;
-- Result: pood leads on customers, purchases, and revenue


-- 3. Which cities' customers use which channels? (2-table JOIN)
SELECT
    s.channel AS sales_channel,
    c.city AS city,
    COUNT(DISTINCT c.customer_id) AS customers,
    SUM(s.total_price) AS total_revenue
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
GROUP BY s.channel, c.city
ORDER BY sales_channel, total_revenue DESC;
-- Result: pood outperforms online in every single city


-- 4. Which products sell in which channel? (3-table JOIN — Advanced level)
SELECT
    s.channel AS sales_channel,
    p.category AS product_category,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue,
    ROUND(AVG(s.total_price), 2) AS average_purchase
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
GROUP BY s.channel, p.category
ORDER BY sales_channel, total_revenue DESC;
-- Result: meeste_riided (men's clothing) and jalanõusid (shoes)
-- top-sell in both channels


-- 5. Which channel is most EFFECTIVE (revenue per customer)?
SELECT
    s.channel AS sales_channel,
    COUNT(DISTINCT s.customer_id) AS customers,
    SUM(s.total_price) AS total_revenue,
    ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS revenue_per_customer
FROM sales s
GROUP BY s.channel
ORDER BY revenue_per_customer DESC;
-- Result: pood €835/customer vs online €590/customer


-- 6. Do individual stores behave differently from online? (by store location)
SELECT
    s.store_location AS store,
    s.channel AS sales_channel,
    COUNT(s.sale_id) AS purchases,
    SUM(s.total_price) AS total_revenue,
    ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS average_purchase
FROM sales s
GROUP BY s.store_location, s.channel
ORDER BY store, total_revenue DESC;
-- Result: Tallinn/Tartu/Pärnu stores behave almost identically per-purchase
-- (€273-290 avg); online's average purchase (€290.80) matches closely —
-- differences are about customer volume, not spending behaviour
