CREATE INDEX idx_bird_statuses_status_name ON content.bird_statuses (status_name);

CREATE INDEX idx_bird_families_family_name ON content.bird_families (family_name);

CREATE INDEX idx_bird_locations_location_name ON content.bird_locations (location_name);

CREATE INDEX idx_birds_bird_name ON content.birds (bird_name);
CREATE INDEX idx_birds_scientific_name ON content.birds (scientific_name);
CREATE INDEX idx_birds_status_family_id ON content.birds (status_id, family_id);

CREATE INDEX idx_bird_observations_observation_name ON content.bird_observations (observation_name);
CREATE INDEX idx_bird_observations_location_bird_id ON content.bird_observations (location_id, bird_id);
CREATE INDEX idx_bird_observations_user_id ON content.bird_observations (user_id);
