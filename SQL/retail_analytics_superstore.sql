-- Total Sales
SELECT SUM("Sales"::NUMERIC) AS total_sales
FROM superstore_orders;


-- Total Profit
SELECT SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders;


-- Profit Margin
SELECT 
    (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100
AS profit_margin
FROM superstore_orders;

-- Total Orders
SELECT COUNT(*) AS total_orders
FROM superstore_orders;

-- Total Customers
SELECT COUNT(DISTINCT "Customer ID") AS total_customers
FROM superstore_orders;

--Section 2: Category-Level Insights

-- Sales by Category
SELECT "Category",
       SUM("Sales"::NUMERIC) AS total_sales
FROM superstore_orders
GROUP BY "Category"
ORDER BY total_sales DESC;


-- Profit by Category
SELECT "Category",
       SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders
GROUP BY "Category"
ORDER BY total_profit DESC;


-- Profit Margin by Category
SELECT "Category",
       (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100 AS profit_margin_pct
FROM superstore_orders
GROUP BY "Category"
ORDER BY profit_margin_pct DESC;

-- Section 3: Regional Insights (Geography Analysis)

-- Sales by Region
SELECT "Region",
       SUM("Sales"::NUMERIC) AS total_sales
FROM superstore_orders
GROUP BY "Region"
ORDER BY total_sales DESC;


-- Profit by Region
SELECT "Region",
       SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders
GROUP BY "Region"
ORDER BY total_profit DESC;


-- Profit Margin by Region
SELECT "Region",
       (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100 AS profit_margin_pct
FROM superstore_orders
GROUP BY "Region"
ORDER BY profit_margin_pct DESC;


-- Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', "Order Date") AS month,
    SUM("Sales"::NUMERIC) AS total_sales
FROM superstore_orders
GROUP BY month
ORDER BY month;


-- Monthly Profit Trend
SELECT 
    DATE_TRUNC('month', "Order Date") AS month,
    SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders
GROUP BY month
ORDER BY month;


-- Monthly Profit Margin Trend
SELECT 
    DATE_TRUNC('month', "Order Date") AS month,
    (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100 AS profit_margin_pct
FROM superstore_orders
GROUP BY month
ORDER BY month;



-- Sales & Profit by Segment
SELECT 
    "Segment",
    SUM("Sales"::NUMERIC)  AS total_sales,
    SUM("Profit"::NUMERIC) AS total_profit,
    (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100 AS profit_margin_pct
FROM superstore_orders
GROUP BY "Segment"
ORDER BY total_sales DESC;


-- Top 10 Customers by Sales
SELECT 
    "Customer ID",
    "Customer Name",
    SUM("Sales"::NUMERIC)  AS total_sales,
    SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_sales DESC
LIMIT 10;


-- Top 10 Customers by Profit
SELECT 
    "Customer ID",
    "Customer Name",
    SUM("Profit"::NUMERIC) AS total_profit,
    SUM("Sales"::NUMERIC)  AS total_sales
FROM superstore_orders
GROUP BY "Customer ID", "Customer Name"
ORDER BY total_profit DESC
LIMIT 10;


-- Top 10 Products by Sales
SELECT 
    "Product ID",
    "Product Name",
    "Sub-Category",
    "Category",
    SUM("Sales"::NUMERIC)  AS total_sales,
    SUM("Profit"::NUMERIC) AS total_profit
FROM superstore_orders
GROUP BY "Product ID", "Product Name", "Sub-Category", "Category"
ORDER BY total_sales DESC
LIMIT 10;



-- Bottom 10 Products by Profit (Worst Performers)
SELECT 
    "Product ID",
    "Product Name",
    "Sub-Category",
    "Category",
    SUM("Profit"::NUMERIC) AS total_profit,
    SUM("Sales"::NUMERIC)  AS total_sales
FROM superstore_orders
GROUP BY "Product ID", "Product Name", "Sub-Category", "Category"
ORDER BY total_profit ASC
LIMIT 10;


-- Discount vs Profit by Category
SELECT 
    "Category",
    AVG("Discount"::NUMERIC)                        AS avg_discount,
    SUM("Sales"::NUMERIC)                           AS total_sales,
    SUM("Profit"::NUMERIC)                          AS total_profit,
    (SUM("Profit"::NUMERIC) / SUM("Sales"::NUMERIC)) * 100 AS profit_margin_pct
FROM superstore_orders
GROUP BY "Category"
ORDER BY avg_discount DESC;


-- Running Total of Sales by Month
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', "Order Date"::DATE) AS month,
        SUM("Sales"::NUMERIC) AS total_sales
    FROM superstore_orders
    GROUP BY month
)
SELECT 
    month,
    total_sales,
    SUM(total_sales) OVER (ORDER BY month) AS running_total_sales
FROM monthly_sales
ORDER BY month;



-- Top 5 Products within each Sub-Category (by Sales)
SELECT *
FROM (
    SELECT 
        "Sub-Category",
        "Product Name",
        SUM("Sales"::NUMERIC) AS total_sales,
        RANK() OVER (
            PARTITION BY "Sub-Category"
            ORDER BY SUM("Sales"::NUMERIC) DESC
        ) AS sales_rank_in_subcategory
    FROM superstore_orders
    GROUP BY "Sub-Category", "Product Name"
) ranked
WHERE sales_rank_in_subcategory <= 5
ORDER BY "Sub-Category", sales_rank_in_subcategory;


