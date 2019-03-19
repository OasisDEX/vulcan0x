INSERT INTO proxy.proxy_info (
  proxy_address,
  tag,
  from_address

)
VALUES (
  ${address},
  ${tag},
  ${from}
)

ON CONFLICT DO NOTHING;
