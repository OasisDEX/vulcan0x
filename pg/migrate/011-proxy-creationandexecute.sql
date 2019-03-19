CREATE TABLE proxy.creationexecuteproxy_transactions (
  from_address character varying(66) not null,
  tx           character varying(66) not null,
  name         character varying(40)
);

CREATE INDEX proxy_creationexecuteproxy_transactions_from_address_index ON proxy.creationexecuteproxy_transactions(from_address);
CREATE INDEX proxy_creationexecuteproxy_transactions_tx_index ON proxy.creationexecuteproxy_transactions(tx);
