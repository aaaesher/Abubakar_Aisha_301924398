# Portfolio 1 — Database Design and Modelling

I organised the data into mini_grid, meter, energy_reading. The design document explains the fields, keys, relationships and business rules. The normalisation document shows the sample tables at 1NF, 2NF and 3NF.

## Database checks

| Table | Rows |
| --- | --- |
| mini_grid | 2 |
| meter | 2 |
| energy_reading | 2 |

The 9 invalid inserts were rejected at their expected constraints, and the valid sample rows remained unchanged.

## Files

- [Design](Abubakar_Aisha_301924398_P1_Design.md)
- [ER diagram](Abubakar_Aisha_301924398_P1_ERDiagram.md)
- [Normalisation](Abubakar_Aisha_301924398_P1_Normalisation.md)
- [Schema](Abubakar_Aisha_301924398_P1_Schema.sql)
- [Sample data](Abubakar_Aisha_301924398_P1_SampleData.sql)
- [Constraint tests](Abubakar_Aisha_301924398_P1_ConstraintTests.sql)
- [Table and constraint evidence](screenshots/Abubakar_Aisha_301924398_P1_DatabaseResults.png)

## Run the SQL

Create a fresh PostgreSQL database. Run the schema first, then the sample data. Run the deliberately invalid statements in ConstraintTests.sql individually outside a transaction; each is expected to produce an error.

## References

- [PostgreSQL — constraints](https://www.postgresql.org/docs/17/ddl-constraints.html)

