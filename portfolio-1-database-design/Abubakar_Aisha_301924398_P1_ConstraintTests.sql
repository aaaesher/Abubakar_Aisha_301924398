-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. reject grid pk. Expected: pk_mini_grid, SQLSTATE 23505.
INSERT INTO portfolio."mini_grid" ("id", "name", "region", "commissioned_on", "active")
VALUES (1, 'Test Grid', 'South Plain', '2024-07-02', TRUE);

-- 2. reject meter pk. Expected: pk_meter, SQLSTATE 23505.
INSERT INTO portfolio."meter" ("id", "grid_id", "serial_number", "installed_on", "status")
VALUES (3, 1, 'MTR-TEST-PK', '2024-07-02', 'active');

-- 3. reject reading pk. Expected: pk_energy_reading, SQLSTATE 23505.
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage")
VALUES (5, 3, '2024-07-01T11:00:00Z', 130, 230);

-- 4. reject meter serial unique. Expected: uq_meter_0, SQLSTATE 23505.
INSERT INTO portfolio."meter" ("id", "grid_id", "serial_number", "installed_on", "status")
VALUES (101, 1, 'MTR-SUN-001', '2024-07-02', 'active');

-- 5. reject reading unique. Expected: uq_energy_reading_0, SQLSTATE 23505.
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage")
VALUES (102, 3, '2024-07-01T10:00:00Z', 126, 230);

-- 6. reject meter grid fk. Expected: fk_meter_0, SQLSTATE 23503.
INSERT INTO portfolio."meter" ("id", "grid_id", "serial_number", "installed_on", "status")
VALUES (103, 999, 'MTR-TEST-FK', '2024-07-02', 'active');

-- 7. reject reading meter fk. Expected: fk_energy_reading_0, SQLSTATE 23503.
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage")
VALUES (104, 999, '2024-07-01T11:00:00Z', 127, 230);

-- 8. reject negative kwh. Expected: reading_kwh_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage")
VALUES (105, 3, '2024-07-01T12:00:00Z', -1, 230);

-- 9. reject grid name not null. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."mini_grid" ("id", "name", "region", "commissioned_on", "active")
VALUES (106, NULL, 'South Plain', '2024-07-02', TRUE);
