CREATE INDEX oasis_trade_time_index ON oasis.trade(time);

DROP FUNCTION api.trades_aggregated(time_unit VARCHAR, tz_offset INTERVAL);
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
