# Week 3 — Sales Channel Analysis (SQL JOINs)

**Role:** D — Marketing + Sales Channel Analysis
**Business question (from Anna, Marketing Lead):** Which sales channels and cities are performing, and where should marketing budget go?

## Summary

UrbanStyle sells through two channels — **Pood** (in-store) and **Online**. Pood leads on scale (2,278 customers, €1.9M revenue vs online's 1,706 customers, €1.0M), and on effectiveness too: €835 revenue per customer vs €590 for online.

But the more useful finding is *why*: online's average purchase size (€290.80) closely matches in-store averages (€273–290) across all three physical stores. **Online isn't converting worse — it simply has fewer customers.** The gap is reach, not quality.

This pattern holds consistently across every city in the dataset (12 cities), and product category preference (men's clothing, shoes lead in both) doesn't shift by channel either.

**Recommendation:** Keep pood as the primary investment — it's the proven performer. Direct incremental marketing budget toward *growing online's customer base* (awareness, acquisition), not toward changing in-store behavior, since spending patterns are already consistent everywhere.

## Techniques used

- `INNER JOIN` across 2 and 3 tables (`sales`, `customers`, `products`)
- Aggregation: `COUNT`, `COUNT(DISTINCT ...)`, `SUM`, `AVG`, `ROUND`
- `GROUP BY` with multiple columns, `ORDER BY` for ranking

## Files

- [`week3_channels_joins.sql`](./week3_channels_joins.sql) — all 6 queries, commented
- Screenshots: channel revenue, 3-table JOIN, revenue-per-customer

## Reflection

The most useful lesson from this analysis: a channel that looks "weaker" on total revenue can be performing just as well *per customer* — the real diagnostic is decomposing a metric (total revenue) into its parts (customers × revenue/customer) before recommending action.
