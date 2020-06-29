CREATE OR REPLACE FUNCTION blocks_notify()
	RETURNS trigger AS
$$
BEGIN
	PERFORM pg_notify('blocks', row_to_json(NEW)::TEXT);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
