CREATE SCHEMA proxy;

CREATE TABLE proxy.proxy_info (
  address      character varying(66),
  tag          character varying(40),
  tx           character varying(66),
  from_address character varying(66)
);

CREATE INDEX proxy_proxy_info_address_index ON proxy.proxy_info(address);
CREATE INDEX proxy_proxy_info_tag_index ON proxy.proxy_info(tag);
