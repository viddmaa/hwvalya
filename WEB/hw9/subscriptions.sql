-- Подготовка окружения
DROP TABLE IF EXISTS subscription_raw CASCADE;

-- Стартовая "сырая" схема
CREATE TABLE subscription_raw (
    id              serial PRIMARY KEY,
    user_name       text,
    plan            text,                 -- например: basic | pro | business | enterprise
    price_cents     integer,              -- цена в центах
    started_at      timestamp DEFAULT now(),
    status          text DEFAULT 'active',-- active | paused | canceled
    deprecated_flag boolean DEFAULT false -- устаревший признак
);

-- Посев данных
INSERT INTO subscription_raw (user_name, plan, price_cents, started_at, status, deprecated_flag) VALUES
('Alice Johnson',   'basic',      9900,   now() - interval '360 days', 'active',   false),
('Bob Smith',       'pro',       19900,   now() - interval '330 days', 'active',   false),
('Charlie Brown',   'business',  49900,   now() - interval '300 days', 'paused',   false),
('Diana Prince',    'enterprise',99900,   now() - interval '270 days', 'active',   false),
('Evan Lee',        'basic',      9900,   now() - interval '240 days', 'canceled', false),
('Fiona Adams',     'pro',       19900,   now() - interval '210 days', 'active',   false),
('George Miller',   'pro',       19900,   now() - interval '200 days', 'active',   false),
('Hannah Davis',    'business',  49900,   now() - interval '195 days', 'active',   false),
('Ian Wright',      'basic',      9900,   now() - interval '180 days', 'paused',   false),
('Julia Stone',     'enterprise',99900,   now() - interval '170 days', 'active',   false),
('Kevin Park',      'business',  49900,   now() - interval '165 days', 'active',   false),
('Laura Chen',      'basic',      9900,   now() - interval '160 days', 'active',   false),
('Mark Green',      'pro',       19900,   now() - interval '140 days', 'canceled', false),
('Nina Patel',      'business',  49900,   now() - interval '120 days', 'active',   false),
('Oscar Diaz',      'enterprise',99900,   now() - interval '110 days', 'active',   false),
('Paula Gomez',     'pro',       19900,   now() - interval '100 days', 'active',   false),
('Quinn Baker',     'basic',      9900,   now() - interval '90 days',  'active',   false),
('Rita Ora',        'business',  49900,   now() - interval '80 days',  'paused',   false),
('Sam Young',       'pro',       19900,   now() - interval '60 days',  'active',   false),
('Tina King',       'enterprise',99900,   now() - interval '45 days',  'active',   false),
('Uma Reed',        'basic',      9900,   now() - interval '30 days',  'active',   false),
('Victor Hugo',     'pro',       19900,   now() - interval '20 days',  'active',   false),
('Wendy Frost',     'business',  49900,   now() - interval '10 days',  'active',   false),
('Yara Novak',      'basic',      9900,   now() - interval '5 days',   'canceled', false),
('Zack Cole',       'enterprise',99900,   now() - interval '2 days',   'active',   false);

ALTER TABLE subscription_raw RENAME TO subscriptions;

ALTER TABLE subscriptions
ALTER COLUMN price_cents TYPE numeric(12,2) 
USING (price_cents / 100.0);

ALTER TABLE subscriptions RENAME COLUMN price_cents TO price;

ALTER TABLE subscriptions ADD COLUMN IF NOT EXISTS subscription_code text;

UPDATE subscriptions 
SET subscription_code = 
    'SUB-' || 
    UPPER(SUBSTR(plan, 1, 3)) || 
    '-' || 
    TO_CHAR(started_at, 'YYYY') || 
    '-' || 
    LPAD(id::text, 5, '0');

ALTER TABLE subscriptions DROP COLUMN deprecated_flag;

SELECT * FROM subscriptions
