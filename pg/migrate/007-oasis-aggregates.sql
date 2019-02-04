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

CREATE VIEW api.oasis_clean_trade AS
  SELECT * FROM api.oasis_trade WHERE bid_amt > 0.000000000001 AND lot_amt > 0.000000000001;

CREATE FUNCTION api.trades_aggregated(time_unit VARCHAR, tz_offset INTERVAL, date_from TIMESTAMP, date_to TIMESTAMP)
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
  FROM api.oasis_clean_trade AS oasis_trade
  LEFT JOIN oasis.market ON oasis_trade.market = market.id
  WHERE (date_from IS NULL OR oasis_trade.time >= date_from)
    AND (date_to IS NULL OR oasis_trade.time <= date_to)
  GROUP BY date, oasis_trade.market
  ORDER BY date ASC;
$$ LANGUAGE sql STABLE;
