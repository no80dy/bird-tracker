FROM postgres:16-alpine

ENV POSTGRES_DB=birds_database
COPY birds-database.sql /docker-entrypoint-initdb.d/birds-database.sql