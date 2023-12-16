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
