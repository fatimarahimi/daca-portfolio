-- Q1: Total rows in raw sales extract
SELECT COUNT(*) FROM sales;
-- Finding: 15,234 rows

-- Q2: Unique invoice IDs — checks Toomas's duplicate suspicion
SELECT COUNT(DISTINCT invoice_id) FROM sales;
-- Finding: 10118 unique — roughly 5,000 rows may be duplicated

-- Q3: Sales missing a customer link
SELECT COUNT(*) FROM sales WHERE customer_id IS NULL;
-- Finding: 1487 rows have no customer attached — can't identify buyer

-- Q4: Negative total_price values (should not exist in a shop)
SELECT * FROM sales WHERE total_price < 0;
-- Finding: 305 rows are negative — needs investigation, may be refunds

-- Q5: Unique customers who've actually purchased
SELECT COUNT(DISTINCT customer_id) FROM sales WHERE customer_id IS NOT NULL;
-- Finding: 2,558 unique customers across 13,000+ linked sales