CREATE VIEW api.oasis_trades_with_proxy AS
SELECT
  distinct on(ot.idx, ot.tx)
  ot.act,
  ot.offer_id,
  ot.maker,
  ot.taker,
  ot.bid_amt,
  ot.bid_tkn,
  ot.lot_amt,
  ot.lot_tkn,
  ot.price,
  ot.time,
  ot.tx,
  pi.tag,
  pi.from_address as proxy_from_address
FROM
  api.oasis_trade as ot
LEFT JOIN
  proxy.proxy_info as pi
ON
  ot.tx = pi.tx
ORDER BY ot.idx, ot.tx;

COMMENT ON COLUMN api.oasis_trades_with_proxy.offer_id is 'Offer identifier';
COMMENT ON COLUMN api.oasis_trades_with_proxy.tx is 'Transaction ID';
COMMENT ON COLUMN api.oasis_trades_with_proxy.tag is 'Proxy tag';
COMMENT ON COLUMN api.oasis_trades_with_proxy.proxy_from_address is 'Transaction creator for all proxies';
