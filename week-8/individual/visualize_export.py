"""JOB 3 - SERVE: make charts and save the results to files."""
import os
from datetime import datetime
import plotly.express as px
import plotly.graph_objects as go

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'output')


def create_weekly_chart(df_weekly):
    """Line chart of revenue per week."""
    return px.line(df_weekly, x='week', y='revenue',
                   title='UrbanStyle - weekly revenue (EUR)',
                   labels={'week': 'Week', 'revenue': 'Revenue (EUR)'})


def create_kpi_summary(kpis):
    """Simple table of the headline numbers."""
    fig = go.Figure(go.Table(
        header=dict(values=['KPI', 'Value']),
        cells=dict(values=[list(kpis.keys()), list(kpis.values())]),
    ))
    fig.update_layout(title='UrbanStyle - key numbers')
    return fig


def export_results(df_weekly, charts, output_dir=OUTPUT_DIR):
    """Save the weekly table as CSV and each chart as HTML, dated."""
    os.makedirs(output_dir, exist_ok=True)
    date_str = datetime.now().strftime('%Y%m%d')
    csv_path = os.path.join(output_dir, f'weekly_report_{date_str}.csv')
    df_weekly.to_csv(csv_path, index=False)
    for name, fig in charts.items():
        fig.write_html(os.path.join(output_dir, f'{name}_{date_str}.html'))
    print(f"Saved 1 CSV + {len(charts)} charts to {output_dir}")
    return csv_path


if __name__ == "__main__":
    from data_fetcher import fetch_sales
    from transform import clean_data, calculate_weekly_aggregates, calculate_kpis
    sales = clean_data(fetch_sales())
    weekly = calculate_weekly_aggregates(sales)
    kpis = calculate_kpis(sales)
    export_results(weekly, {
        'weekly_revenue': create_weekly_chart(weekly),
        'kpi_summary': create_kpi_summary(kpis),
    })