# Week 4 — SQL Aggregation

## What was the task?

Turn UrbanStyle's 10,000+ sales rows into a few key numbers the CEO (Kristi) can present to the board: revenue trends, top customers, and where sales come from.

## What did I do?

- Practised aggregation at Shu/Ha level: `GROUP BY`, `SUM`, `AVG`, `COUNT`, `COUNT(DISTINCT)`, `HAVING`, and `WHERE` + `HAVING` together
- Built a monthly revenue trend for 2024 using `DATE_TRUNC`
- Joined sales with customers and products to analyse cities, top customers and category volumes
- Checked suspicious data before reporting it
- Queries saved in `week4_sales_aggregation.sql`

## What did I find?

- **Revenue roughly doubles across the year:** January 2024 was lowest (€85.6k), December highest (€170.6k)
- **Real year-over-year growth:** January +16% and February +6% (2024 → 2025)
- **Strong summer:** June–August held steady at about €145k per month
- **A clear VIP group:** the top 15 customers placed 56–78 orders each (€16k–€28k), followed by a sharp drop
- **Data issue:** March–November 2025 has no sales and later months have only 1–16 orders, so I treated it as incomplete data (not a business decline) and limited the trend to 2024

## What did I learn?

- `WHERE` filters rows before grouping; `HAVING` filters groups after grouping
- Question surprising results before reporting them — a "decline" can be missing data
- Don't count results by eye: the Supabase viewer shows max 100 rows, so use `COUNT(*)`
- Revenue is not profit — without cost data, I can only report revenue
