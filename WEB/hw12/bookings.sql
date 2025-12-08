DROP TABLE IF EXISTS bookings_import_lines;

CREATE TABLE bookings_import_lines (
  id serial PRIMARY KEY,
  source_file text NOT NULL,
  line_no int NOT NULL,
  raw_line text NOT NULL,
  imported_at timestamptz default now(),
  note text
);

INSERT INTO bookings_import_lines (source_file, line_no, raw_line, note) VALUES
('partnerA_2025_11.csv', 1, 'PNR: ABC123; Passenger: Ivan Petrov <ivan.petrov@example.com>; +7 (916) 111-22-33; Fare: "1,299.00" USD', 'booking row'),
('partnerA_2025_11.csv', 2, 'PNR: XYZ-999; Passenger: Maria; maria.s@mail.co; 8-916-1112233; Fare: "1 250,00" EUR', 'booking row'),
('partnerA_2025_11.csv', 3, 'PNR: BAD@@PNR; Passenger: Oops <bad@-domain.com>; +7 916 ABC-22-33; Fare: "999"', 'broken pnr and email'),

('carrier_feed.csv', 10, 'Voucher: VCHR-2025-0001; Flight: SU1234; seat: 12A', 'voucher row'),
('carrier_feed.csv', 11, 'Booking: pnr: qwe987; note: legacy', 'booking row'),

('dates_feed.csv', 1, 'checkin: 05/12/2025; checkout: 12/12/2025', 'dates'),
('dates_feed.csv', 2, 'checkin: 2025-12-05; checkout: 2025-12-12', 'iso dates'),
('dates_feed.csv', 3, 'checkin: Dec 5, 2025; checkout: Dec 12, 2025', 'text month'),

('flags.csv', 1, 'tags: vip,flex, refundable ', 'tags row'),
('flags.csv', 2, 'tags: economy, , promo', 'tags with possible empty'),

('passenger_dirty.csv', 5, '"Ivanov, Ivan","123 Red St, Apt 4","Passport: 123-45-678"', 'dirty csv'),
('passenger_dirty.csv', 6, '"Smith, Anna","Los Angeles, CA","Notes: needs wheelchair"', 'dirty csv'),

('import_log.txt', 300, 'INFO: started bookings import', 'log'),
('import_log.txt', 301, 'warning: missing fare for line 3', 'log'),
('import_log.txt', 302, 'error: failed to parse PNR for line 3', 'log'),
('import_log.txt', 303, 'Error: invalid date format in dates_feed.csv', 'log'),

('partnerA_2025_11.csv', 20, 'PNR: 123 456; Passenger: bad@@example..com; Fare: "1,2,99"', 'trap-bad-pnr-email-price'),
('flags.csv', 3, 'tags: vip,, ,flex', 'trap-empty-tags');


SELECT *
FROM bookings_import_lines
WHERE raw_line ~ '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}';


SELECT *
FROM bookings_import_lines
WHERE raw_line !~ '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}';



SELECT *
FROM bookings_import_lines
WHERE raw_line ~* 'PNR:\s*[A-Z0-9]{3}-?[0-9]{3}';


SELECT
  id,
  source_file,
  line_no,
  (regexp_match(
    raw_line,
    '([A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,})'
  ))[1] AS email
FROM bookings_import_lines
WHERE raw_line ~ '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}';


SELECT
  id,
  source_file,
  line_no,
  m[1] AS code
FROM bookings_import_lines
CROSS JOIN LATERAL regexp_matches(
  raw_line,
  '(VCHR-[0-9]{4}-[0-9]{4}|[A-Z]{2}[0-9]{3,4})',
  'g'
) AS m;


SELECT
  b.id,
  b.source_file,
  b.line_no,
  (m.match)[1] AS phone_raw,
  regexp_replace((m.match)[1], '\D', '', 'g') AS phone_digits
FROM bookings_import_lines b
CROSS JOIN LATERAL (
  SELECT regexp_match(
      b.raw_line,
      '((\+7|8)[0-9()\s-]+)' 
  ) AS match
) m
WHERE b.raw_line ~ '(\+7|8)[0-9()\s-]+'
  AND length(regexp_replace((m.match)[1], '\D', '', 'g')) >= 10;



WITH fares AS (
  SELECT
    id,
    source_file,
    line_no,
    (regexp_match(raw_line, 'Fare:\s*"([^"]+)"'))[1] AS fare_str
  FROM bookings_import_lines
  WHERE raw_line ~ 'Fare:'
)
SELECT
  id,
  source_file,
  line_no,
  fare_str,
  CASE
    WHEN fare_str LIKE '%,%.%' THEN
      replace(fare_str, ',', '')::numeric

    WHEN fare_str LIKE '% %,%' THEN
      replace(replace(fare_str, ' ', ''), ',', '.')::numeric

    WHEN fare_str ~ '^[0-9]+([.,][0-9]+)?$' THEN
      replace(fare_str, ',', '.')::numeric

    ELSE NULL::numeric
  END AS fare_numeric
FROM fares;


SELECT
  id,
  source_file,
  line_no,
  array_remove(
    regexp_split_to_array(
      regexp_replace(raw_line, '^tags:\s*', ''),
      '\s*,\s*'                                   
    ),
    ''                                          
  ) AS tags
FROM bookings_import_lines
WHERE source_file = 'flags.csv';


SELECT
  id,
  source_file,
  line_no,
  field_no,
  regexp_replace(
    regexp_replace(field, '^"', ''),
    '"$', ''
  ) AS field
FROM bookings_import_lines
CROSS JOIN LATERAL regexp_split_to_table(raw_line, '","')
     WITH ORDINALITY AS t(field, field_no)
WHERE source_file = 'passenger_dirty.csv';


SELECT
  id,
  source_file,
  line_no,
  raw_line,
  regexp_replace(raw_line, 'error', 'ERROR', 'gi') AS normalized_line
FROM bookings_import_lines
WHERE source_file = 'import_log.txt'
  AND raw_line ~* 'error';
