-- Получение информации о птице по её UUID
CREATE OR REPLACE FUNCTION content.get_bird_info(
    p_bird_id UUID
) RETURNS TABLE (
    bird_name VARCHAR(30),
    scientific_name VARCHAR(30),
    description TEXT,
    location_name VARCHAR(50),
    longitude FLOAT,
    latitude FLOAT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.bird_name,
        b.scientific_name,
        b.description,
        l.location_name,
        l.longitude,
        l.latitude
    FROM
        content.birds b
    INNER JOIN
        content.bird_observations bo ON b.id = bo.bird_id
    INNER JOIN
        content.bird_locations l ON bo.location_id = l.id
    WHERE
        b.id = p_bird_id;
END;
$$ LANGUAGE plpgsql;

