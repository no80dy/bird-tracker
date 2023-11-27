FROM postgres:16-alpine

COPY birds-database.sql /docker-entrypoint-initdb.d/