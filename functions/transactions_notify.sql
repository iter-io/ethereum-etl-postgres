CREATE OR REPLACE FUNCTION transactions_notify()
	RETURNS trigger AS
$$
BEGIN
  PERFORM pg_notify('transactions',
  '{' || '"hash":"'                        || NEW.hash                                       || '",'
      || '"nonce":"'                       || NEW.nonce                                      || '",'
      || '"transaction_index":"'           || NEW.transaction_index                          || '",'
      || '"from_address":"'                || NEW.from_address                               || '",'
      || '"to_address":"'                  || COALESCE(NEW.to_address, 'null')               || '",'
      || '"value":"'                       || NEW.value                                      || '",'
      || '"gas":"'                         || NEW.gas                                        || '",'
      || '"gas_price":"'                   || NEW.gas_price                                  || '",'
      || '"receipt_cumulative_gas_used":"' || NEW.receipt_cumulative_gas_used                || '",'
      || '"receipt_gas_used":"'            || NEW.receipt_gas_used                           || '",'
      || '"receipt_contract_address":"'    || COALESCE(NEW.receipt_contract_address, 'null') || '",'
      || '"receipt_root":"'                || COALESCE(NEW.receipt_root, 'null')             || '",'
      || '"receipt_status":"'              || COALESCE(NEW.receipt_status::TEXT, 'null')     || '",'
      || '"block_timestamp":"'             || NEW.block_timestamp                            || '",'
      || '"block_number":"'                || NEW.block_number                               || '",'
      || '"block_hash":"'                  || NEW.block_hash                                 || '"}'
  );
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;
