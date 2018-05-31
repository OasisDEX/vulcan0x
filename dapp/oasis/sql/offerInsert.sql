INSERT INTO offer (
  id,
  pair,
  maker,
  lot_gem,
  lot_amt,
  bid_gem,
  bid_amt,
  block,
  time,
  tx
)
VALUES (
  ${id},
  ${pair},
  ${maker},
  ${lot_gem},
  ${lot_amt},
  ${bid_gem},
  ${bid_amt},
  ${block},
  to_timestamp(${time}),
  ${tx}
)
ON CONFLICT ( id )
DO NOTHING