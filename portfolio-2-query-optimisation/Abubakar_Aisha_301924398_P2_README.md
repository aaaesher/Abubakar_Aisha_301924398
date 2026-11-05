# Solar Mini-Grid Energy Distribution and Meter Monitoring System — SQL queries

## 1. Show related mini_grid, meter, energy_reading records (up to 20).

```sql
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
```

| mini_grid_id | mini_grid_name | meter_id | meter_serial_number | energy_reading_id | energy_reading_recorded_at |
| --- | --- | --- | --- | --- | --- |
| 1 | Sunrise Mini-Grid | 3 | MTR-SUN-001 | 5 | 2024-07-01T10:00:00+00:00 |
| 2 | Riverbend Mini-Grid | 4 | MTR-RIV-001 | 6 | 2024-07-01T10:05:00+00:00 |

## 2. Find mini_grid records where name matches "Sunrise Mini-Grid" (up to 20).

```sql
SELECT * FROM portfolio."mini_grid"
WHERE "name" IS NOT DISTINCT FROM 'Sunrise Mini-Grid'
ORDER BY "id"
LIMIT 20;
```

| id | name | region | commissioned_on | active |
| --- | --- | --- | --- | --- |
| 1 | Sunrise Mini-Grid | North Valley | 2024-03-15 | true |

## 3. Count meter records for each grid_id (up to 20 groups).

```sql
SELECT "grid_id", count(*) AS record_count
FROM portfolio."meter"
GROUP BY "grid_id"
ORDER BY record_count DESC, "grid_id" NULLS LAST
LIMIT 20;
```

| grid_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |

## 4. Find energy_reading records where recorded_at matches "2024-07-01T10:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."energy_reading"
WHERE "recorded_at" IS NOT DISTINCT FROM '2024-07-01T10:00:00Z'
ORDER BY "id"
LIMIT 20;
```

| id | meter_id | recorded_at | kwh_total | voltage |
| --- | --- | --- | --- | --- |
| 5 | 3 | 2024-07-01T10:00:00+00:00 | 125.5 | 230.1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.003 | 1.037, 0.997, 1.003 | Sort → Seq Scan | 112 |
| After index | 0.191 | 0.184, 0.191, 0.237 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.003 ms to 0.191 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=1.008..1.009 rows=20 loops=1)
  Seq Scan on energy_reading (actual time=0.014..0.975 rows=20 loops=1)
Planning Time: 0.313 ms
Execution Time: 1.037 ms
```

### Before index, run 2

```text
Sort (actual time=0.968..0.969 rows=20 loops=1)
  Seq Scan on energy_reading (actual time=0.014..0.934 rows=20 loops=1)
Planning Time: 0.329 ms
Execution Time: 0.997 ms
```

### Before index, run 3

```text
Sort (actual time=0.976..0.977 rows=20 loops=1)
  Seq Scan on energy_reading (actual time=0.014..0.944 rows=20 loops=1)
Planning Time: 0.304 ms
Execution Time: 1.003 ms
```

### After index, run 1

```text
Sort (actual time=0.131..0.133 rows=20 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.028..0.097 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=20 loops=1)
Planning Time: 0.554 ms
Execution Time: 0.184 ms
```

### After index, run 2

```text
Sort (actual time=0.142..0.143 rows=20 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.028..0.109 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.017 rows=20 loops=1)
Planning Time: 0.488 ms
Execution Time: 0.191 ms
```

### After index, run 3

```text
Sort (actual time=0.165..0.167 rows=20 loops=1)
  Bitmap Heap Scan on energy_reading (actual time=0.038..0.121 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.022..0.022 rows=20 loops=1)
Planning Time: 0.775 ms
Execution Time: 0.237 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Abubakar_Aisha_301924398_P2_Queries.sql, then Abubakar_Aisha_301924398_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Abubakar_Aisha_301924398_P2_QueryResults.png) · [Index comparison](screenshots/Abubakar_Aisha_301924398_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

