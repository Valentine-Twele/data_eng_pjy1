-- ============================================================
-- STEP 3: Create the star schema tables for the data warehouse.
-- Run this script in the dwh_retail_sales database after step 1 and step 2.
-- This creates dimension tables first, then the fact table structure.
-- ============================================================

-- Dimension: Location
CREATE TABLE IF NOT EXISTS dim_location (
    location_id SERIAL PRIMARY KEY,
    continent   VARCHAR(100) NOT NULL,
    country     VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL
);

-- Dimension: Store
CREATE TABLE IF NOT EXISTS dim_store (
    store_id   VARCHAR(20) PRIMARY KEY,
    store_name VARCHAR(200) NOT NULL,
    store_type VARCHAR(100)
);

-- Dimension: Promotion
CREATE TABLE IF NOT EXISTS dim_promotion (
    promotion_id   VARCHAR(50) PRIMARY KEY,
    promotion_name VARCHAR(200) NOT NULL
);

-- Dimension: Date
CREATE TABLE IF NOT EXISTS dim_date (
    date_id     INT PRIMARY KEY,
    full_date   DATE NOT NULL,
    year        INT NOT NULL,
    quarter     INT NOT NULL,
    month       INT NOT NULL,
    day         INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    is_weekend  BOOLEAN NOT NULL
);

-- Dimension: Product
CREATE TABLE IF NOT EXISTS dim_product (
    product_id   VARCHAR(20) PRIMARY KEY,
    sku          VARCHAR(50) NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    category     VARCHAR(100),
    subcategory  VARCHAR(100),
    brand        VARCHAR(100)
);

-- Dimension: Salesperson
CREATE TABLE IF NOT EXISTS dim_salesperson (
    salesperson_id         VARCHAR(20) PRIMARY KEY,
    salesperson_department VARCHAR(100) NOT NULL
);

-- Dimension: Customer
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id      VARCHAR(20) PRIMARY KEY,
    customer_segment VARCHAR(100),
    loyalty_tier     VARCHAR(50)
);

-- Fact: Retail Sales
CREATE TABLE IF NOT EXISTS fact_retail_sales (
    order_id         VARCHAR(20) PRIMARY KEY,
    location_id      INT NOT NULL REFERENCES dim_location(location_id),
    store_id         VARCHAR(20) NOT NULL REFERENCES dim_store(store_id),
    promotion_id     VARCHAR(50) REFERENCES dim_promotion(promotion_id),
    customer_id      VARCHAR(20) NOT NULL REFERENCES dim_customer(customer_id),
    salesperson_id   VARCHAR(20) NOT NULL REFERENCES dim_salesperson(salesperson_id),
    product_id       VARCHAR(20) NOT NULL REFERENCES dim_product(product_id),
    purchase_date_id INT NOT NULL REFERENCES dim_date(date_id),
    ship_date_id     INT REFERENCES dim_date(date_id),
    return_date_id   INT REFERENCES dim_date(date_id),
    returned         BOOLEAN NOT NULL,
    channel          VARCHAR(100),
    priority         VARCHAR(100),
    payment_method   VARCHAR(100),
    quantity         INT NOT NULL,
    unit_cost        NUMERIC(12,2) NOT NULL,
    unit_price       NUMERIC(12,2) NOT NULL,
    discount_amount  NUMERIC(12,2) NOT NULL,
    tax_amount       NUMERIC(12,2) NOT NULL,
    shipping_cost    NUMERIC(12,2) NOT NULL,
    gross_sales      NUMERIC(14,2) NOT NULL,
    net_sales        NUMERIC(14,2) NOT NULL,
    cogs             NUMERIC(14,2) NOT NULL,
    gross_profit     NUMERIC(14,2) NOT NULL
);
