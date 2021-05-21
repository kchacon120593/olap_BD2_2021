CREATE SCHEMA emps;  -- schemas
CREATE SCHEMA admins;

CREATE ROLE EMP;  -- roles
GRANT USAGE ON SCHEMA emps TO EMP;

CREATE ROLE ADMIN;
GRANT USAGE ON SCHEMA admins TO ADMIN;
GRANT EMP TO ADMIN;

CREATE USER empleado1 WITH LOGIN PASSWORD 'empleado1' IN GROUP EMP;  -- login users with role
CREATE USER administrador1 WITH LOGIN PASSWORD 'administrador1' IN GROUP ADMIN;


create user video NOLOGIN;  -- group role owner of all tables, procedures and functions
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO video;  -- grant usage on tables auto increment sequences 

ALTER TABLE Actor OWNER TO video;  -- set video as tables owner
ALTER TABLE Address OWNER TO video; 
ALTER TABLE Category OWNER TO video; 
ALTER TABLE City OWNER TO video; 
ALTER TABLE Country OWNER TO video; 
ALTER TABLE Customer OWNER TO video; 
ALTER TABLE Film OWNER TO video; 
ALTER TABLE Film_actor OWNER TO video; 
ALTER TABLE Film_category OWNER TO video; 
ALTER TABLE Inventory OWNER TO video; 
ALTER TABLE Language OWNER TO video; 
ALTER TABLE Payment OWNER TO video; 
ALTER TABLE Rental OWNER TO video; 
ALTER TABLE Staff OWNER TO video; 
ALTER TABLE Store OWNER TO video; 

ALTER PROCEDURE emps.create_customer OWNER TO video; -- set video as procedures owner
ALTER PROCEDURE emps.create_rental OWNER TO video; 
ALTER PROCEDURE emps.register_rental_return OWNER TO video; 
ALTER PROCEDURE emps.register_rental_return OWNER TO video; 
ALTER PROCEDURE admins.create_film OWNER TO video; 
ALTER PROCEDURE admins.create_inventory OWNER TO video; 

ALTER FUNCTION emps.create_customer_validate OWNER TO video;  -- set video as functions owner
ALTER FUNCTION emps.create_customer_action OWNER TO video;
ALTER FUNCTION emps.create_rental_validate OWNER TO video;
ALTER FUNCTION emps.create_rental_action OWNER TO video;
ALTER FUNCTION emps.register_rental_return_validate OWNER TO video;
ALTER FUNCTION emps.register_rental_return_action OWNER TO video;
ALTER FUNCTION emps.read_films OWNER TO video;
ALTER FUNCTION admins.create_film_validate OWNER TO video;
ALTER FUNCTION admins.create_film_action OWNER TO video;
ALTER FUNCTION admins.create_inventory_validate OWNER TO video;
ALTER FUNCTION admins.create_inventory_action OWNER TO video;
