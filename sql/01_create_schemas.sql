-- ============================================================
-- 01_create_schemas.sql
-- Define empty table schemas before data ingestion.
-- Run this first to establish structure before loading data.
-- ============================================================

-- Product orders fulfillment table
-- Joins order line items with product metadata
CREATE OR REPLACE TABLE `thelook_ecommerce.product_orders_fulfillment` (
  order_id              INT64,
  user_id               INT64,
  status                STRING,
  product_id            INT64,
  created_at            TIMESTAMP,
  returned_at           TIMESTAMP,
  shipped_at            TIMESTAMP,
  delivered_at          TIMESTAMP,
  cost                  NUMERIC,
  sale_price            NUMERIC,
  retail_price          NUMERIC,
  category              STRING,
  name                  STRING,
  brand                 STRING,
  department            STRING,
  sku                   STRING,
  distribution_center_id INT64
);

-- Distribution centers table
-- Will receive a GEOGRAPHY point column after ingestion
CREATE OR REPLACE TABLE `thelook_ecommerce.centers` (
  id             INT64,
  name           STRING,
  latitude       FLOAT64,
  longitude      FLOAT64,
  point_location GEOGRAPHY
);

-- Customers table
-- Will receive a GEOGRAPHY point column after ingestion
CREATE OR REPLACE TABLE `thelook_ecommerce.customers` (
  id              INT64,
  first_name      STRING,
  last_name       STRING,
  email           STRING,
  age             INT64,
  gender          STRING,
  state           STRING,
  street_address  STRING,
  postal_code     STRING,
  city            STRING,
  country         STRING,
  traffic_source  STRING,
  created_at      TIMESTAMP,
  latitude        FLOAT64,
  longitude       FLOAT64,
  point_location  GEOGRAPHY
);
