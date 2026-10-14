"""JOB 1 - GET: download UrbanStyle data from Supabase."""
import os
import pandas as pd
from dotenv import load_dotenv
from supabase import create_client

load_dotenv()
supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))


def fetch_table(table, order_col=None, start_date=None, end_date=None):
    """Download ALL rows of a table, 1000 at a time."""
    rows = []
    start = 0
    while True:
        query = supabase.table(table).select('*')
        if order_col:
            query = query.order(order_col)
        if start_date:
            query = query.gte('sale_date', start_date)
        if end_date:
            query = query.lte('sale_date', end_date)
        batch = query.range(start, start + 999).execute().data
        if not batch:
            break
        rows.extend(batch)
        start += 1000
    return pd.DataFrame(rows)


def fetch_sales(start_date=None, end_date=None):
    """Get sales, optionally between two dates."""
    try:
        return fetch_table('sales', 'id', start_date, end_date)
    except Exception as e:
        print(f"ERROR fetching sales: {e}")
        return pd.DataFrame()


def fetch_customers():
    """Get all customers."""
    try:
        return fetch_table('customers', 'customer_id')
    except Exception as e:
        print(f"ERROR fetching customers: {e}")
        return pd.DataFrame()


def fetch_products():
    """Get all products."""
    try:
        return fetch_table('products')
    except Exception as e:
        print(f"ERROR fetching products: {e}")
        return pd.DataFrame()


if __name__ == "__main__":
    print("Sales:", len(fetch_sales()))
    print("Customers:", len(fetch_customers()))
    print("Products:", len(fetch_products()))