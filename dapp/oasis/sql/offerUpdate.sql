UPDATE offer
SET (lot_amt, bid_amt) = (${lot_amt}, ${bid_amt})
WHERE offer.id = ${id};