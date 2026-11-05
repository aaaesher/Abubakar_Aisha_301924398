-- Show related mini_grid, meter, energy_reading records (up to 20).
SELECT t0."id" AS "mini_grid_id",
       t0."name" AS "mini_grid_name",
       t1."id" AS "meter_id",
       t1."serial_number" AS "meter_serial_number",
       t2."id" AS "energy_reading_id",
       t2."recorded_at" AS "energy_reading_recorded_at"
FROM portfolio."mini_grid" t0
JOIN portfolio."meter" t1 ON t1."grid_id" = t0."id"
JOIN portfolio."energy_reading" t2 ON t2."meter_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "mini_grid_id",
       t0."name" AS "mini_grid_name",
       t1."id" AS "meter_id",
       t1."serial_number" AS "meter_serial_number",
       t2."id" AS "energy_reading_id",
       t2."recorded_at" AS "energy_reading_recorded_at"
FROM portfolio."mini_grid" t0
JOIN portfolio."meter" t1 ON t1."grid_id" = t0."id"
JOIN portfolio."energy_reading" t2 ON t2."meter_id" = t1."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find mini_grid records where name matches "Sunrise Mini-Grid" (up to 20).
SELECT * FROM portfolio."mini_grid"
WHERE "name" IS NOT DISTINCT FROM 'Sunrise Mini-Grid'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."mini_grid"
WHERE "name" IS NOT DISTINCT FROM 'Sunrise Mini-Grid'
ORDER BY "id"
LIMIT 20;

-- Count meter records for each grid_id (up to 20 groups).
SELECT "grid_id", count(*) AS record_count
FROM portfolio."meter"
GROUP BY "grid_id"
ORDER BY record_count DESC, "grid_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "grid_id", count(*) AS record_count
FROM portfolio."meter"
GROUP BY "grid_id"
ORDER BY record_count DESC, "grid_id" NULLS LAST
LIMIT 20;

-- Find energy_reading records where recorded_at matches "2024-07-01T10:00:00Z" (up to 20).
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2024-07-01T10:00:00Z'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2024-07-01T10:00:00Z'
ORDER BY "id"
LIMIT 20;
