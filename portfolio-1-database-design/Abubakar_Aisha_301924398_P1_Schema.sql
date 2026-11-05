-- Solar Mini-Grid Energy Distribution and Meter Monitoring System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."mini_grid" (
  "id" bigint NOT NULL,
  "name" text NOT NULL,
  "region" text NOT NULL,
  "commissioned_on" date NOT NULL,
  "active" boolean NOT NULL,
  CONSTRAINT "pk_mini_grid" PRIMARY KEY ("id")
);
CREATE TABLE portfolio."meter" (
  "id" bigint NOT NULL,
  "grid_id" bigint NOT NULL,
  "serial_number" text NOT NULL,
  "installed_on" date NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_meter" PRIMARY KEY ("id"),
  CONSTRAINT "uq_meter_0" UNIQUE ("serial_number")
);
CREATE TABLE portfolio."energy_reading" (
  "id" bigint NOT NULL,
  "meter_id" bigint NOT NULL,
  "recorded_at" timestamptz NOT NULL,
  "kwh_total" numeric(18,2) NOT NULL,
  "voltage" numeric(18,2),
  CONSTRAINT "pk_energy_reading" PRIMARY KEY ("id"),
  CONSTRAINT "uq_energy_reading_0" UNIQUE ("meter_id", "recorded_at")
);
ALTER TABLE portfolio."meter" ADD CONSTRAINT "fk_meter_0" FOREIGN KEY ("grid_id") REFERENCES portfolio."mini_grid" ("id");
ALTER TABLE portfolio."energy_reading" ADD CONSTRAINT "fk_energy_reading_0" FOREIGN KEY ("meter_id") REFERENCES portfolio."meter" ("id");
ALTER TABLE portfolio."energy_reading" ADD CONSTRAINT "reading_kwh_nonnegative" CHECK ("kwh_total" >= 0);
COMMIT;
