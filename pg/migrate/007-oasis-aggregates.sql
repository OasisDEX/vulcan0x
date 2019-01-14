CREATE VIEW api.trades_aggregated_hour AS
 SELECT 
 	oasis_trade.market,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time))[1] AS open,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time DESC))[1] AS close,
 	MIN(oasis_trade.price) AS min,
 	MAX(oasis_trade.price) AS max,
    date_trunc('hour', oasis_trade.time) as DATE
   FROM api.oasis_trade
  GROUP BY DATE, oasis_trade.market;

CREATE VIEW api.trades_aggregated_day AS
 SELECT 
 	oasis_trade.market,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time))[1] AS open,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time DESC))[1] AS close,
 	MIN(oasis_trade.price) AS min,
 	MAX(oasis_trade.price) AS max,
    date_trunc('day', oasis_trade.time) as DATE
   FROM api.oasis_trade
  GROUP BY DATE, oasis_trade.market;

CREATE VIEW api.trades_aggregated_week AS
 SELECT 
 	oasis_trade.market,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time))[1] AS open,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time DESC))[1] AS close,
 	MIN(oasis_trade.price) AS min,
 	MAX(oasis_trade.price) AS max,
    date_trunc('week', oasis_trade.time) as DATE
   FROM api.oasis_trade
  GROUP BY DATE, oasis_trade.market;

CREATE VIEW api.trades_aggregated_month AS
 SELECT 
 	oasis_trade.market,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time))[1] AS open,
 	(array_agg(oasis_trade.price ORDER BY oasis_trade.time DESC))[1] AS close,
 	MIN(oasis_trade.price) AS min,
 	MAX(oasis_trade.price) AS max,
    date_trunc('month', oasis_trade.time) as DATE
   FROM api.oasis_trade
  GROUP BY DATE, oasis_trade.market;