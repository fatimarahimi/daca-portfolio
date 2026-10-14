"""START BUTTON: runs GET -> COOK -> SERVE in order, with a log."""
import logging
import os
import time
from datetime import datetime

from data_fetcher import fetch_sales, fetch_customers
from transform import clean_data, calculate_weekly_aggregates, calculate_kpis, merge_datasets
from visualize_export import create_weekly_chart, create_kpi_summary, export_results

LOG_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'logs')
os.makedirs(LOG_DIR, exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(os.path.join(LOG_DIR, f"pipeline_{datetime.now():%Y%m%d}.log"), encoding='utf-8'),
        logging.StreamHandler(),
    ],
)
log = logging.getLogger(__name__)
logging.getLogger("httpx").setLevel(logging.WARNING)

def run_pipeline():
    """Run the whole weekly report. Returns True if it worked."""
    log.info("Pipeline started")

    # JOB 1 - GET
    sales = fetch_sales()
    customers = fetch_customers()
    if sales.empty:
        log.error("GET failed: no sales data - stopping")
        return False
    log.info(f"GET done: {len(sales)} sales, {len(customers)} customers")

    # JOB 2 - COOK
    try:
        sales = clean_data(sales)
        merged = merge_datasets(sales, customers)
        if len(merged) != len(sales):
            log.warning("Merge changed the row count - check customer duplicates")
        weekly = calculate_weekly_aggregates(sales)
        kpis = calculate_kpis(sales)
        log.info(f"COOK done: {len(weekly)} weeks, KPIs: {kpis}")
    except Exception as e:
        log.error(f"COOK failed: {e}")
        return False

    # JOB 3 - SERVE
    try:
        export_results(weekly, {
            'weekly_revenue': create_weekly_chart(weekly),
            'kpi_summary': create_kpi_summary(kpis),
        })
        log.info("SERVE done: files saved")
    except Exception as e:
        log.error(f"SERVE failed: {e}")
        return False

    return True


if __name__ == "__main__":
    start = time.time()
    ok = run_pipeline()
    log.info(f"Pipeline {'SUCCEEDED' if ok else 'FAILED'} in {time.time() - start:.1f} seconds")