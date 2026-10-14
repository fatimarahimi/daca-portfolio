"""JOB 2 - COOK: clean the data and calculate the numbers."""
import pandas as pd


def clean_data(df):
    """Remove duplicate rows, drop broken rows, fix the date type."""
    before = len(df)
    cols = [c for c in df.columns if c != 'id']
    df = df.drop_duplicates(subset=cols)
    df = df.dropna(subset=['sale_date', 'total_price'])
    df['sale_date'] = pd.to_datetime(df['sale_date'])
    print(f"Cleaning: {before} -> {len(df)} rows")
    return df


def calculate_weekly_aggregates(df):
    """Revenue, number of orders and average order per week."""
    weekly = df.groupby(pd.Grouper(key='sale_date', freq='W')).agg(
        revenue=('total_price', 'sum'),
        orders=('total_price', 'count'),
        avg_order=('total_price', 'mean'),
    ).reset_index()
    return weekly.rename(columns={'sale_date': 'week'})


def calculate_kpis(df):
    """The headline numbers Marko wants to see."""
    return {
        'total_revenue': round(float(df['total_price'].sum()), 2),
        'total_orders': int(len(df)),
        'unique_customers': int(df['customer_id'].nunique()),
        'avg_order_value': round(float(df['total_price'].mean()), 2),
    }


def merge_datasets(df_sales, df_customers):
    """Add customer details to each sale."""
    customers = df_customers.drop_duplicates(subset='customer_id')
    return pd.merge(df_sales, customers, on='customer_id', how='left')


if __name__ == "__main__":
    from data_fetcher import fetch_sales
    sales = clean_data(fetch_sales())
    print(calculate_kpis(sales))
    print(calculate_weekly_aggregates(sales).head())