# Week 8 – Automated Weekly Sales Pipeline (Python + Supabase API)

## Business problem
Marko (Product Manager, UrbanStyle) spent ~4 hours every week building the same sales report by hand: export CSV → clean → calculate → chart.

## Solution
An automated ETL pipeline that runs with one command:

python week-8/individual/pipeline.py

| Stage | File | What it does |
|---|---|---|
| Extract | `data_fetcher.py` | Pulls sales, customers, products from the Supabase REST API (with pagination past the 1,000-row limit) |
| Transform | `transform.py` | Cleans data, calculates weekly revenue and KPIs, merges customer details |
| Load | `visualize_export.py` | Saves a dated CSV + Plotly charts (weekly revenue, KPI table) |
| Orchestrate | `pipeline.py` | Runs all stages in order, logs each step to a dated log file, stops cleanly on error |

## Results
- 10,118 sales and 2,551 unique customers processed across 183 weeks
- Total revenue: €2.91M, average order: €287.53
- Runtime: **~2.5 seconds** (vs ~4 hours manually)

  ## Output
![Weekly revenue chart](individual/YOUR_CHART_FILE.png)
*Weekly revenue across 183 weeks — generated automatically in 2.5 seconds.*

## How to run
1. Clone the repo
2. `pip install pandas requests plotly python-dotenv`
3. Copy `.env.example` → `.env` and add your Supabase URL and key
4. `python week-8/individual/pipeline.py`

## Output
![Weekly revenue chart](individual/images/weekly_revenue.png)
*Weekly revenue across 183 weeks — generated automatically in 2.5 seconds.*

## How to run
1. Clone the repo
2. `pip install pandas requests plotly python-dotenv`
3. Copy `.env.example` → `.env` and add your Supabase URL and key
4. `python week-8/individual/pipeline.py`

## My role
Group work this week – I built all four modules (Roles A–D) end to end.

## What I learned
- Supabase returns max 1,000 rows per request – without pagination I'd have analysed only 10% of the data
- API keys live in `.env` (ignored by Git), never in the code; `.env.example` shows what's needed
- Splitting a pipeline into one file per stage makes errors easy to locate

## AI use
I used Claude as a coach to explain concepts step by step and to draft the module code, which I ran, tested and checked against the expected row counts.
