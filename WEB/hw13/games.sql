
DROP TABLE IF EXISTS loan CASCADE;
DROP TABLE IF EXISTS item_location CASCADE;
DROP TABLE IF EXISTS character_item CASCADE;
DROP TABLE IF EXISTS player_guild CASCADE;
DROP TABLE IF EXISTS item CASCADE;
DROP TABLE IF EXISTS "character" CASCADE;
DROP TABLE IF EXISTS guild CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS player CASCADE;

-- Игроки (аккаунты)
CREATE TABLE player (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT
);

-- Гильдии
CREATE TABLE guild (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    founded_year INT
);

-- MtM: player <-> guild с атрибутом member_tag
CREATE TABLE player_guild (
    guild_id INT NOT NULL REFERENCES guild(id) ON DELETE CASCADE,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    member_tag TEXT NOT NULL,
    joined_at DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (guild_id, player_id),
    CONSTRAINT uniq_tag_per_guild UNIQUE (guild_id, member_tag)
);

-- Персонажи
CREATE TABLE "character" (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    class TEXT,
    level INT DEFAULT 1
);

-- Предметы
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    item_type TEXT,
    rarity TEXT,
    description TEXT
);

-- MtM: character <-> item (инвентарь) с quantity, equipped
CREATE TABLE character_item (
    character_id INT NOT NULL REFERENCES "character"(id) ON DELETE CASCADE,
    item_id INT NOT NULL REFERENCES item(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    equipped BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (character_id, item_id)
);

-- Локации (города / посты)
CREATE TABLE location (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    region TEXT,
    level_requirement INT
);

-- MtM: item <-> location с quantity (на складе/в продаже)
CREATE TABLE item_location (
    location_id INT NOT NULL REFERENCES location(id) ON DELETE CASCADE,
    item_id INT NOT NULL REFERENCES item(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity >= 0),
    vendor_name TEXT,
    PRIMARY KEY (location_id, item_id)
);

-- Loan: временная передача/аренда предмета из локации игроку
-- Поле guild_id + member_tag используются для ссылки на запись player_guild (если игрок действует как представитель гильдии).
CREATE TABLE loan (
    id SERIAL PRIMARY KEY,
    location_id INT NOT NULL REFERENCES location(id) ON DELETE CASCADE,
    guild_id INT,
    member_tag TEXT,
    player_id INT NOT NULL REFERENCES player(id) ON DELETE CASCADE,
    item_id INT NOT NULL REFERENCES item(id) ON DELETE RESTRICT,
    loan_days INT NOT NULL CHECK (loan_days > 0),
    loaned_at DATE NOT NULL DEFAULT CURRENT_DATE,
    returned_at DATE,
    CONSTRAINT fk_player_guild_pair FOREIGN KEY (guild_id, member_tag)
        REFERENCES player_guild (guild_id, member_tag)
        ON DELETE RESTRICT
);

CREATE INDEX idx_loan_player ON loan(player_id);
CREATE INDEX idx_loan_item ON loan(item_id);

-- =========================
-- SEED DATA
-- =========================

-- Players
INSERT INTO player (id, username, email) VALUES
(1, 'hero_ivan', 'ivan@example.com'),
(2, 'mage_maria', 'maria@example.com'),
(3, 'rogue_oleg', 'oleg@example.com'),
(4, 'newbie', NULL),
(5, 'loner', 'solo@example.com');

SELECT setval(pg_get_serial_sequence('player','id'), (SELECT MAX(id) FROM player));

-- Guilds
INSERT INTO guild (id, name, founded_year) VALUES
(1, 'Order of Dawn', 2010),
(2, 'Shadow Syndicate', 2018),
(3, 'Wandering Minstrels', NULL); -- гильдия без членов

SELECT setval(pg_get_serial_sequence('guild','id'), (SELECT MAX(id) FROM guild));

-- Player-Guild memberships
INSERT INTO player_guild (guild_id, player_id, member_tag, joined_at) VALUES
(1, 1, 'D-1001', '2020-01-15'),
(1, 2, 'D-1002', '2021-03-20'),
(2, 3, 'S-3001', '2022-07-07'),
-- player 4 и 5 не состоят в гильдиях
(1, 5, 'D-1005', '2024-05-05');

-- Characters
INSERT INTO "character" (id, name, player_id, class, level) VALUES
(1, 'Ivan the Brave', 1, 'Warrior', 35),
(2, 'Maria the Wise', 2, 'Mage', 40),
(3, 'Oleg Shadowstep', 3, 'Rogue', 27),
(4, 'Novice Pete', 4, 'Peasant', 2),
(5, 'Solo Wanderer', 5, 'Ranger', 18);

SELECT setval(pg_get_serial_sequence('character','id'), (SELECT MAX(id) FROM "character"));

-- Items
INSERT INTO item (id, name, item_type, rarity, description) VALUES
(1, 'Sword of Dawn', 'Weapon', 'Epic', 'Ancient blade of the Dawn.'),
(2, 'Common Potion', 'Consumable', 'Common', 'Restores 50 HP.'),
(3, 'Shadow Dagger', 'Weapon', 'Rare', 'Favored by assassins.'),
(4, 'Traveler Cloak', 'Armor', 'Uncommon', 'Light cloak for travelers.'),
(5, 'Ancient Tome', 'Misc', 'Legendary', 'Contains forbidden knowledge.'),
(6, 'Wooden Shield', 'Armor', 'Common', 'Basic protection.'),
(7, 'Boots of Swiftness', 'Armor', 'Rare', 'Increases speed.');

SELECT setval(pg_get_serial_sequence('item','id'), (SELECT MAX(id) FROM item));

-- Character inventory (character_item)
INSERT INTO character_item (character_id, item_id, quantity, equipped) VALUES
(1, 1, 1, TRUE),   -- Ivan has Sword of Dawn equipped
(1, 6, 1, TRUE),   -- Ivan has Wooden Shield equipped
(2, 2, 5, FALSE),  -- Maria has potions
(2, 5, 1, FALSE),  -- Maria carries Ancient Tome (not equipped)
(3, 3, 1, TRUE),   -- Oleg has Shadow Dagger
(5, 4, 1, TRUE);   -- Solo Wanderer has cloak
-- character 4 (Novice Pete) has no items -> useful for LEFT JOIN demos
-- item 7 (Boots of Swiftness) currently not owned by anyone

-- Locations
INSERT INTO location (id, name, region, level_requirement) VALUES
(1, 'Sunhold', 'Northern Plains', 1),
(2, 'Shadowport', 'Coastlands', 10),
(3, 'Magehaven', 'Highlands', 20),
(4, 'Old Ruins', 'Badlands', 15),
(5, 'Lonely Inn', 'Crossroads', NULL);

SELECT setval(pg_get_serial_sequence('location','id'), (SELECT MAX(id) FROM location));

-- Item availability in locations (item_location)
INSERT INTO item_location (location_id, item_id, quantity, vendor_name) VALUES
(1, 2, 50, 'Alchemist Borya'),
(1, 6, 10, 'Blacksmith Tor'),
(2, 3, 2, 'Shadow Vendor'),
(2, 7, 1, 'Bootmaster'),
(3, 5, 1, 'Archivist'),
(4, 4, 3, 'Rogue Market'),
-- item 1 (Sword of Dawn) is not sold in locations (rare / owned)
-- item 7 present in location 2 as well as possibly elsewhere
(5, 2, 10, 'Innkeeper');

-- Loans: temporary transfer from location to player (some loans reference guild membership via (guild_id, member_tag))
INSERT INTO loan (location_id, guild_id, member_tag, player_id, item_id, loan_days, loaned_at) VALUES
(1, 1, 'D-1001', 1, 2, 7, '2025-11-01'),  -- Ivan (as guild rep) borrowed potion
(3, NULL, NULL, 2, 5, 30, '2025-10-15'),   -- Maria borrowed Ancient Tome directly (no guild tag)
(2, 2, 'S-3001', 3, 3, 14, '2025-11-05'),  -- Oleg borrowed Shadow Dagger via guild proxy
(5, 1, 'D-1005', 5, 2, 3, '2025-11-10');   -- Solo (member_tag D-1005) borrowed potion from Lonely Inn

-- 1.1
SELECT
    c.id,
    c.name,
    p.username,
    c.class
FROM "character" AS c
INNER JOIN player AS p ON c.player_id = p.id;

-- 1.2
SELECT
    l.name AS location_name,
    i.name AS item_name,
    il.quantity,
    il.vendor_name
FROM item_location AS il
INNER JOIN location AS l ON il.location_id = l.id
INNER JOIN item AS i ON il.item_id = i.id
WHERE il.quantity > 0;

-- 2.1
SELECT
    c.id AS character_id,
    c.name AS character_name,
    i.id AS item_id,
    i.name AS item_name,
    ci.quantity,
    ci.equipped
FROM "character" AS c
LEFT JOIN character_item AS ci ON ci.character_id = c.id
LEFT JOIN item AS i ON ci.item_id = i.id;

-- 2.2
SELECT
    p.id,
    p.username,
    COUNT(c.id) AS character_count
FROM player AS p
LEFT JOIN "character" AS c ON c.player_id = p.id
GROUP BY p.id, p.username
ORDER BY p.id;

-- 3.1
SELECT
    l.id AS location_id,
    l.name AS location_name,
    i.id AS item_id,
    i.name AS item_name,
    il.quantity,
    il.vendor_name
FROM item AS i
INNER JOIN item_location AS il ON i.id = il.item_id
RIGHT JOIN location AS l ON il.location_id = l.id;

-- 3.2
SELECT
    i.item_type,
    COUNT(DISTINCT il.location_id) AS location_count
FROM item_location AS il
RIGHT JOIN item AS i ON il.item_id = i.id
GROUP BY i.item_type;

-- 4.1
SELECT
    i.id AS item_id,
    i.name AS item_name,
    il.location_id,
    il.quantity,
    il.vendor_name
FROM item AS i
FULL JOIN item_location AS il ON il.item_id = i.id;

-- 4.2
SELECT
    p.id AS player_id,
    p.username,
    g.id AS guild_id,
    g.name AS guild_name,
    pg.member_tag
FROM player AS p
FULL JOIN player_guild AS pg ON p.id = pg.player_id
FULL JOIN guild AS g ON g.id = pg.guild_id
ORDER BY player_id NULLS LAST, guild_id NULLS LAST;

-- 5.1
SELECT
    l.id AS location_id,
    l.name AS location_name,
    it.item_type
FROM location AS l
CROSS JOIN (
    SELECT DISTINCT item_type
    FROM item
) AS it;

-- 5.2
SELECT
    c.id AS character_id,
    c.name AS character_name,
    l.id AS location_id,
    l.name AS location_name
FROM "character" AS c
CROSS JOIN location AS l
LIMIT 100;

-- 6.1
SELECT
    l.id AS location_id,
    l.name AS location_name,
    i.id AS item_id,
    i.name AS item_name,
    il_max.quantity
FROM location AS l
LEFT JOIN LATERAL (
    SELECT
        il.item_id,
        il.quantity
    FROM item_location AS il
    WHERE il.location_id = l.id
    ORDER BY il.quantity DESC
    LIMIT 1
) AS il_max ON TRUE
LEFT JOIN item AS i ON i.id = il_max.item_id;

-- 6.2
SELECT
    p.id AS player_id,
    p.username,
    last_loan.id AS loan_id,
    last_loan.item_id,
    last_loan.location_id,
    last_loan.loaned_at,
    last_loan.loan_days
FROM player AS p
LEFT JOIN LATERAL (
    SELECT l.*
    FROM loan AS l
    WHERE l.player_id = p.id
    ORDER BY l.loaned_at DESC, l.id DESC
    LIMIT 1
) AS last_loan ON TRUE;

-- 7.1
SELECT
    c1.id AS character_a_id,
    c1.name AS character_a_name,
    c2.id AS character_b_id,
    c2.name AS character_b_name,
    c1.player_id
FROM "character" AS c1
INNER JOIN "character" AS c2
    ON c1.player_id = c2.player_id
   AND c1.id < c2.id
   AND c1.name <> c2.name;

-- 7.2
SELECT
    i1.id AS item_a_id,
    i1.name AS item_a_name,
    i2.id AS item_b_id,
    i2.name AS item_b_name,
    i1.rarity
FROM item AS i1
INNER JOIN item AS i2
    ON i1.rarity = i2.rarity
   AND i1.id < i2.id;
