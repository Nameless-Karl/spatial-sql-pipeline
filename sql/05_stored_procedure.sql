-- ============================================================
-- 05_stored_procedure.sql
-- Packages every pipeline step into a single callable unit.
--
-- Why a stored procedure matters:
--   Running five queries in sequence manually is a protocol,
--   not a pipeline. This procedure executes the full
--   extract → transform → load sequence in one call,
--   can be scheduled for automated refresh, and means
--   schema changes need to be made in one place only.
--
-- Limitation to be aware of:
--   No error handling. If one step fails mid-procedure,
--   tables are left in whatever state they were in.
--   A production version would add EXCEPTION blocks
--   or use an orchestration layer (Airflow, Prefect)
--   that handles retries and failure alerting.
--
-- Call with: CALL `thelook_ecommerce.sp_create_load_tables`();
-- ============================================================

CREATE OR REPLACE PROCEDURE `thelook_ecommerce.sp_create_load_tables`()
BEGIN

  -- Step 1: Define product orders fulfillment schema
  CREATE OR REPLACE TABLE `thelook_ecommerce.product_orders_fulfillment` (
    order_id               INT64,
    user_id                INT64,
    status                 STRING,
    product_id             INT64,
    created_at             TIMESTAMP,
    returned_at            TIMESTAMP,
    shipped_at             TIMESTAMP,
    delivered_at           TIMESTAMP,
    cost                   NUMERIC,
    sale_price             NUMERIC,
    retail_price           NUMERIC,
    category               STRING,
    name                   STRING,
    brand                  STRING,
    department             STRING,
    sku                    STRING,
    distribution_center_id INT64
  );

  -- Step 2: Load product orders fulfillment from public dataset
  -- Joins order line items to product metadata on product_id
  CREATE OR REPLACE TABLE thelook_ecommerce.product_orders_fulfillment AS
  SELECT
    items.*,
    products.id       AS product_id_products,
    products.name     AS product_name,
    products.category AS product_category
  FROM `bigquery-public-data.thelook_ecommerce.order_items` AS items
  JOIN `bigquery-public-data.thelook_ecommerce.products`    AS products
    ON items.product_id = products.id;

  -- Step 3: Define centers schema (with GEOGRAPHY column)
  CREATE OR REPLACE TABLE `thelook_ecommerce.centers` (
    id             INT64,
    name           STRING,
    latitude       FLOAT64,
    longitude      FLOAT64,
    point_location GEOGRAPHY
  );

  -- Step 4: Load centers with ST_GEOGPOINT transformation
  CREATE OR REPLACE TABLE `thelook_ecommerce.centers` AS
  SELECT
    id,
    name,
    latitude,
    longitude,
    ST_GEOGPOINT(dcenters.longitude, dcenters.latitude) AS point_location
  FROM `bigquery-public-data.thelook_ecommerce.distribution_centers` AS dcenters;

  -- Step 5: Define customers schema (with GEOGRAPHY column)
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

  -- Step 6: Load customers with ST_GEOGPOINT transformation
  CREATE OR REPLACE TABLE `thelook_ecommerce.customers` AS
  SELECT
    id,
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    traffic_source,
    created_at,
    latitude,
    longitude,
    ST_GEOGPOINT(users.longitude, users.latitude) AS point_location
  FROM `bigquery-public-data.thelook_ecommerce.users` AS users;

END;
