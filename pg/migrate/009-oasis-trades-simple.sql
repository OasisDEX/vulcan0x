CREATE VIEW api.oasis_simple_trade AS
SELECT
  offer_id,
  pair,
  maker,
  taker,
  lot_gem,
  COALESCE(lot.symbol, 'XXX') AS lot_tkn,
  lot_amt,
  bid_gem,
  COALESCE(bid.symbol, 'XXX') AS bid_tkn,
  bid_amt,
  block,
  time,
  tx,
  idx
FROM oasis.trade t
LEFT JOIN erc20.token lot
  ON lot.key = t.lot_gem
LEFT JOIN erc20.token bid
  ON bid.key = t.bid_gem;

COMMENT ON COLUMN api.oasis_trade.offer_id is 'Offer identifier';
COMMENT ON COLUMN api.oasis_trade.market is 'Market base/quote symbol';
COMMENT ON COLUMN api.oasis_trade.pair is 'Trading pair hash';
COMMENT ON COLUMN api.oasis_trade.maker is 'Offer creator address';
COMMENT ON COLUMN api.oasis_trade.taker is 'Trade creator address (msg.sender)';
COMMENT ON COLUMN api.oasis_trade.lot_gem is 'Lot token address';
COMMENT ON COLUMN api.oasis_trade.lot_tkn is 'Lot token symbol';
COMMENT ON COLUMN api.oasis_trade.lot_amt is 'Lot amount given by maker';
COMMENT ON COLUMN api.oasis_trade.bid_gem is 'Bid token address';
COMMENT ON COLUMN api.oasis_trade.bid_tkn is 'Bid token symbol';
COMMENT ON COLUMN api.oasis_trade.bid_amt is 'Bid amount matched by taker';
COMMENT ON COLUMN api.oasis_trade.block is 'Block height';
COMMENT ON COLUMN api.oasis_trade.time is 'Block timestamp';
COMMENT ON COLUMN api.oasis_trade.tx is 'Transaction hash';
