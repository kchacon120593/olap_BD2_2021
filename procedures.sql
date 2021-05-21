CREATE PROCEDURE emps.create_customer(
	_customer_id INT, 
	_store_id    INT,
	_first_name  VARCHAR(45),
	_last_name   VARCHAR(45),
	_email       VARCHAR(50),
	_address_id  INT)
LANGUAGE PLPGSQL AS $$
BEGIN
    PERFORM emps.create_customer_validate(_customer_id, _store_id, _first_name, _last_name, _address_id);
	PERFORM emps.create_customer_action(_customer_id, _store_id, _first_name, _last_name, _email, _address_id);
	COMMIT;
END;$$


CREATE PROCEDURE emps.create_rental(
	_inventory_id INT,
	_customer_id  INT,
	_staff_id     INT,
    _rental_date  TIMESTAMP)
LANGUAGE PLPGSQL AS $$
BEGIN
	PERFORM emps.create_rental_validate(_inventory_id, _customer_id, _staff_id);
	PERFORM emps.create_rental_action(_inventory_id, _customer_id, _staff_id, _rental_date);
	COMMIT;
END;$$


CREATE PROCEDURE emps.register_rental_return(
	_rental_id   INT,
	_return_date TIMESTAMP)
LANGUAGE PLPGSQL AS $$
BEGIN
	PERFORM emps.register_rental_return_validate(_rental_id);
	PERFORM emps.register_rental_return_action(_rental_id, _return_date);
	COMMIT;
END;$$


CREATE PROCEDURE admins.create_film(
	_title            VARCHAR(255),
	_description      TEXT,
	_release_year     INT,
	_language_id      INT,
	_rental_duration  INT,
	_rental_rate      NUMERIC(4, 2),
	_length           INT,
	_replacement_cost NUMERIC(5, 2),
	_rating           MPAA_RATING,
	_special_features TEXT[],
	_fulltext         TSVECTOR) 
LANGUAGE PLPGSQL AS $$
BEGIN
	PERFORM admins.create_film_validate(_title, _language_id, _rental_duration, _rental_rate, _replacement_cost, _rating, _fulltext);
	PERFORM admins.create_film_action(_title, _description, _release_year, _language_id, _rental_duration, _rental_rate, _length, _replacement_cost, _rating, _special_features, _fulltext);
	COMMIT;
END;$$


CREATE PROCEDURE admins.create_inventory(
	_film_id   INT,
	_store_id  INT) 
LANGUAGE PLPGSQL AS $$
BEGIN
	PERFORM admins.create_inventory_validate(_film_id, _store_id);
	PERFORM admins.create_inventory_action(_film_id, _store_id);
	COMMIT;
END;$$
