# Week 7 — RFM Customer Segmentation (Python + pandas)

## The problem

Marko Saar, Product Manager at UrbanStyle, asked three questions:

> "Who are our VIPs? Who's at risk of leaving? Where should we focus first?"

UrbanStyle's customers had never been segmented. Our team used **RFM analysis** to split them into groups that marketing can act on.

## My role

Team of two. I took **Role A — data loading and cleaning**, and assembled and validated the final team notebook. My teammate built the RFM scoring and charts.

## What's in this folder

| File | What it is |
|---|---|
| `individual/week7_rfm_role_a.ipynb` | My part: load, check, merge and clean the sales and customer data |
| `group/week7_rfm_team.ipynb` | Team pipeline: clean data → RFM scores → segments → charts → summary for Marko |
| `week7_pandas_practice.ipynb` | Self-study: pandas basics (filtering, grouping, merging, labels) |

The raw data files are not included in this repo (excluded via `.gitignore`).

## Data cleaning

| Step | Rows |
|---|---|
| Raw sales loaded | 15,234 |
| Duplicate invoices removed | −5,116 |
| Sales with no customer removed | −988 |
| Zero or negative prices removed | −180 |
| **Clean sales** | **8,950** |

Result: **2,540 customers**, sales from January 2023 to June 2026.

Dates came in two formats (`2023-01-10` and `25/01/2023`). I parsed each format explicitly instead of letting pandas guess, then checked that 0 dates were left unreadable.

## Method: RFM

Each customer gets three scores from 1 to 5:

- **Recency** — how recently they bought (recent = 5)
- **Frequency** — how often they buy
- **Monetary** — how much they spent

Customers are ranked against each other and split into five equal groups, so a score means "better than X% of customers", not a fixed euro amount. The three scores are added up (3–15):

| Total | Segment |
|---|---|
| 13–15 | VIP Champions |
| 10–12 | Loyal |
| 7–9 | Potential |
| 4–6 | At Risk |
| 3 | Lost |

## Results

| Segment | Customers | % of customers | Revenue (EUR) | % of revenue |
|---|---|---|---|---|
| VIP Champions | 455 | 17.9% | 1,146,295 | 42.8% |
| Loyal | 679 | 26.7% | 796,357 | 29.7% |
| Potential | 759 | 29.9% | 521,793 | 19.5% |
| At Risk | 529 | 20.8% | 192,170 | 7.2% |
| Lost | 118 | 4.6% | 20,235 | 0.8% |

**Key finding:** VIP Champions are 18% of customers but bring 43% of revenue. VIP + Loyal together are 45% of customers and bring 73% of revenue.

## Recommendations for Marko

1. **VIP programme** — early access and exclusive offers to keep VIP Champions.
2. **Win-back campaign** — personalised emails for the 529 At Risk customers (€192k spent so far, still saveable).
3. **Nurture Potential customers** — follow-up offers to grow 759 customers into Loyal.

## Issues I caught during validation

- **Wrong reference date.** The task used 2025-02-28 as "today", but sales run to June 2026, which produced negative "days since last purchase". Fixed by using the day after the last sale (2026-06-29). Segments stayed the same (scores are rankings), but the charts are now correct.
- **Customer IDs treated as numbers** in the Top 10 VIP chart, which spread the bars across a number line. Fixed by treating IDs as labels.
- **Duplicate cells** in the merged notebook. Cleaned up so the notebook runs top to bottom without errors.

## Limitations

- Adding the three scores hides detail: a recent but small, one-time buyer can land in "At Risk". A finer version would combine the scores into named patterns.
- 939 sales have no email on file, so some customers can't be reached by an email campaign.

## Tools

Python 3.14 · pandas · Plotly · Jupyter (VS Code) · Git

## What I learned

- pandas uses the same logic as SQL (`WHERE`, `GROUP BY`, `JOIN`), just different syntax.
- Always print row counts before and after each cleaning step — it proves the step did what you intended.
- A fixed rule like "spent over €200 = VIP" can make most customers VIP; ranking customers against each other gives a meaningful group.
- Correct code isn't enough — the reference date was valid code but gave misleading results.
