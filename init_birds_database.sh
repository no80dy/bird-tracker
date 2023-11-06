#!/usr/bin/env bash

DB_NAME="birds_database"
POSTGRES_HOST="localhost"
POSTGRES_PORT=5432

if psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U postgres -lqt | cut -d \| -f 1 | grep -wq "$DB_NAME"; then
  echo "Database $DB_NAME already exists. Skipping creation..."
else
  createdb -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U postgres "$DB_NAME"
  echo "Database $DB_NAME created successfully!"
fi

psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U postgres -d birds_database -f ./sql/birds_database.sql
