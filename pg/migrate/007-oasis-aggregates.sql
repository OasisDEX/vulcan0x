CREATE TABLE api.trades_aggregated_schema (
  market VARCHAR NOT NULL,
  open decimal(28,18) NOT NULL,
  close decimal(28,18) NOT NULL,
  min decimal(28,18) NOT NULL,
  max decimal(28,18) NOT NULL,
  volume_base decimal(28,18) NOT NULL,
  volume_quote decimal(28,18) NOT NULL,
  date timestamp NOT NULL
);

CREATE FUNCTION api.trades_aggregated(time_unit VARCHAR, tz_offset INTERVAL)
RETURNS SETOF api.trades_aggregated_schema AS $$
  SELECT
    oasis_trade.market,
    (array_agg(oasis_trade.price ORDER BY oasis_trade.time))[1] AS open,
    (array_agg(oasis_trade.price ORDER BY oasis_trade.time DESC))[1] AS close,
    MIN(oasis_trade.price) AS min,
    MAX(oasis_trade.price) AS max,
    SUM(CASE
      WHEN oasis_trade.bid_tkn = market.base THEN oasis_trade.bid_amt
      WHEN oasis_trade.lot_tkn = market.base THEN oasis_trade.lot_amt
      ELSE 0
    END) AS volume_base,
    SUM(CASE
      WHEN oasis_trade.bid_tkn = market.quote THEN oasis_trade.bid_amt
      WHEN oasis_trade.lot_tkn = market.quote THEN oasis_trade.lot_amt
      ELSE 0
    END) AS volume_quote,
    date_trunc(time_unit, oasis_trade.time AT TIME ZONE tz_offset) AS date
  FROM api.oasis_trade
  LEFT JOIN oasis.market ON oasis_trade.market = market.id
  GROUP BY date, oasis_trade.market
  ORDER BY date DESC;
$$ LANGUAGE sql STABLE STRICT;
