# Sales Data Analysis Project

![Dashboard Preview](visualizations/dashboard_preview.png)  
*Interactive visualization of sales trends*

## Project Overview
Analyzed sales records to identify revenue drivers and optimize business strategy using:
- **MySQL** for data processing
- **Python** (Pandas + Plotly) for interactive visualizations
- **Excel** for initial data cleaning

## Technical Implementation


### Data Pipeline
1. **Data Collection**: Raw sales data from Kaggle
2. **Data Cleaning**:
   - Handled missing values in MySQL (`sales_data_clean.sql`)
   - Standardized date formats across records
3. **Analysis**:
   - Calculated key metrics (revenue growth, customer retention)
   - Generated 5 interactive visualizations


### Key Scripts
|          File           |            Purpose           |
|-------------------------|------------------------------|
| `data_cleaning.sql`     | MySQL transformations        |
| `interactive_charts.py` | Generates all visualizations |
| `validate_data.py`      | Data quality checks          |


## Interactive Visualizations
[ Click to view interactive charts]

|                    Visualization                           |               Insights                |
|------------------------------------------------------------|---------------------------------------|
| [Monthly Revenue](visualizations/monthly_revenue.html)     | Identified 18% Q4 revenue spike       |
| [Top Products](visualizations/top_products.html)           | Classic Cars generated 32% of revenue |
| [Customer Retention](visualizations/repeat_customers.html) | Top 5 customers = 22% of sales        |


##  Key Findings
1. **Product Strategy**:
   - Classic Cars have 40% higher profit margin than other categories
   - Recommend expanding inventory in this category

2. **Customer Insights**:
   - Repeat customers spend 3x more than one-time buyers
   - Implement loyalty program to boost retention

3. **Regional Trends**:
   - European market growing 15% quarter-over-quarter
   - Allocate more marketing budget to EU campaigns


##  How to Reproduce
1. **Setup**:
   ```bash
   pip install pandas plotly
   mysql -u root -p < data_cleaning.sql


