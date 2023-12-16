-- Выбрать всех птиц с дополнительной информацией о количестве наблюдений
SELECT b.bird_name, b.scientific_name, COUNT(bo.id) AS observation_count
FROM content.birds b
LEFT JOIN content.bird_observations bo ON b.id = bo.bird_id
GROUP BY b.id;

-- Выбрать ТОП-5 пользователей с наибольшим числом наблюдений
SELECT u.username, COUNT(bo.id) AS observation_count
FROM content.users u
LEFT JOIN content.bird_observations bo ON u.id = bo.user_id
GROUP BY u.id
ORDER BY observation_count DESC
LIMIT 5;

-- Выбрать все наблюдения птиц с дополнительной информацией о количестве прикрепленных изображений
SELECT bo.observation_name, COUNT(bi.id) AS image_count
FROM content.bird_observations bo
LEFT JOIN content.bird_images bi ON bo.id = bi.observation_id
GROUP BY bo.id;

-- Выбрать все семейства птиц с указанием количества видов в каждом семействе
SELECT bf.family_name, COUNT(b.id) AS status_count
FROM content.bird_families bf
LEFT JOIN content.birds b ON bf.id = b.family_id
GROUP BY bf.family_name, bf.id;

-- Выбрать все наблюдения птиц, сделанные пользователями, зарегистрированными более года назад
SELECT
    bo.*
FROM
    content.bird_observations bo
JOIN
    content.users u ON bo.user_id = u.id
WHERE
    u.created_at <= CURRENT_TIMESTAMP AT TIME ZONE 'UTC' - INTERVAL '1 year';


-- Выбрать все изображения птиц, принадлежащие наблюдениям птиц с определенным статусом
SELECT bi.image, b.name, b
FROM content.bird_images bi
JOIN content.bird_observations bo ON bi.observation_id = bo.id
JOIN content.birds b ON bo.bird_id = b.id
WHERE b.status_id = (SELECT id FROM content.bird_statuses WHERE status_name = 'Вызывающий наименьшее опасение');

-- Выбрать все изображени птицы с определенным именем
SELECT bi.*
FROM content.bird_images bi
JOIN content.bird_observations bo ON bi.observation_id = bo.id
JOIN content.birds b ON bo.bird_id = b.id
WHERE b.bird_name = 'Красная утка';

-- Выбрать всех наблюдений о пттицах с общей информацией
SELECT bo.id AS observation_id, bo.observation_name, bo.gender, bo.description, bl.longitude, bl.latitude, b.bird_name, u.username
FROM content.bird_observations bo
JOIN content.bird_locations bl ON bo.location_id = bl.id
JOIN content.birds b ON bo.bird_id = b.id
LEFT JOIN content.users u ON bo.user_id = u.id;

-- Выбрать все наблюдения за птицами, связанные с определенным пользователем
SELECT * FROM content.bird_observations WHERE user_id = 'user_id';

-- Выбрать всех птиц с указанием  их статуса и семейства
SELECT b.bird_name, bs.status_name, bf.family_name
FROM content.birds b
JOIN content.bird_statuses bs ON b.status_id = bs.id
JOIN content.bird_families bf ON b.family_id = bf.id;

-- Выбрать все наблюдения птиц в определенном временном диапазоне
SELECT * FROM content.bird_observations
WHERE created_at BETWEEN 'start_date' AND 'end_date';

-- Выбрать общую информацию о пользователях и их наблюдениях
SELECT u.id AS user_id, u.username, bo.observation_name
FROM content.bird_observations bo
LEFT JOIN content.users u ON u.id = bo.user_id;

-- Выбрать все изображения, добавленные в последний месяц
SELECT * FROM content.bird_images
WHERE created_at >= NOW() - INTERVAL '1 month';


-- Выбрать всех птиц определенного статуса
SELECT * FROM content.birds
WHERE status_id = (SELECT id FROM content.bird_statuses WHERE status_name = 'Красная книга');

-- Выбрать всех птиц определенной локации
SELECT * FROM content.bird_observations WHERE location_id = '<id_локации>';


-- Посчитать количество наблюдений птиц каждым пользователем
SELECT
    users.username,
    COUNT(bird_observations.id) AS observation_count
FROM
    content.users
LEFT JOIN
    content.bird_observations ON users.id = bird_observations.user_id
GROUP BY
    users.username;


-- Выбор птиц, для которых нет наблюдений
SELECT
    birds.bird_name
FROM
    content.birds
LEFT JOIN
    content.bird_observations ON birds.id = bird_observations.bird_id
WHERE
    bird_observations.id IS NULL;


-- Получение среднего количества птиц в различных локациях
SELECT
    bird_locations.location_name,
    birds.bird_name,
    COALESCE(AVG(observation_count), 0) AS avg_observations
FROM
    content.bird_locations
CROSS JOIN
    content.birds
LEFT JOIN (
    SELECT
        bird_id,
        COUNT(*) AS observation_count
    FROM
        content.bird_observations
    GROUP BY
        bird_id
) AS bird_obs_count ON birds.id = bird_obs_count.bird_id
GROUP BY
    bird_locations.location_name, birds.bird_name;


-- Получение информации о птицах в определенной локации
SELECT
    bird_observations.observation_name,
    bird_observations.gender,
    bird_observations.description,
    bird_locations.location_name,
    birds.bird_name,
    bird_statuses.status_name
FROM
    content.bird_observations
JOIN
    content.bird_locations ON bird_observations.location_id = bird_locations.id
JOIN
    content.birds ON bird_observations.bird_id = birds.id
JOIN
    content.bird_statuses ON birds.status_id = bird_statuses.id
WHERE
    bird_locations.location_name = 'Озеро Чёрное';


-- Выбор пользователей, которые сделали наблюдения в разных локациях и увидели более одной разновидности птиц
SELECT
    users.username,
    COUNT(DISTINCT bird_observations.location_id) AS distinct_locations_count,
    COUNT(DISTINCT bird_observations.bird_id) AS distinct_birds_count
FROM
    content.users
JOIN
    content.bird_observations ON users.id = bird_observations.user_id
GROUP BY
    users.username
HAVING
    COUNT(DISTINCT bird_observations.location_id) > 1
    AND COUNT(DISTINCT bird_observations.bird_id) > 1;
