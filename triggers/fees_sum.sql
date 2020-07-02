DROP TRIGGER IF EXISTS fees_sum ON blocks;

CREATE TRIGGER fees_sum
	AFTER INSERT OR UPDATE
	ON blocks
	FOR EACH STATEMENT
EXECUTE PROCEDURE fees_notify('fees_sum', 'sum', 10);