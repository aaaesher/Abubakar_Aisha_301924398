# Solar Mini-Grid Energy Distribution and Meter Monitoring System — database design

My case study records mini_grid, meter, energy_reading.

## Users

- Mini-grid operators
- Monitoring analysts

## Main operations

- Register a meter to a mini-grid using its unique serial number.
- Record timestamped energy readings and review meter status.
- Inspect readings by grid and time range, and summarize energy by grid and day.

## Entities

| Entity | Information stored |
| --- | --- |
| mini_grid | A solar mini-grid served by the monitoring system. |
| meter | A uniquely identified meter installed within one mini-grid. |
| energy_reading | A timestamped cumulative energy and optional voltage observation from one meter. |

## mini_grid

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| region | TEXT |  | Yes |
| commissioned_on | DATE |  | Yes |
| active | BOOLEAN |  | Yes |


## meter

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| grid_id | BIGINT | FK | Yes |
| serial_number | TEXT | Unique | Yes |
| installed_on | DATE |  | Yes |
| status | TEXT |  | Yes |
- grid_id → mini_grid.id
- Unique key: (serial_number).

## energy_reading

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| meter_id | BIGINT | FK | Yes |
| recorded_at | TIMESTAMPTZ |  | Yes |
| kwh_total | NUMERIC(18,2) |  | Yes |
| voltage | NUMERIC(18,2) |  | No |
- meter_id → meter.id
- Unique key: (meter_id, recorded_at).

## Relationships and business rules

- A meter serial number identifies at most one registered meter.
- Every meter references an existing mini-grid through grid_id.
- Every energy reading references an existing meter through meter_id.
- A meter has at most one reading at a given timestamp.
- The cumulative kWh reading must be zero or greater.

## Assumptions

- Each meter belongs to exactly one mini-grid, and each reading belongs to exactly one meter.
- Entity IDs are allocated from one global namespace so IDs are unique across all three tables.
- Energy readings contain a cumulative nonnegative kWh value; voltage is optional and measured in volts.
- Worked normalization example: energy_reading has id, meter_id, recorded_at, kwh_total, and optional voltage. Its key is id, and meter_id references meter. Meter serial_number and grid_id remain in meter, avoiding repeated ancestor roles or duplicated meter and grid attributes in readings.
- The benchmark uses synthetic rows only; it compares equivalent timestamp-range filters with and without the proposed index and records repeated-run median latency without assuming an outcome.

