-- Kaindet development seed data
--
-- Put this file in:
--   backend/src/main/resources/data.sql
--
-- For Spring Boot with Hibernate/JPA schema creation, use these settings
-- in your development profile:
--   spring.sql.init.mode=always
--   spring.jpa.defer-datasource-initialization=true
--
-- The script is intentionally small and repeatable. It removes only the
-- Kaindet development records defined below and recreates them.

BEGIN;

-- ---------------------------------------------------------------------------
-- Remove old copies of this seed data in foreign-key-safe order
-- ---------------------------------------------------------------------------

DELETE FROM messages
WHERE sender_id IN (
    SELECT id
    FROM users
    WHERE email IN (
        'admin@kaindet.local',
        'anna@kaindet.local',
        'max@kaindet.local',
        'leon@kaindet.local'
    )
)
OR conversation_id IN (
    SELECT c.id
    FROM conversations c
    WHERE c.buyer_id IN (
        SELECT id FROM users
        WHERE email IN ('max@kaindet.local', 'leon@kaindet.local')
    )
    AND c.seller_id IN (
        SELECT id FROM users
        WHERE email = 'anna@kaindet.local'
    )
);

DELETE FROM conversations
WHERE buyer_id IN (
    SELECT id FROM users
    WHERE email IN ('max@kaindet.local', 'leon@kaindet.local')
)
AND seller_id IN (
    SELECT id FROM users
    WHERE email = 'anna@kaindet.local'
);

DELETE FROM listing_images
WHERE listing_id IN (
    SELECT l.id
    FROM listings l
    JOIN users u ON u.id = l.seller_id
    WHERE u.email IN ('anna@kaindet.local', 'leon@kaindet.local')
      AND l.title IN ('Mountainbike', 'Gaming Monitor', 'Fahrradhelm')
);

DELETE FROM listings
WHERE seller_id IN (
    SELECT id FROM users
    WHERE email IN ('anna@kaindet.local', 'leon@kaindet.local')
)
AND title IN ('Mountainbike', 'Gaming Monitor', 'Fahrradhelm');

DELETE FROM users
WHERE email IN (
    'admin@kaindet.local',
    'anna@kaindet.local',
    'max@kaindet.local',
    'leon@kaindet.local'
);

-- ---------------------------------------------------------------------------
-- Users
-- ---------------------------------------------------------------------------

INSERT INTO users (external_auth_id, email, display_name, role, created_at)
VALUES
    ('dev-admin', 'admin@kaindet.local', 'Kaindet Admin', 'ADMIN', CURRENT_TIMESTAMP - INTERVAL '30 days'),
    ('dev-anna',  'anna@kaindet.local',  'Anna Berger',   'USER',  CURRENT_TIMESTAMP - INTERVAL '20 days'),
    ('dev-max',   'max@kaindet.local',   'Max Huber',     'USER',  CURRENT_TIMESTAMP - INTERVAL '15 days'),
    ('dev-leon',  'leon@kaindet.local',  'Leon Gruber',   'USER',  CURRENT_TIMESTAMP - INTERVAL '10 days');

-- ---------------------------------------------------------------------------
-- Listings
-- Search prototype: searching for "Fahrrad" can match Mountainbike through
-- its description and Fahrradhelm through its title/description.
-- ---------------------------------------------------------------------------

INSERT INTO listings (
    seller_id,
    title,
    description,
    price,
    status,
    created_at,
    updated_at
)
VALUES
    (
        (SELECT id FROM users WHERE email = 'anna@kaindet.local'),
        'Mountainbike',
        'Gut erhaltenes Fahrrad, ideal fuer den Schulweg. Kleine Gebrauchsspuren.',
        180.00,
        'ACTIVE',
        CURRENT_TIMESTAMP - INTERVAL '5 days',
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    ),
    (
        (SELECT id FROM users WHERE email = 'anna@kaindet.local'),
        'Gaming Monitor',
        '24 Zoll Full-HD Monitor, funktioniert einwandfrei.',
        95.00,
        'ACTIVE',
        CURRENT_TIMESTAMP - INTERVAL '4 days',
        CURRENT_TIMESTAMP - INTERVAL '4 days'
    ),
    (
        (SELECT id FROM users WHERE email = 'leon@kaindet.local'),
        'Fahrradhelm',
        'Schwarzer Fahrradhelm in Groesse M, wenig benutzt.',
        25.00,
        'ACTIVE',
        CURRENT_TIMESTAMP - INTERVAL '2 days',
        CURRENT_TIMESTAMP - INTERVAL '1 day'
    );

-- ---------------------------------------------------------------------------
-- Listing images
-- These are filename/path placeholders. Real image files are not required
-- for database/API development.
-- ---------------------------------------------------------------------------

INSERT INTO listing_images (listing_id, filename, sort_order, created_at)
VALUES
    (
        (SELECT id FROM listings WHERE title = 'Mountainbike'
         AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')),
        'dev/mountainbike.jpg',
        0,
        CURRENT_TIMESTAMP - INTERVAL '5 days'
    ),
    (
        (SELECT id FROM listings WHERE title = 'Gaming Monitor'
         AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')),
        'dev/gaming-monitor.jpg',
        0,
        CURRENT_TIMESTAMP - INTERVAL '4 days'
    ),
    (
        (SELECT id FROM listings WHERE title = 'Fahrradhelm'
         AND seller_id = (SELECT id FROM users WHERE email = 'leon@kaindet.local')),
        'dev/fahrradhelm.jpg',
        0,
        CURRENT_TIMESTAMP - INTERVAL '2 days'
    );

-- ---------------------------------------------------------------------------
-- One example conversation about the Mountainbike
-- ---------------------------------------------------------------------------

INSERT INTO conversations (listing_id, buyer_id, seller_id, created_at)
VALUES (
    (SELECT id FROM listings WHERE title = 'Mountainbike'
     AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')),
    (SELECT id FROM users WHERE email = 'max@kaindet.local'),
    (SELECT id FROM users WHERE email = 'anna@kaindet.local'),
    CURRENT_TIMESTAMP - INTERVAL '1 day'
);

-- ---------------------------------------------------------------------------
-- Example chat messages
-- ---------------------------------------------------------------------------

INSERT INTO messages (conversation_id, sender_id, content, sent_at, read_at)
VALUES
    (
        (
            SELECT c.id
            FROM conversations c
            WHERE c.buyer_id = (SELECT id FROM users WHERE email = 'max@kaindet.local')
              AND c.listing_id = (
                  SELECT id FROM listings
                  WHERE title = 'Mountainbike'
                    AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')
              )
        ),
        (SELECT id FROM users WHERE email = 'max@kaindet.local'),
        'Hallo, ist das Mountainbike noch verfuegbar?',
        CURRENT_TIMESTAMP - INTERVAL '23 hours',
        CURRENT_TIMESTAMP - INTERVAL '22 hours 50 minutes'
    ),
    (
        (
            SELECT c.id
            FROM conversations c
            WHERE c.buyer_id = (SELECT id FROM users WHERE email = 'max@kaindet.local')
              AND c.listing_id = (
                  SELECT id FROM listings
                  WHERE title = 'Mountainbike'
                    AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')
              )
        ),
        (SELECT id FROM users WHERE email = 'anna@kaindet.local'),
        'Ja, es ist noch verfuegbar.',
        CURRENT_TIMESTAMP - INTERVAL '22 hours 45 minutes',
        CURRENT_TIMESTAMP - INTERVAL '22 hours 30 minutes'
    ),
    (
        (
            SELECT c.id
            FROM conversations c
            WHERE c.buyer_id = (SELECT id FROM users WHERE email = 'max@kaindet.local')
              AND c.listing_id = (
                  SELECT id FROM listings
                  WHERE title = 'Mountainbike'
                    AND seller_id = (SELECT id FROM users WHERE email = 'anna@kaindet.local')
              )
        ),
        (SELECT id FROM users WHERE email = 'max@kaindet.local'),
        'Super, koennen wir uns morgen in der Schule treffen?',
        CURRENT_TIMESTAMP - INTERVAL '22 hours',
        NULL
    );

COMMIT;
