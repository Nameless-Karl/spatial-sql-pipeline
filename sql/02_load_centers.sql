-- ============================================================
-- 02_load_centers.sql
-- Load distribution centers from public dataset.
-- Applies ST_GEOGPOINT to convert float coordinates into a
-- GEOGRAPHY type the database can reason about spatially.
--
-- Argument order: ST_GEOGPOINT(longitude, latitude)
-- Matches the (x, y) coordinate convention.
-- Reversing this produces no error but calculates wrong distances.
-- ============================================================

CREATE OR REPLACE TABLE `thelook_ecommerce.centers` AS
SELECT
  id,
  name,
  latitude,
  longitude,
  ST_GEOGPOINT(dcenters.longitude, dcenters.latitude) AS point_location
FROM `bigquery-public-data.thelook_ecommerce.distribution_centers` AS dcenters;
