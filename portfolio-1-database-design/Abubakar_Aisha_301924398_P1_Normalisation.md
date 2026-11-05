# Solar Mini-Grid Energy Distribution and Meter Monitoring System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| meter_id | energy_reading records (list) |
| --- | --- |
| 3 | [5] |
| 4 | [6] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| energy_reading.id | energy_reading.meter_id | meter.id | meter.grid_id | meter.serial_number | mini_grid.id | mini_grid.name |
| --- | --- | --- | --- | --- | --- | --- |
| 5 | 3 | 3 | 1 | MTR-SUN-001 | 1 | Sunrise Mini-Grid |
| 6 | 4 | 4 | 2 | MTR-RIV-001 | 2 | Riverbend Mini-Grid |

Key: id.

## 2NF: depend on the whole key

energy_reading: meter_id is a proper part of candidate key (meter_id, recorded_at), and determines meter details.

## meter_example

| meter.id | meter.grid_id | meter.serial_number | mini_grid.id | mini_grid.name |
| --- | --- | --- | --- | --- |
| 3 | 1 | MTR-SUN-001 | 1 | Sunrise Mini-Grid |
| 4 | 2 | MTR-RIV-001 | 2 | Riverbend Mini-Grid |

## energy_reading_example

| energy_reading.id | energy_reading.meter_id |
| --- | --- |
| 5 | 3 |
| 6 | 4 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## mini_grid

| id | name | region | commissioned_on | active |
| --- | --- | --- | --- | --- |
| 1 | Sunrise Mini-Grid | North Valley | 2024-03-15 | true |
| 2 | Riverbend Mini-Grid | East Ridge | 2024-06-01 | true |

## meter

| id | grid_id | serial_number | installed_on | status |
| --- | --- | --- | --- | --- |
| 3 | 1 | MTR-SUN-001 | 2024-03-20 | active |
| 4 | 2 | MTR-RIV-001 | 2024-06-05 | active |

## energy_reading

| id | meter_id | recorded_at | kwh_total | voltage |
| --- | --- | --- | --- | --- |
| 5 | 3 | 2024-07-01T10:00:00+00:00 | 125.5 | 230.1 |
| 6 | 4 | 2024-07-01T10:05:00+00:00 | 82.75 | NULL |

## Dependencies

- mini_grid: (id) → name, region, commissioned_on, active
- meter: (id) → grid_id, serial_number, installed_on, status
- energy_reading: (id) → meter_id, recorded_at, kwh_total, voltage

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
