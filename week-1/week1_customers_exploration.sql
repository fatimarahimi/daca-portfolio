-- Week 1 — Customer Data Investigation
-- Role B: Customer Data Explorer
-- Toomas wants to know which customers are in UrbanStyle's database:
-- how many customers, which cities, any duplicate emails, when did they register.

-- Q1: Total number of customers
SELECT COUNT(*) AS customer_count FROM customers;
-- Finding: 3,150 customers

-- Q2: Which cities are represented
SELECT DISTINCT city FROM customers;
-- Finding: 54 distinct values returned, but only 12 real cities exist.
-- Inconsistent capitalization/spacing (e.g. "Tallinn", "TALLINN", "tallinn", " Tallinn")
-- inflates the count. Example: Tallinn alone is split across 5 variants
-- totaling 1,238 customers who should be counted as one city.

-- Q3: Earliest and most recent registration dates
SELECT MIN(registration_date) AS earliest,
       MAX(registration_date) AS latest
FROM customers;
-- Finding: customer base spans just over 5 years (2020-01-02 to 2025-02-27)

-- Q4: Missing values check (first name and email)
SELECT COUNT(*) - COUNT(first_name) AS missing_first_names,
       COUNT(*) - COUNT(email) AS missing_emails
FROM customers;
-- Finding: 0 missing first names, but 380 customers (~12%) are missing an email

-- Q5 (Advanced extension): Duplicate email check
SELECT COUNT(*) AS all_rows,
       COUNT(DISTINCT email) AS unique_emails
FROM customers;
-- Finding: 3,150 rows vs 2,640 unique emails. After accounting for the
-- 380 missing emails (2,770 customers with an email), 130 customers
-- share an email with another customer.
-- Manual spot-check of recent registrations also found likely duplicate
-- PEOPLE, not just emails — e.g. customer_id 5006 (KEVIN Arro) and 2263
-- (Kevin Arro) share identical email, phone, city and birth_year.

-- ============================================================
-- SUMMARY
-- ============================================================
-- I investigated the customers table. I found 3,150 customers across
-- what should be 12 cities, but inconsistent capitalization inflated
-- that to 54 distinct stored values. 380 customers (12%) are missing
-- an email address, and at least 130 share an email with another
-- customer — spot-checks suggest some of these are the same person
-- registered more than once (e.g. Kevin Arro, Sirje Kuusk, Raivo Nõmm
-- all appear twice with identical contact details).
--
-- For UrbanStyle, this means city-based reporting is currently
-- unreliable, and outreach campaigns would miss over 1 in 10
-- customers due to missing emails — while duplicate customer records
-- risk inflating customer counts and skewing loyalty/marketing metrics.
