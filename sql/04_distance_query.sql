-- ============================================================
-- 04_distance_query.sql
-- Calculate the minimum distance from each customer to
-- their nearest distribution center.
--
-- How the scalar subquery works:
--   For each row in the outer query (one customer),
--   the inner query scans every center, calculates
--   ST_DISTANCE to each, and returns only the MIN.
--   Result: one row per customer, one distance value.
--
-- ST_DISTANCE returns meters. Dividing by 1000 gives km.
--
-- Note: ST_DISTANCE calculates geodesic distance —
-- the shortest path on the earth's surface.
-- This is geometric distance, not road distance.
-- For logistics routing decisions, a routing API
-- (travel time, road distance) provides more accurate input.
-- ============================================================

SELECT
  customers.id AS customer_id,
  (
    SELECT MIN(ST_DISTANCE(centers.point_location, customers.point_location)) / 1000
    FROM `thelook_ecommerce.centers` AS centers
  ) AS distance_to_closest_center
FROM `thelook_ecommerce.customers` AS customers;
