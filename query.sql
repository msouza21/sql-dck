--Testing the UPDATE and DELETE in logs_route table where id = 3
UPDATE logs_route SET log_date = '2023-01-10 22:45:30'
WHERE log_date = '2023-01-10 22:00:00' ;

SELECT log_date FROM logs_route WHERE id_delivery = 3;

-- Deleting this data 
DELETE FROM logs_route WHERE log_date = '2023-01-10 22:45:30';

-- Verifying the deletion
SELECT log_date FROM logs_route WHERE id_delivery = 3;

--Some info about vehicles with prevente maintenance in last 2 months
-- considering that last month as june of 2023
SELECT v.model, v.manufact, v.year, 
m.maintenance_date, m.description, m.type_maintenance
FROM vehicles v JOIN maintenance m 
ON v.id_vehicle = m.id_vehicle
WHERE m.type_maintenance = 'preventive'
AND m.maintenance_date >= (
    SELECT MAX(maintenance_date) FROM maintenance
) - INTERVAL '2 months';

-- In this case the type of JOIN not change any because not exists 
-- null data inserted, but in real cases, the joins: INNER being 
-- the same what JOIN, get what have intersection data between 2 
-- tables, the LEFT AND RIGHT speak from themselves considering 
-- 2 tables, CROSS being the max possible combination of data 
-- between 2 tables and the FULL OUTER get all from 2 tables

-- In this case above, was used a subquery to isole results from
-- small query to the principal query, a advanced filter/selection

-- Now try query license expiration with base date limit as 
-- '2024-04-01', using date 2024-07-01 as reference
SELECT name, license_number, license_exp FROM drivers
WHERE license_exp > '2024-04-01' 
AND license_exp < '2024-07-01';

-- Starting also more complex like functions that a one type more
-- simples of transaction for automatize data process, in this case
-- to show the route running from one driver, later query examples
CREATE OR REPLACE FUNCTION show_route(driver INTEGER)
RETURNS TABLE (driver_id INTEGER, name VARCHAR, origin VARCHAR, destiny VARCHAR)
AS $$
SELECT DISTINCT
    del.id_driver,
    d.name,
    del.origin,
    del.destiny
FROM deliveries del
LEFT JOIN drivers d ON del.id_driver = d.id_driver
WHERE del.id_driver = driver
$$ LANGUAGE sql;

SELECT * FROM show_route(2);
SELECT * FROM show_route(5);
SELECT * FROM show_route(9);


-- Now building a procedure that are more complex type of 
-- transaction for calculate the count number of maintenances
-- in some vehicle by the id of the vehicle
-- First is created a table for storing the result,
CREATE TABLE IF NOT EXISTS maintenance_count (
    id SERIAL PRIMARY KEY,
    id_vehicle INTEGER,
    vh_name VARCHAR(10),
    total_maintenances INTEGER,
    type_main VARCHAR(10)
);

-- The first thing is create the head of transaction, that's 
-- creating a function that have the name and parameters, used
-- and what we want to returned, in this case a other table

CREATE OR REPLACE PROCEDURE count_main (vehicle_id INTEGER)
AS $$
DECLARE
    vh_id INTEGER;
    total_main INTEGER;
    type_main VARCHAR(10);
    vh_name  VARCHAR(10);
BEGIN
    SELECT m.id_vehicle, COUNT(*), m.type_maintenance,
    v.model
    INTO vh_id, total_main, type_main, vh_name 
    FROM maintenance m JOIN vehicles v ON m.id_vehicle = v.id_vehicle
    WHERE m.id_vehicle = vehicle_id
    GROUP BY m.id_vehicle, v.model, m.type_maintenance;

    INSERT INTO maintenance_count (id_vehicle, vh_name ,total_maintenances, type_main)
    VALUES (vh_id, vh_name, total_main, type_main);
    
    RAISE NOTICE 'Dados inseridos do Veículo de ID: %', vh_id;
END;
$$ LANGUAGE plpgsql;
    
-- Some examples of use procedure and the query table complete
CALL count_main(1);
CALL count_main(2);
CALL count_main(3);
CALL count_main(4);
CALL count_main(5);

SELECT * FROM maintenance_count;


-- Now using Triggers for acts like sensors in tables
-- If a changeof route in deliveries tables, generate a log through
-- function trigged that store in other table the result

-- Creating a table to store changes for have a notion 
CREATE TABLE IF NOT EXISTS delivery_update (
    id_uplog SERIAL PRIMARY KEY,
    id_delivery INTEGER,
    old_origin VARCHAR(50),
    new_origin VARCHAR(50),
    old_destiny VARCHAR(50),
    new_destiny VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION delivery_logs()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO delivery_update(
        id_delivery,
        old_origin,
        new_origin,
        old_destiny,
        new_destiny
    ) VALUES (
        OLD.id_delivery,
        OLD.origin,
        NEW.origin,
        OLD.destiny,
        NEW.destiny
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER delivery_up
AFTER UPDATE ON deliveries
FOR EACH ROW
EXECUTE FUNCTION delivery_logs();

-- Example use and actioning the trigger and check if works
UPDATE deliveries 
SET origin = 'Columbus', destiny = 'Denver'
WHERE id_delivery = 18;

SELECT * FROM delivery_update;

-- In this case the trigger action the function and auto execute her

-- Transactions is works as what happens in functions/procedures, having
-- BEGIN
-- code actions here
-- can have ROLLBACK to allow return the data if erros happens
-- COMMIT;