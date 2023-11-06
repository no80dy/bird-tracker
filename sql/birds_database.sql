CREATE SCHEMA IF NOT EXISTS content;

CREATE TABLE IF NOT EXISTS content.bird_statuses (
    id UUID PRIMARY KEY,
    status_name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS content.bird_families (
    id UUID PRIMARY KEY,
    family_name VARCHAR(30) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS content.bird_locations(
    id UUID PRIMARY KEY,
    longitude FLOAT,
    latitude FLOAT
);


CREATE TABLE IF NOT EXISTS content.users (
    id UUID PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL,
    password_hash VARCHAR(30) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS content.birds (
    id UUID PRIMARY KEY,
    bird_name VARCHAR(30) NOT NULL,
    scientific_name VARCHAR(30),
    description TEXT,
    status_id UUID NOT NULL REFERENCES content.bird_statuses (id) ON DELETE CASCADE,
    family_id UUID NOT NULL REFERENCES content.bird_families (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS content.bird_observations (
    id UUID PRIMARY KEY,
    location_id UUID NOT NULL REFERENCES content.bird_locations (id) ON DELETE CASCADE,
    bird_id UUID NOT NULL REFERENCES content.birds (id) ON DELETE CASCADE,
    user_id UUID REFERENCES content.users (id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE,
    gender TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS content.bird_images (
    id UUID PRIMARY KEY,
    observation_id UUID NOT NULL REFERENCES content.bird_observations (id) ON DELETE CASCADE,
    image TEXT NOT NULL
);