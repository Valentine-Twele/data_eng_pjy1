# Retail Sales Data Engineering Project

## Project Overview
This repository implements a simple retail analytics pipeline using a star schema model. The raw dataset is stored in `0.1_raw_data/retail_sales_original.csv`. SQL scripts in the project create databases, define the star schema, run exploratory data analysis, and load data into a dimensional model.

## Folder Structure
- `0.1_raw_data/`: Raw CSV dataset.
- `0.2_Create_database/`: Scripts to create the staging and data warehouse databases.
- `0.3_Eda_Script/`: Exploratory SQL script for data profiling and validation.
- `0.4_Create_Tables/`: Star schema DDL definitions for dimensions and fact table.
- `0.5_Insert_data/`: ETL insert script that populates dimensions and the fact table.

## Recommended Workflow
1. Create the target databases using:
   ```sql
   \i 0.2_Create_database/0.2_Create_database.sql
   ```
2. Load the raw CSV into a staging table named `public.retail_sales_original` in the appropriate database before running ETL.
3. Run the EDA script to validate the raw data:
   ```sql
   \i 0.3_Eda_Script/0.3_eda_script.sql
   ```
4. Create the star schema tables in the data warehouse database:
   ```sql
   \i 0.4_Create_Tables/0.4_Create_table.sql
   ```
5. Load dimension tables and then the fact table:
   ```sql
   \i 0.5_Insert_data/0.5_Insert_data.sql
   ```

## Star Schema Model
The dimensional model is based on a retail sales fact table and supporting dimensions.

### Fact Table
`fact_retail_sales`
- `order_id` (PK)
- `location_id` -> `dim_location`
- `store_id` -> `dim_store`
- `promotion_id` -> `dim_promotion`
- `customer_id` -> `dim_customer`
- `salesperson_id` -> `dim_salesperson`
- `product_id` -> `dim_product`
- `purchase_date_id`, `ship_date_id`, `return_date_id` -> `dim_date`
- metrics: `quantity`, `unit_cost`, `unit_price`, `discount_amount`, `tax_amount`, `shipping_cost`, `gross_sales`, `net_sales`, `cogs`, `gross_profit`
- additional attributes: `returned`, `channel`, `priority`, `payment_method`

### Dimension Tables
`dim_location`
- `location_id` (PK)
- `continent`
- `country`
- `city`

`dim_store`
- `store_id` (PK)
- `store_name`
- `store_type`

`dim_promotion`
- `promotion_id` (PK)
- `promotion_name`

`dim_customer`
- `customer_id` (PK)
- `customer_segment`
- `loyalty_tier`

`dim_salesperson`
- `salesperson_id` (PK)
- `salesperson_department`

`dim_product`
- `product_id` (PK)
- `sku`
- `product_name`
- `category`
- `subcategory`
- `brand`

`dim_date`
- `date_id` (PK, `YYYYMMDD` integer surrogate key)
- `full_date`
- `year`
- `quarter`
- `month`
- `day`
- `day_of_week`
- `is_weekend`

## Notes and Best Practices
- Use quoted identifiers only for source column names that contain spaces or special characters.
- Use `VARCHAR` for string keys such as `S019`, `P0059`, and `C00530` instead of integer types.
- Load dimension tables before the fact table to preserve referential integrity.
- Use `ON CONFLICT` to avoid duplicate inserts in dimensions when running the pipeline multiple times.
- Normalize repeated values into dimensions and keep numeric measures in the fact table.

## Additional Recommendations
- If you plan to persist this into a production pipeline, create a staging table and load the CSV using `COPY` or `pg_bulkload`.
- Add constraints and data quality checks at the database layer to avoid invalid rows.
- Consider building views for business-friendly analytics, such as `vw_retail_sales_summary` or `vw_sales_by_store`.
