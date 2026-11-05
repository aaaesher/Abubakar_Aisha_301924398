-- Fictional sample records for Solar Mini-Grid Energy Distribution and Meter Monitoring System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."mini_grid" ("id", "name", "region", "commissioned_on", "active") VALUES (1, 'Sunrise Mini-Grid', 'North Valley', '2024-03-15', TRUE);
INSERT INTO portfolio."mini_grid" ("id", "name", "region", "commissioned_on", "active") VALUES (2, 'Riverbend Mini-Grid', 'East Ridge', '2024-06-01', TRUE);
INSERT INTO portfolio."meter" ("id", "grid_id", "serial_number", "installed_on", "status") VALUES (3, 1, 'MTR-SUN-001', '2024-03-20', 'active');
INSERT INTO portfolio."meter" ("id", "grid_id", "serial_number", "installed_on", "status") VALUES (4, 2, 'MTR-RIV-001', '2024-06-05', 'active');
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage") VALUES (5, 3, '2024-07-01T10:00:00Z', 125.5, 230.1);
INSERT INTO portfolio."energy_reading" ("id", "meter_id", "recorded_at", "kwh_total", "voltage") VALUES (6, 4, '2024-07-01T10:05:00+00:00', 82.75, NULL);
COMMIT;
