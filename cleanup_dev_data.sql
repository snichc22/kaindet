-- Kaindet development seed cleanup
-- Removes only the temporary development records created by data.sql.

BEGIN;

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

COMMIT;
