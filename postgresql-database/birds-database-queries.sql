-- Выбрать всех птиц с дополнительной информацией о количестве наблюдений
SELECT b.* COUNT(bo.id) AS observation_count
FROM content.birds b
LEFT JOIN content.bird_observations bo ON b.id = bo.user_id
GROUP BY b.id;

-- Выбрать ТОП-5 пользователей с наибольшим числом наблюдений
SELECT u.username, COUNT(bo.id) AS observation_count
FROM content.users u
LEFT JOIN content.bird_observations bo ON u.id = bo.user_id
GROUP BY u.id
ORDER BY observation_count DESC
LIMIT 5;

-- Выбрать все наблюдения птиц с дополнительной информацией о количестве прикрепленных изображений
SELECT bo.*, COUNT(bi.id) AS image_count
FROM content.users u
LEFT JOIN content.bird_images bi ON bo.id = bi.observation_id
GROUP BY bo.id;

-- Выбрать все семейства птиц с указанием количества видов в каждом семействе
SELECT bf.*, COUNT(DISTINCT bs.id) AS status_count
FROM content.birds b
LEFT JOIN content.bird_statuses bs ON b.status_id = bs.id
GROUP BY b.id
HAVING COUNT(DISTINCT bs.id) > 1;

-- Выбрать все наблюдения птиц, сделанные пользователями, зарегистрированными более года назад
SELECT bo.*
FROM content.bird_observations bo
JOIN content.users u ON bo.user_id = u.id
WHERE u.created_at <= NOW() - INTERVAL '1 year';

-- Выбрать все изображения птиц, принадлежащие наблюдениям птиц с определенным статусом
SELECT bi.*
FROM content.bird_images bi
JOIN content.bird_observations bo ON bi.observations_id = bo.id
JOIN content.birds b ON bo.bird_id = b.id
WHERE b.status_id = (SELECT id FROM content.bird_statuses WHERE status_name = 'Красная книга');

-- Выбрать все изображени птицы с определенным именем
SELECT bi.*
FROM content.bird_images bi
JOIN content.bird_observations bo ON bi.observation_id = bo.id
JOIN content.birds b ON bo.bird_id = b.id
WHERE b.bird_name = 'Чижик';

-- Выбрать всех наблюдений о пттицах с общей информацией
SELECT bo.id AS observation_id, bo.observation_name, bo.gender, bo.description, bl.longitude, bl.latitude, b.bird_name, u.username
FROM content.bird_observations bo
JOIN content.bird_locations bl ON bo.location_id = bl.id
JOIN content.birds b ON bo.bird_id = b.id
LEFT JOIN content.users u ON bo.user_id = u.id;

-- Выбрать все наблюдения за птицами, связанные с определенным пользователем
SELECT * FROM content.bird_observations WHERE user_id = 'user_id';

-- Выбрать всех птиц с указанием  их статуса и семейства
SELECT b.*, bs.status_name, bf.family_name
FROM content.birds b
JOIN content.bird_statuses bs ON b.status_id = bs.id
JOIN content.bird_families bf ON b.family_id = bf.id;

-- Выбрать все наблюдения птиц в определенном временном диапазоне
SELECT * FROM content.bird_observations
WHERE created_at BETWEEN 'start_date' AND 'end_date';

-- Выбрать общую информацию о пользователях и их наблюдениях
SELECT u.id AS user_id, u.username, bo.*
FROM content.users u
LEFT JOIN content.bird_observations bo ON u.id = bo.user_id;

-- Выбрать все изображения, добавленные в последний месяц
SELECT * FROM content.bird_images
WHERE created_at >= NOW() - INTERVAL '1 month';


-- Выбрать всех птиц определенного статуса
SELECT * FROM content.birds
WHERE status_id = (SELECT id FROM content.bird_statuses WHERE status_name = 'Красная книга');

-- Выбрать всех птиц определенной локации
SELECT * FROM content.bird_observations WHERE location_id = '<id_локации>';

