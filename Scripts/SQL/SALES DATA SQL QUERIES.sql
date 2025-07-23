CREATE DATABASE IF NOT EXISTS sales_analysis;
drop database sales_analysis;
DESCRIBE sales;
USE sales_analysis;
CREATE TABLE sales (
    ORDERNUMBER INT,
    QUANTITYORDERED INT,
    PRICEEACH DECIMAL(10,2),
    ORDERLINENUMBER INT,
    SALES DECIMAL(10,2),
    ORDERDATE DATETIME,  
    STATUS VARCHAR(20),
    QTR_ID INT,
    YEAR_ID INT,
    PRODUCTLINE VARCHAR(50),
    MSRP INT,
    PRODUCTCODE VARCHAR(20),
    CUSTOMERNAME VARCHAR(100),
    ADDRESSLINE1 VARCHAR(100),
    CITY VARCHAR(50),
    COUNTRY VARCHAR(50),
    TERRITORY VARCHAR(50),
    CONTACTLASTNAME VARCHAR(50),
    CONTACTFIRSTNAME VARCHAR(50),
    DEALSIZE VARCHAR(10)
);
ALTER TABLE sales MODIFY ORDERDATE VARCHAR(20);  -- Temporarily change to text

LOAD DATA LOCAL INFILE 'C:/Users/CROSSBONES/Desktop/SALES DATA CSV/sales_data_clean_final.csv'  --  importing data from csv file
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM sales;  -- Should return 2738, ( checking all imports )
SELECT * FROM sales WHERE ORDERDATE IS NULL;  
SELECT ORDERNUMBER, ORDERDATE FROM sales LIMIT 5;  

SET SQL_SAFE_UPDATES = 0;  -- safe update mode enabled

UPDATE sales 

SET ORDERDATE =   -- setting oder date in correct format
    CASE
        WHEN ORDERDATE REGEXP '[0-9]{2}-[0-9]{2}-[0-9]{4}' THEN
            STR_TO_DATE(ORDERDATE, '%d-%m-%Y')  -- Use '%m-%d-%Y' if dates are MM-DD-YYYY
        ELSE
            NULL
    END;
    
    SET SQL_SAFE_UPDATES = 1;  -- safe update mode disabled
    
SELECT COUNT(*) FROM sales WHERE ORDERDATE IS NULL;

SELECT 
  MIN(ORDERDATE) AS earliest_date, -- check date functions
  MAX(ORDERDATE) AS latest_date  
FROM sales;  









SELECT   -- Monthly Revenue Trend
  DATE_FORMAT(ORDERDATE, '%Y-%m') AS month,  
  SUM(SALES) AS revenue  
FROM sales  
GROUP BY month  
ORDER BY month;  

SELECT    -- Top 5 Products by Sales
  PRODUCTLINE,  
  SUM(SALES) AS total_sales  
FROM sales  
GROUP BY PRODUCTLINE  
ORDER BY total_sales DESC  
LIMIT 5;  

SELECT   -- Customer Segmentation
  COUNTRY,  
  COUNT(DISTINCT CUSTOMERNAME) AS unique_customers,  
  SUM(SALES) AS revenue  
FROM sales  
GROUP BY COUNTRY  
ORDER BY revenue DESC;

SELECT   --  Sales Performance by Deal Size
    DEALSIZE,
    COUNT(*) AS order_count,
    SUM(SALES) AS total_revenue,
    ROUND(SUM(SALES) * 100.0 / (SELECT SUM(SALES) FROM sales), 2) AS revenue_percentage
FROM sales
GROUP BY DEALSIZE
ORDER BY total_revenue DESC;

SELECT   -- Quarterly Sales Growth
    CONCAT('Q', QTR_ID, ' ', YEAR_ID) AS quarter,
    SUM(SALES) AS revenue,
    ROUND((SUM(SALES) - LAG(SUM(SALES)) OVER (ORDER BY YEAR_ID, QTR_ID)) / 
          LAG(SUM(SALES)) OVER (ORDER BY YEAR_ID, QTR_ID) * 100, 2) AS growth_percentage
FROM sales
GROUP BY YEAR_ID, QTR_ID
ORDER BY YEAR_ID, QTR_ID;  

SELECT   -- Customer Repeat Purchase Rate
    CUSTOMERNAME,
    COUNT(*) AS order_count,
    SUM(SALES) AS total_spend
FROM sales
GROUP BY CUSTOMERNAME
HAVING order_count > 1  -- Filter repeat buyers
ORDER BY total_spend DESC
LIMIT 10;

SELECT   -- Product Profitability Analysis
    PRODUCTLINE,
    SUM(SALES) AS total_revenue,
    ROUND(SUM(SALES) / SUM(QUANTITYORDERED), 2) AS avg_price_per_unit,  
    SUM(QUANTITYORDERED) AS total_units_sold,
    ROUND(SUM(SALES) * 0.3, 2) AS estimated_profit  -- Assuming 30% margin
FROM sales
GROUP BY PRODUCTLINE
ORDER BY estimated_profit DESC;

 