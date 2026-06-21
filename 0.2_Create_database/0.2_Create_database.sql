-- ============================================================
-- STEP 1: Create the staging and data warehouse databases.
-- Run this script first in PostgreSQL (for example with psql).
-- This prepares the target databases used by the rest of the pipeline.
-- ============================================================

CREATE DATABASE stg_retail_sales;
CREATE DATABASE dwh_retail_sales;

-- If a database already exists, drop it first or run the CREATE DATABASE command only for the missing database.
