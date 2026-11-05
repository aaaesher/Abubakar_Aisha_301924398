# Solar Mini-Grid Energy Distribution and Meter Monitoring System — ER diagram

```mermaid
erDiagram
    direction LR
    mini_grid {
        bigint id PK
        text name
        text region
        date commissioned_on
        boolean active
    }
    meter {
        bigint id PK
        bigint grid_id FK
        text serial_number UK
        date installed_on
        text status
    }
    energy_reading {
        bigint id PK
        bigint meter_id FK
        timestamptz recorded_at
        numeric kwh_total
        numeric voltage "Optional"
    }
    mini_grid ||--o{ meter : "grid_id"
    meter ||--o{ energy_reading : "meter_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Abubakar_Aisha_301924398_ERDiagram.png)
