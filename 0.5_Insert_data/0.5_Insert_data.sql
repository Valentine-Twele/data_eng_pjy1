-- ============================================================
-- STEP 4: Load dimension and fact tables in the data warehouse.
-- Run this script in the dwh_retail_sales database after the schema exists.
-- It loads dimensions first and then inserts fact records.
-- ============================================================

-- 1. Load the location dimension
INSERT INTO dim_location (continent, country, city)
SELECT DISTINCT "Continent", "Country", "City"
FROM public.retail_sales_original
WHERE "Continent" IS NOT NULL
  AND "Country" IS NOT NULL
  AND "City" IS NOT NULL;

-- 2. Load the store dimension
INSERT INTO dim_store (store_id, store_name, store_type)
SELECT DISTINCT "Store ID", "Store Name", "Store Type"
FROM public.retail_sales_original
WHERE "Store ID" IS NOT NULL;

-- 3. Load the promotion dimension
INSERT INTO dim_promotion (promotion_id, promotion_name)
SELECT DISTINCT "Promotion ID", "Promotion Name"
FROM public.retail_sales_original
WHERE "Promotion ID" IS NOT NULL;

-- 4. Load the customer dimension
INSERT INTO dim_customer (customer_id, customer_segment, loyalty_tier)
SELECT DISTINCT "Customer ID", "Customer Segment", "Loyalty Tier"
FROM public.retail_sales_original
WHERE "Customer ID" IS NOT NULL;

-- 5. Load the salesperson dimension
INSERT INTO dim_salesperson (salesperson_id, salesperson_department)
SELECT DISTINCT "Salesperson ID", "Salesperson Department"
FROM public.retail_sales_original
WHERE "Salesperson ID" IS NOT NULL;

-- 6. Load the product dimension
INSERT INTO dim_product (product_id, sku, product_name, category, subcategory, brand)
SELECT DISTINCT "Product ID", "SKU", "Product Name", "Category", "Subcategory", "Brand"
FROM public.retail_sales_original
WHERE "Product ID" IS NOT NULL;

-- 7. Load the date dimension
INSERT INTO dim_date (date_id, full_date, year, quarter, month, day, day_of_week, is_weekend)
SELECT DISTINCT
    EXTRACT(YEAR FROM full_date) * 10000
      + EXTRACT(MONTH FROM full_date) * 100
      + EXTRACT(DAY FROM full_date) AS date_id,
    full_date,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH FROM full_date) AS month,
    EXTRACT(DAY FROM full_date) AS day,
    TO_CHAR(full_date, 'Day') AS day_of_week,
    CASE WHEN EXTRACT(DOW FROM full_date) IN (0, 6) THEN TRUE ELSE FALSE END AS is_weekend
FROM (
    SELECT TO_DATE(NULLIF("Purchase Date", ''), 'MM/DD/YY') AS full_date
    FROM public.retail_sales_original
    WHERE "Purchase Date" IS NOT NULL
    UNION
    SELECT TO_DATE(NULLIF("Ship Date", ''), 'MM/DD/YY') AS full_date
    FROM public.retail_sales_original
    WHERE "Ship Date" IS NOT NULL
    UNION
    SELECT TO_DATE(NULLIF("Return Date", ''), 'MM/DD/YY') AS full_date
    FROM public.retail_sales_original
    WHERE "Return Date" IS NOT NULL
) AS dates;

-- 8. Load the fact table
INSERT INTO fact_retail_sales (
    order_id,
    location_id,
    store_id,
    promotion_id,
    customer_id,
    salesperson_id,
    product_id,
    purchase_date_id,
    ship_date_id,
    return_date_id,
    returned,
    channel,
    priority,
    payment_method,
    quantity,
    unit_cost,
    unit_price,
    discount_amount,
    tax_amount,
    shipping_cost,
    gross_sales,
    net_sales,
    cogs,
    gross_profit
)
SELECT
    src."Order ID",
    loc.location_id,
    src."Store ID",
    src."Promotion ID",
    src."Customer ID",
    src."Salesperson ID",
    src."Product ID",
    EXTRACT(YEAR FROM TO_DATE(src."Purchase Date", 'MM/DD/YY')) * 10000
      + EXTRACT(MONTH FROM TO_DATE(src."Purchase Date", 'MM/DD/YY')) * 100
      + EXTRACT(DAY FROM TO_DATE(src."Purchase Date", 'MM/DD/YY')) AS purchase_date_id,
    CASE WHEN src."Ship Date" = '' THEN NULL ELSE
      EXTRACT(YEAR FROM TO_DATE(src."Ship Date", 'MM/DD/YY')) * 10000
      + EXTRACT(MONTH FROM TO_DATE(src."Ship Date", 'MM/DD/YY')) * 100
      + EXTRACT(DAY FROM TO_DATE(src."Ship Date", 'MM/DD/YY')) END AS ship_date_id,
    CASE WHEN src."Return Date" = '' THEN NULL ELSE
      EXTRACT(YEAR FROM TO_DATE(src."Return Date", 'MM/DD/YY')) * 10000
      + EXTRACT(MONTH FROM TO_DATE(src."Return Date", 'MM/DD/YY')) * 100
      + EXTRACT(DAY FROM TO_DATE(src."Return Date", 'MM/DD/YY')) END AS return_date_id,
    CASE WHEN src."Returned" = 'Yes' THEN TRUE ELSE FALSE END AS returned,
    src."Channel",
    src."Priority",
    src."Payment Method",
    src."Quantity",
    src."Unit Cost",
    src."Unit Price",
    src."Discount Amount",
    src."Tax Amount",
    src."Shipping Cost",
    src."Gross Sales",
    src."Net Sales",
    src."COGS",
    src."Gross Profit"
FROM public.retail_sales_original AS src
LEFT JOIN dim_location AS loc
  ON src."Continent" = loc.continent
 AND src."Country" = loc.country
 AND src."City" = loc.city
WHERE src."Order ID" IS NOT NULL;
