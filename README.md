# pg-dck
This are a mini project of SQL (Postgres) with embase domain in language and the logical use, considering data modeling, normalization/denormalization, data control and etc.

With objetive of use almost all of the core SQL like:
- DDL - Data Defintion Language
    - Targets (Database,Table, Constraints, View, Index)
    - Operations: CREATE,DELETE,UPDATE,RENAME.
- DML - Data Manipulation Language
    - Operations: INSERT, UPDATE, DELETE.
- DQL - Data Query Language
    - Operations: SELECT, FROM (JOIN, INNER JOIN, LEFT/RIGHT JOIN, FULL OUTER JOIN, CROSS JOIN)
     ,WHERE,GROUP BY, HAVING, ORDER BY, LIMIT.
- DCL - Data Control Language
    - Operations: GRANT/REVOKE.
- TCL - Transaction Control Language
    - Operations:  START/BEGIN, COMMIT, ROLLBACK.

- Operators (OP) & Functions 
    - OP Logical: AND,OR,NOT.
    - Numeric, String, Datetime, Null, etc.

- Data Types
    - String, Numeric, Datetime, JSON, Boolean, Float, Varchar, text, etc.

Will considering a case where a logistic company requested to develop a fleet management system, with objetive that have a database that allow track back vehicles, drivers, deliveries, 
maintenance and others data, need be roboust and eficient, with embase in SQL structure of good perfomance.

Considering the principal entities with their data:
- Vehicles
    - ID unique, model, manufacturer, year, payload capacity in tons.
- Drivers
    - ID unique, name, date birth, driver license number and the expiration date.
- Deliveries
    - ID unique, vehicle and driver associated, departure date, delivery date, origin, destiny and status (pending, in progress, delivered).
- Maintenance
    - ID unique, vehicle associated, maintenance date, maintenance type (preventive, corrective or predicted), description of maintenance and the final result.
- Logs of route
    - ID unique, delivery associated, date and hour, location (latitude and longitude) and status (status, in progress, end).

With files SQL:
- Schema
- Insertions
- Query