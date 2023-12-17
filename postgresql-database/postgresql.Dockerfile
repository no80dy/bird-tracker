FROM postgres:16-alpine

COPY birds-database-dump.sql /docker-entrypoint-initdb.d/