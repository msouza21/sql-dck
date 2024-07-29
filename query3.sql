-- And by last, using more complex or advanced concepts and 
-- using others that not used before
-- CTEs or Common Table Expression, store the result expression query 
-- in table, like daily relatory of some data

-- In this case, we are in 07/2024, will considering the last 
-- data logs of delivery in 1 year interval

WITH last_year_logs AS (
    SELECT id_delivery, id_vehicle, delivery_date,
    status FROM deliveries
    WHERE delivery_date > CURRENT_DATE - INTERVAL '1 YEAR'
) 
SELECT id_delivery, id_vehicle, delivery_date, status 
FROM last_year_logs;

-- More precislly window function
SELECT id_vehicle, id_driver, COUNT(*) OVER (PARTITION BY 
id_vehicle ORDER BY id_driver) AS count_delivery
FROM deliveries LIMIT 20;

-- Not only in CTE's, but can hae 'HAVING' too in queries, like
SELECT id_delivery, COUNT(*) AS total_logs
FROM logs_route
GROUP BY id_delivery
HAVING COUNT(id_delivery) > 3
ORDER BY id_delivery;
-- In this case, all have 4 records, but if some have less,
-- not will are in result query

-- For understand what's happen behind the scenes
EXPLAIN ANALYZE 
SELECT id_vehicle, id_driver, COUNT(*) OVER (PARTITION BY 
id_vehicle ORDER BY id_driver) AS count_delivery
FROM deliveries LIMIT 20

-- Copy method to load massive data to another place, csv example
COPY (SELECT * FROM vehicles, drivers) TO '/pgdata/vehi_drivers.csv' DELIMITER ',' CSV HEADER;

-- Some commands to control acess in DB
-- GRANT: Delivery acess to (SELECT,UPDATE,INSERT,DELETE...)
-- ON DB, TABLE, or etc TO some user(s) or groups
-- REVOKE the same, but drop the acess/control