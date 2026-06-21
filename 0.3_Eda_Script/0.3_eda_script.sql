-- ============================================================
-- EDA SCRIPT: Retail Sales Raw Data Checks
-- This script helps you see the raw data before loading it.
-- ============================================================

-- 1. Count total rows and orders
SELECT COUNT(*) AS total_rows,
       COUNT(DISTINCT "Order ID") AS unique_order_count
FROM public.retail_sales_original;

-- 2. Check if key columns have missing values
SELECT SUM(CASE WHEN "Order ID" IS NULL OR "Order ID" = '' THEN 1 ELSE 0 END) AS missing_order_id,
       SUM(CASE WHEN "Purchase Date" IS NULL OR "Purchase Date" = '' THEN 1 ELSE 0 END) AS missing_purchase_date,
       SUM(CASE WHEN "Store ID" IS NULL OR "Store ID" = '' THEN 1 ELSE 0 END) AS missing_store_id,
       SUM(CASE WHEN "Product ID" IS NULL OR "Product ID" = '' THEN 1 ELSE 0 END) AS missing_product_id,
       SUM(CASE WHEN "Customer ID" IS NULL OR "Customer ID" = '' THEN 1 ELSE 0 END) AS missing_customer_id
FROM public.retail_sales_original;

-- 3. See how many distinct values each dimension has
SELECT COUNT(DISTINCT "Continent") AS continent_count,
       COUNT(DISTINCT "Country") AS country_count,
       COUNT(DISTINCT "City") AS city_count,
       COUNT(DISTINCT "Store ID") AS store_count,
       COUNT(DISTINCT "Promotion ID") AS promotion_count,
       COUNT(DISTINCT "Customer ID") AS customer_count,
       COUNT(DISTINCT "Salesperson ID") AS salesperson_count,
       COUNT(DISTINCT "Product ID") AS product_count
FROM public.retail_sales_original;

-- 4. Check numeric columns for min and max values
SELECT MIN("Quantity") AS min_quantity,
       MAX("Quantity") AS max_quantity,
       MIN("Unit Cost") AS min_unit_cost,
       MAX("Unit Cost") AS max_unit_cost,
       MIN("Unit Price") AS min_unit_price,
       MAX("Unit Price") AS max_unit_price,
       MIN("Gross Sales") AS min_gross_sales,
       MAX("Gross Sales") AS max_gross_sales,
       MIN("Net Sales") AS min_net_sales,
       MAX("Net Sales") AS max_net_sales
FROM public.retail_sales_original;

-- 5. Review returned values and missing dates
SELECT "Returned", COUNT(*) AS count_of_rows
FROM public.retail_sales_original
GROUP BY "Returned"
ORDER BY "Returned";

SELECT SUM(CASE WHEN "Ship Date" IS NULL OR "Ship Date" = '' THEN 1 ELSE 0 END) AS missing_ship_date,
       SUM(CASE WHEN "Return Date" IS NULL OR "Return Date" = '' THEN 1 ELSE 0 END) AS missing_return_date
FROM public.retail_sales_original;

-- 6. See a few rows of raw data
SELECT *
FROM public.retail_sales_original
LIMIT 20;
