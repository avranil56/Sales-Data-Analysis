import pandas as pd
import plotly.express as px
from datetime import datetime


def create_interactive_charts():
    try:
        # Load cleaned data
        df = pd.read_csv('sales_data_clean_final.csv')

        # 1. Monthly Revenue Trend
        df['Month'] = pd.to_datetime(df['Month'], format='%Y-%m')
        monthly_rev = df.groupby('Month')['Revenue'].sum().reset_index()
        fig1 = px.line(monthly_rev, x='Month', y='Revenue',
                       title='Monthly Revenue Trend')
        fig1.write_html('monthly_revenue.html')

        # 2. Top 5 Products
        top_products = df.groupby('Productline')['Total_Sales'].sum().nlargest(5).reset_index()
        fig2 = px.bar(top_products, x='Productline', y='Total_Sales',
                      title='Top 5 Products by Revenue')
        fig2.write_html('top_products.html')

        # 3. Sales by Deal Size
        deal_size = df.groupby('Deal_Size')['Revenue'].sum().reset_index()
        fig3 = px.pie(deal_size, names='Deal_Size', values='Revenue',
                      title='Revenue by Deal Size')
        fig3.write_html('deal_size.html')

        # 4. Revenue by Country
        country_rev = df.groupby('Country')['Revenue'].sum().nlargest(10).reset_index()
        fig4 = px.bar(country_rev, x='Country', y='Revenue',
                      title='Top 10 Countries by Revenue')
        fig4.write_html('country_revenue.html')

        # 5. Repeat Customers (using your exact column names)
        repeat_cust = df[['Customer_Name', 'Order_Count', 'Total_Spend']].drop_duplicates()
        repeat_cust = repeat_cust[repeat_cust['Order_Count'] > 1] \
            .nlargest(10, 'Total_Spend')

        fig5 = px.bar(repeat_cust,
                      x='Customer_Name',
                      y='Total_Spend',
                      title='Top Repeat Customers (2+ Orders)',
                      hover_data=['Order_Count'],
                      labels={'Total_Spend': 'Total Spending ($)',
                              'Customer_Name': 'Customer'})
        fig5.write_html('repeat_customers.html')

        print("All 5 charts created successfully!")
        print("Files saved in:", os.getcwd())

    except Exception as e:
        print(f"Error: {str(e)}")
        if 'df' in locals():
            print("\nDebug Info - First 5 rows:")
            print(df.head()[['Customer_Name', 'Order_Count', 'Total_Spend']])


if __name__ == "__main__":
    create_interactive_charts()