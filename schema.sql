CREATE TABLE IF NOT EXISTS vehicles (
    id_vehicle SERIAL PRIMARY KEY,
    model VARCHAR(255) NOT NULL,
    manufact VARCHAR(255) NOT NULL,
    year SMALLINT NOT NULL,
    capacity DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS drivers (
    id_driver SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    birthdate DATE NOT NULL,
    license_number VARCHAR(255) UNIQUE NOT NULL,
    license_exp DATE UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS deliveries (
    id_delivery SERIAL PRIMARY KEY,
    id_vehicle INTEGER REFERENCES vehicles(id_vehicle),
    id_driver INTEGER REFERENCES drivers(id_driver),
    origin VARCHAR(255) NOT NULL,
    destiny VARCHAR(255) NOT NULL,
    depart_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    status VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS maintenance (
    id_maintenance SERIAL PRIMARY KEY,
    id_vehicle INTEGER REFERENCES vehicles(id_vehicle),
    description TEXT NOT NULL,
    maintenance_date DATE NOT NULL,
    type_maintenance VARCHAR(255) NOT NULL,
    result VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS logs_route (
    id_log SERIAL PRIMARY KEY,
    id_delivery INTEGER REFERENCES deliveries(id_delivery),
    log_date TIMESTAMP NOT NULL,
    lati_long DECIMAL(10,6) [] NOT NULL,
    status VARCHAR(255) NOT NULL
);