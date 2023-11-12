FROM postgres:15-alpine

COPY birds-database.sql /docker-entrypoint-initdb.d/birds-database.sql