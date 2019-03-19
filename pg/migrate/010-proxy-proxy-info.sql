CREATE SCHEMA proxy;

CREATE TABLE proxy.proxy_info (
  proxy_address character varying(66),
  tag           character varying(40),
  from_address  character varying(66),
  CONSTRAINT unique_tx_idx UNIQUE(proxy_address, from_address)
);

CREATE INDEX proxy_proxy_info_proxy_address_index ON proxy.proxy_info(proxy_address);
CREATE INDEX proxy_proxy_info_tag_index ON proxy.proxy_info(tag);
CREATE INDEX proxy_proxy_info_from_address_index ON proxy.proxy_info(from_address);
