CREATE VIEW api.oasis_trades_with_proxy AS
SELECT
  DISTINCT ON(ot.tx, ot.idx)
  cet.name as proxy_name,
  cet.from_address as cet_from_address,
  pi.proxy_address,
  pi.from_address as proxy_from_address,
  pi.tag,
  ot.tx,
  ot.act,
  ot.offer_id,
  ot.maker,
  ot.taker,
  ot.bid_amt,
  ot.bid_tkn,
  ot.lot_amt,
  ot.lot_tkn,
  ot.price,
  ot.time
FROM
  api.oasis_trade as ot
LEFT JOIN proxy.proxy_info pi
ON
	ot.taker = pi.proxy_address
LEFT JOIN proxy.creationexecuteproxy_transactions cet
ON
	ot.tx = cet.tx;


COMMENT ON COLUMN api.oasis_trades_with_proxy.offer_id is 'Offer identifier';
COMMENT ON COLUMN api.oasis_trades_with_proxy.tx is 'Transaction ID';
COMMENT ON COLUMN api.oasis_trades_with_proxy.proxy_name is 'Proxy tag name';
COMMENT ON COLUMN api.oasis_trades_with_proxy.proxy_address is 'Proxy for trade';
