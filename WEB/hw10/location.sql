CREATE TABLE location (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    region TEXT NOT NULL
);

CREATE TABLE location_info (
    location_id INTEGER PRIMARY KEY REFERENCES location(id) ON DELETE CASCADE,
    danger_level INTEGER NOT NULL CHECK (danger_level BETWEEN 1 AND 10),
    climate TEXT NOT NULL,
    fast_travel_unlocked BOOLEAN NOT NULL
);

CREATE TABLE character (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    class TEXT NOT NULL,
    home_location_id INTEGER NOT NULL REFERENCES location(id) ON DELETE RESTRICT
);

CREATE TABLE character_visit (
    character_id INTEGER REFERENCES character(id) ON DELETE CASCADE,
    location_id INTEGER REFERENCES location(id) ON DELETE CASCADE,
    visited_at TIMESTAMP NOT NULL,
    purpose TEXT NOT NULL,
    PRIMARY KEY (character_id, location_id, visited_at),
    CHECK (visited_at <= NOW())
);

INSERT INTO location (name, region) VALUES 
    ('Forest', 'Forest'),
    ('Desert', 'Desert'), 
    ('Tundra', 'Tundra');

INSERT INTO location_info VALUES 
    (1, 3, 'Temperate', true),
    (2, 7, 'Arid', false),
    (3, 5, 'Polar', true);

INSERT INTO character (name, class, home_location_id) VALUES 
    ('Warrior', 'Warrior', 1),
    ('Mage', 'Mage', 2),
    ('Rogue', 'Rogue', 1);

INSERT INTO character_visit VALUES 
    (1, 2, '2025-11-05 14:30:00', 'quest'),
    (2, 1, '2025-11-12 09:15:00', 'trade'),
    (3, 3, '2025-11-01 16:45:00', 'explore'),
    (1, 3, '2025-11-03 11:20:00', 'quest');

SELECT * FROM location;
SELECT * FROM location_info;
SELECT * FROM character;
SELECT * FROM character_visit;


DROP TABLE IF EXISTS character_visit;
DROP TABLE IF EXISTS character;
DROP TABLE IF EXISTS location_info;
DROP TABLE IF EXISTS location;
