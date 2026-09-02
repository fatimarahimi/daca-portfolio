# Week 2 — SQL Data Cleaning

## Context

UrbanStyle's data needs to be cleaned safely ahead of the CEO's board meeting. This week's goal: detect and document data-quality issues (duplicates, missing values, inconsistent formatting) using safe practices — always working on a test copy, never the live table.

## My contribution

In group work I was assigned **Task Card C: Product Data Cleaning**. I created a test copy of the `products` table and ran diagnostic checks for duplicates, missing values, pricing errors, and category inconsistencies.

**Findings:**
- 12 duplicate product names found (24 rows affected)
- 0 missing values in product name, category, retail price, or cost price
- 0 negative or unrealistic (>€1,000) prices
- 0 category spelling/formatting inconsistencies

**Recommendation:** the products table is largely clean. The one issue — duplicate product names — should be deduplicated the same way sales duplicates were handled (keep the earliest row, remove the rest).

See `week2_products_cleaning.sql` for the full script and inline results.

## Team's shared work

Full team report and other domains (sales, customers, cross-validation) are in the team's shared repository/document.
