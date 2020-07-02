CREATE OR REPLACE FUNCTION fees_notify()
	RETURNS trigger AS
$$
DECLARE
  channel TEXT;
  aggregate_function TEXT;
  window_size_in_blocks INTEGER;
  sql_statement TEXT;
  result NUMERIC(38, 8);
BEGIN
  channel := TG_ARGV[0];
  aggregate_function := TG_ARGV[1];
  window_size_in_blocks := TG_ARGV[2];

  -- Convert from receipt_gas_used to ETH using gas_price. Group at block level then apply aggregate.
  sql_statement :=
    'SELECT '
    || aggregate_function || '(fees) '
    || 'FROM '
    || '('
    || '  SELECT'
    || '    block_number AS block_number,'

    || '    2::NUMERIC(38, 8) + SUM(receipt_gas_used::BIGINT * (gas_price::BIGINT / 10^18::BIGINT))::NUMERIC(38, 8)'
    || '                 AS fees'
    || '  FROM'
    || '    transactions'
    || '  WHERE'
    || '    block_number > (SELECT MAX(block_number) - ' || window_size_in_blocks || ' FROM transactions)'
    || '  GROUP BY'
    || '    block_number'
    || '  ORDER BY'
    || '    block_number DESC'
    || ') AS fees_by_block';

  EXECUTE sql_statement INTO result;

  -- Create a dynamic key and return the result in JSON.
  -- TODO: Add block number.
  PERFORM pg_notify(channel,
  '{' || '"fees_' || aggregate_function || '_last_' || window_size_in_blocks || '_blocks'
      || '":"' || result::TEXT || '"}'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
