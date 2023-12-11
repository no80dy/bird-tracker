CREATE SCHEMA IF NOT EXISTS content;

SET search_path TO public,content;

CREATE TABLE IF NOT EXISTS content.bird_statuses (
    id UUID PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.bird_families (
    id UUID PRIMARY KEY,
    family_name VARCHAR(30) NOT NULL,
    description TEXT,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.bird_locations(
    id UUID PRIMARY KEY,
    longitude FLOAT,
    latitude FLOAT,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.users (
    id UUID PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.birds (
    id UUID PRIMARY KEY,
    bird_name VARCHAR(30) NOT NULL,
    scientific_name VARCHAR(30),
    description TEXT,
    status_id UUID NOT NULL REFERENCES content.bird_statuses (id) ON DELETE CASCADE,
    family_id UUID NOT NULL REFERENCES content.bird_families (id) ON DELETE CASCADE,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.bird_observations (
    id UUID PRIMARY KEY,
    observation_name VARCHAR(30) NOT NULL,
    location_id UUID NOT NULL REFERENCES content.bird_locations (id) ON DELETE CASCADE,
    bird_id UUID NOT NULL REFERENCES content.birds (id) ON DELETE CASCADE,
    user_id UUID REFERENCES content.users (id) ON DELETE CASCADE,
    gender TEXT NOT NULL,
    description TEXT,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.bird_images (
    id UUID PRIMARY KEY,
    observation_id UUID NOT NULL REFERENCES content.bird_observations (id) ON DELETE CASCADE,
    image TEXT NOT NULL,

    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

-- Set time for created_at and updated_at automatically before INSERT, UPDATE
CREATE OR REPLACE FUNCTION content.update_timestamps()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    IF TG_OP = 'INSERT' THEN
       NEW.created_at = NOW();
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the hash_password function
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION content.hash_password()
RETURNS TRIGGER AS $$
BEGIN
    NEW.password_hash := crypt(NEW.password_hash, gen_salt('bf'));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the hash_password_trigger trigger
CREATE TRIGGER hash_password
BEFORE INSERT ON content.users
FOR EACH ROW EXECUTE FUNCTION content.hash_password();

CREATE TRIGGER bird_statuses_timestamp
BEFORE INSERT OR UPDATE ON content.bird_statuses
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER bird_families_timestamp
BEFORE INSERT OR UPDATE ON content.bird_families
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER bird_locations_timestamp
BEFORE INSERT OR UPDATE ON content.bird_locations
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER users_timestamp
BEFORE INSERT OR UPDATE ON content.users
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER birds_timestamp
BEFORE INSERT OR UPDATE ON content.birds
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER bird_observations_timestamp
BEFORE INSERT OR UPDATE ON content.bird_observations
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

CREATE TRIGGER bird_images_timestamp
BEFORE INSERT OR UPDATE ON content.bird_images
FOR EACH ROW EXECUTE FUNCTION content.update_timestamps();

-- INSERT INTO content.users (id, username, email, password_hash) VALUES ('0b469d87-82cd-4544-a01e-8d99c167a81f', 'user', 'user@example.com', 'Gfhjkm0995')
