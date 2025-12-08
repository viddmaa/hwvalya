DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    id           BIGSERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    sku          TEXT NOT NULL,
    description  TEXT,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO products (product_name, sku, description, created_at)
SELECT
    'Product ' || g,
    'SKU-' || lpad(g::text, 6, '0'),
    md5(random()::text) || ' pattern ' || md5(random()::text),
    now() - (random() * interval '365 days')
FROM generate_series(1, 1000000) AS g;

SELECT *
FROM products
WHERE sku = 'SKU-000001';

CREATE INDEX idx_products_sku ON products (sku);

SELECT *
FROM products
WHERE sku = 'SKU-000001';

SELECT *
FROM products
WHERE description ILIKE '%pattern%';

CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_products_description_trgm
ON products
USING gin (lower(description) gin_trgm_ops);

SELECT *
FROM products
WHERE lower(description) LIKE '%pattern%';
