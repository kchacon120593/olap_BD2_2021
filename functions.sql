CREATE FUNCTION emps.create_customer_validate(
	_customer_id INT, 
	_store_id    INT,
	_first_name  VARCHAR(45),
	_last_name   VARCHAR(45),
	_address_id  INT) 
RETURNS VOID LANGUAGE PLPGSQL SECURITY DEFINER AS $$
BEGIN
	IF ((_customer_id IS NULL) OR (_store_id IS NULL) OR (COALESCE(TRIM(_first_name),'') = '') OR 
		(COALESCE(TRIM(_last_name),'') = '') OR (_address_id IS NULL)) THEN
		RAISE 'Error: Null parameter, only email is optional.';

	ELSIF EXISTS(SELECT * FROM Customer WHERE customer_id = _customer_id) THEN
		RAISE 'Error: Customer already exists.';

	ELSIF NOT EXISTS(SELECT * FROM Store WHERE store_id = _store_id) THEN
		RAISE 'Error: Store doesn''t exists.';

    ELSIF NOT EXISTS(SELECT * FROM Address WHERE address_id = _address_id) THEN
		RAISE 'Error: Address doesn''t exists.';
	END IF;
END;$$;


CREATE FUNCTION emps.create_customer_action(
	_customer_id INT, 
	_store_id    INT,
	_first_name  VARCHAR(45),
	_last_name   VARCHAR(45),
	_email       VARCHAR(50),
	_address_id  INT) 
RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
	INSERT INTO Customer (customer_id, store_id, first_name, last_name, email, address_id, active) VALUES
	(_customer_id, _store_id, _first_name, _last_name, _email, _address_id, 1);
$$;


CREATE FUNCTION emps.create_rental_validate(
	_inventory_id INT,
	_customer_id  INT,
	_staff_id     INT) 
RETURNS VOID LANGUAGE PLPGSQL SECURITY DEFINER AS $$
BEGIN
	IF ((_inventory_id IS NULL) OR (_customer_id IS NULL) OR (_staff_id IS NULL)) THEN
		RAISE 'Error: Null parameter, only rental date is optional.';
		
    ELSIF NOT EXISTS(SELECT * FROM Inventory WHERE inventory_id = _inventory_id) THEN
		RAISE 'Error: Inventory doesn''t exists.';

	ELSIF NOT EXISTS(SELECT * FROM Customer WHERE customer_id = _customer_id) THEN
		RAISE 'Error: Customer doesn''t exists.';
    
    ELSIF NOT EXISTS(SELECT * FROM Staff WHERE staff_id = _staff_id) THEN
		RAISE 'Error: Staff doesn''t exists.';
	END IF;
END;$$;


CREATE FUNCTION emps.create_rental_action(
	_inventory_id INT,
	_customer_id  INT,
	_staff_id     INT,
    _rental_date  TIMESTAMP) 
RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
	INSERT INTO Rental (rental_date, inventory_id, customer_id, staff_id) VALUES
	(COALESCE(_rental_date, NOW()), _inventory_id, _customer_id, _staff_id);
$$;


CREATE FUNCTION emps.register_rental_return_validate(
	_rental_id   INT) 
RETURNS VOID LANGUAGE PLPGSQL SECURITY DEFINER AS $$
BEGIN
	IF (_rental_id IS NULL) THEN
		RAISE 'Error: Null rental id parameter.';
		
    ELSIF NOT EXISTS(SELECT * FROM Rental WHERE rental_id = _rental_id) THEN
		RAISE 'Error: Rental doesn''t exists.';
	END IF;
END;$$;


CREATE FUNCTION emps.register_rental_return_action(
	_rental_id   INT,
	_return_date TIMESTAMP) 
RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
	UPDATE Rental 
	SET return_date = COALESCE(_return_date, NOW())
	WHERE rental_id = _rental_id;
$$;


CREATE FUNCTION emps.read_films(
	_film_id          INT,
	_title            VARCHAR(255),
	_description      TEXT,
	_release_year     INT,
	_language_id      INT,
	_rental_duration  INT,
	_rental_rate      NUMERIC(4, 2),
	_length           INT,
	_replacement_cost NUMERIC(5, 2),
	_rating           MPAA_RATING,
	_special_features TEXT[]) 
RETURNS SETOF Film LANGUAGE SQL SECURITY DEFINER AS $$
	SELECT *
	FROM Film
	WHERE film_id = COALESCE(_film_id, film_id)
		AND title = COALESCE(_title, title)
		AND description = COALESCE(_description, description)
		AND release_year = COALESCE(_release_year, release_year)
		AND language_id = COALESCE(_language_id, language_id)
		AND rental_duration = COALESCE(_rental_duration, rental_duration)
		AND rental_rate = COALESCE(_rental_rate, rental_rate)
		AND length = COALESCE(_length, length)
		AND replacement_cost = COALESCE(_replacement_cost, replacement_cost)
		AND rating = COALESCE(_rating, rating)
		AND special_features = COALESCE(_special_features, special_features)
$$;


CREATE FUNCTION admins.create_film_validate(
	_title            VARCHAR(255),
	_language_id      INT,
	_rental_duration  INT,
	_rental_rate      NUMERIC(4, 2),
	_replacement_cost NUMERIC(5, 2),
	_rating           MPAA_RATING,
	_fulltext         TSVECTOR) 
RETURNS VOID LANGUAGE PLPGSQL SECURITY DEFINER AS $$
BEGIN
	IF ((COALESCE(TRIM(_title),'') = '') OR (_language_id IS NULL) OR
		(_rental_duration IS NULL) OR (_rental_rate IS NULL) OR 
		(_replacement_cost IS NULL) OR (_rating IS NULL) OR
		(_fulltext IS NULL)) THEN
		RAISE 'Error: Null parameter, only description, release year, length and special features can be null.';
		
    ELSIF NOT EXISTS(SELECT * FROM Language WHERE language_id = _language_id) THEN
		RAISE 'Error: Language doesn''t exists.';
	END IF;
END;$$;


CREATE FUNCTION admins.create_film_action(
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
RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
	INSERT INTO Film (title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, fulltext) VALUES 
	(_title, _description, _release_year, _language_id, _rental_duration, _rental_rate, _length, _replacement_cost, _rating, _special_features, _fulltext);
$$;


CREATE FUNCTION admins.create_inventory_validate(
	_film_id   INT,
	_store_id  INT) 
RETURNS VOID LANGUAGE PLPGSQL SECURITY DEFINER AS $$
BEGIN
	IF ((_film_id IS NULL) OR (_store_id IS NULL)) THEN
		RAISE 'Error: Null parameter.';
		
    ELSIF NOT EXISTS(SELECT * FROM Film WHERE film_id = _film_id) THEN
		RAISE 'Error: Film doesn''t exists.';

	ELSIF NOT EXISTS(SELECT * FROM Store WHERE store_id = _store_id) THEN
		RAISE 'Error: Store doesn''t exists.';
	END IF;
END;$$;


CREATE FUNCTION admins.create_inventory_action(
	_film_id   INT,
	_store_id  INT) 
RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
	INSERT INTO Inventory (film_id, store_id) VALUES
	(_film_id, _store_id);
$$;
