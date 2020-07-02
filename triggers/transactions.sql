DROP TRIGGER IF EXISTS transactions ON transactions;

CREATE TRIGGER transactions
	AFTER INSERT OR UPDATE
	ON transactions
	FOR EACH ROW
EXECUTE PROCEDURE transactions_notify();
