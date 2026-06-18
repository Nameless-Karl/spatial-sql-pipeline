-- ============================================================
-- 03_load_customers.sql
-- Load customers from public dataset.
-- Same ST_GEOGPOINT transformation as centers table.
-- Both tables must use the same GEOGRAPHY type for
-- ST_DISTANCE to calculate correctly between them.
-- ============================================================

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
