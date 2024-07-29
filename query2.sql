-- Now continuing the queries training, testing others things of SQL like

-- Aggregations functions, where do operations in set of values 
-- to return unique value, like AVG, SUM, etc.
-- If we want to have a medium of payload capacity of all vehicles,
-- and we can find the maximum and minimum payload capacity 
SELECT MIN(capacity) AS min_capacity, MAX(capacity) AS max_capacity,
ROUND(AVG(capacity),2) AS avg_capacity 
FROM vehicles;

-- Or, and all vehicles with payload capacity more than medium
SELECT id_vehicle, model, capacity FROM vehicles 
WHERE capacity > (SELECT ROUND(AVG(capacity),2)
FROM vehicles)
ORDER BY id_vehicle;

-- More agg functions like:
-- SUM: Sum of values
SELECT SUM(capacity) AS total_capacity FROM vehicles;
-- COUNT: Count of non-null values
SELECT COUNT(*) AS total_drivers 
FROM drivers;
-- ARRAY_AGG: Group values into an array, like: [55,20,34]
SELECT ARRAY_AGG(capacity) FROM vehicles;
-- STRING_AGG: Concatenate values into a string with a delimiter
-- like (name,',') where concat the names with ',' delimiter
SELECT STRING_AGG(name, ',') AS names FROM drivers;

--Others...
-- JSON_AGG: Aggregate values into a JSON array
-- BOOL_AND: True if all boolean values are true
-- BOOL_OR: True if any boolean value is true
-- CORR: Correlation between two columns
-- COVAR_POP: Population covariance between two columns
-- COVAR_SAMP: Sample covariance between two columns
-- REGR_SLOPE: Slope of the linear regression
-- REGR_INTERCEPT: Intercept of the linear regression
-- REGR_COUNT: Count of pairs of non-null values
-- REGR_R2: Coefficient of determination (R²) of the regression
-- REGR_AVGX: Average of the x values used in the regression
-- REGR_AVGY: Average of the y values used in the regression


-- Window Functions where can do calcs a set of table rows
-- These functions are applied to a partition of the result set and can return a 
-- value for each row

-- ROW_NUMBER: Assigns a unique number to each row in a result set, starting at 1
SELECT id_delivery, delivery_date, ROW_NUMBER() OVER (ORDER BY delivery_date) 
AS row_nmb FROM deliveries;

-- RANK: Assigns a rank to each row within the partition of a result set, 
-- with gaps in the rank when there are ties,also like 1-2-5-8 if have tie
SELECT id_delivery, status, RANK() OVER (ORDER BY id_delivery)
AS rank_nmb FROM logs_route;

-- DENSE_RANK: Assigns a rank to each row within the partition of a result set, 
-- without gaps in the rank when there are ties, laso like 1-2-3-4 if have tie
SELECT id_delivery, status, DENSE_RANK() OVER (ORDER BY id_delivery)
AS dense_rank FROM logs_route;

-- NTILE: Divides the result set into a specified number of roughly equal parts and 
-- assigns a number to each row to indicate the part to which it belongs, if I have
-- 80 rows in a table and use ntile(4) will be 4 groups of 20 rows with 1 rank for group
SELECT id_delivery, delivery_date, NTILE(4) OVER (ORDER BY delivery_date)
AS ntiles FROM deliveries;

-- LAG: Provides access to a row at a specified physical offset that comes before 
-- the current row, if current row is 2, acess to 1 row, else NULL
SELECT id_vehicle, type_maintenance, LAG(type_maintenance, 1) OVER (ORDER BY id_vehicle)
AS previous_maintenance FROM maintenance;

-- LEAD: Provides access to a row at a specified physical offset that comes after the 
-- current row, if current row is 20, acess to 21 row,else NULL
SELECT id_vehicle, type_maintenance, LEAD(type_maintenance,1) OVER (ORDER BY id_vehicle)
AS next_maintenance FROM maintenance;

-- FIRST_VALUE: Returns the first value in an ordered set of values
-- in this case return the first value 
SELECT id_delivery, log_date, status, FIRST_VALUE(log_date) OVER (ORDER BY id_delivery)
AS first_log FROM logs_route;

-- LAST_VALUE: Returns the last value in an ordered set of values
-- in this case are the same because not have much example data 
SELECT id_delivery, log_date, status, LAST_VALUE(log_date) OVER (ORDER BY id_delivery)
AS last_log FROM logs_route;

-- NTH_VALUE: Returns the value of the nth row in an ordered set of values
-- can be the third, seven, or eight row, any number
SELECT id_driver, name, NTH_VALUE(id_driver,4) OVER (ORDER BY id_driver) 
AS tile FROM drivers;

-- Can be used string manipulation as example name complete vehicle, 
-- where CONCAT join the name in one string
SELECT CONCAT(manufact,' ',model) AS vehicle_name
FROM vehicles;

-- Using Date functions for like find the number maintenances by month,
-- where TO_CHAR allow extract DATE/TIME for string formated
-- DATE_TRUNC allow reduce the date of YYYY-MM-DD:HH:MM:SS to
-- YYYY-MM-DD, where was used 'month', can be used too: 'year,
-- 'day', 'hour', 'minute', 'second and by last, 'MM' get the mont
-- wanted in ORDER BY correctly formatted
SELECT TO_CHAR(DATE_TRUNC('month', maintenance_date), 'Month') AS month, COUNT(*) AS total_main
FROM maintenance
GROUP BY DATE_TRUNC('month', maintenance_date)
ORDER BY TO_CHAR(DATE_TRUNC('month', maintenance_date),'MM');

-- Can be used CASE with WHEN to filter data more dynamically
-- as example check the sucess or in progress delivery with base logs route table
SELECT id_delivery, 
    CASE 
        WHEN status = 'en route' THEN 'In progress delivery'
        WHEN status = 'delivered' THEN 'Sucessful delivery'
        ELSE 'Not started delivery'
    END AS check_delivery
FROM logs_route
ORDER BY id_delivery;

-- Views and Materialized Views can be used to create virtual tables to protect acess
-- from original table, where the key diference is that views don't store physically 
-- the data, whilw materialized store, some 2 examples down

-- In this I protect the birth and license infos about the drivers
CREATE OR REPLACE VIEW drivers_info AS SELECT
id_driver, name FROM drivers;

SELECT * FROM drivers_info;

-- Like what works in Views, but now I store this result 
CREATE MATERIALIZED VIEW maintenance_info AS SELECT
id_vehicle, description, type_maintenance, result 
FROM maintenance
ORDER BY id_vehicle;

SELECT * FROM maintenance_info;

-- Indexes, allowing to place addresses to data for better performance
-- in queries, reducing the time to database to find results
-- having some types like: 
-- B-Tree(standard) where the data is stored in tree ballanced
-- Hash: Key-Value to store pair/equialent data
-- GIN: Data type complex like arrays, JSON and full-text
-- GiST: Data type more complex like geo, polygon and etc
-- BRIN: Data stored sorted blocks sequentially, like logs tables

-- Using now as example Btree and Hash
-- Where creating a example index for status of log route
CREATE INDEX status_route ON 
logs_route(status);

-- Using  Hash to filter exaclty what is asked like using 'WHERE ='
CREATE INDEX status_delivery ON deliveries(status);