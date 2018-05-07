FROM postgres:10.3-alpine

ENV POSTGRES_PASSWORD=lxbrVAT8kALZ

COPY setup.sh /docker-entrypoint-initdb.d/0-setup.sh
COPY schema.sql /docker-entrypoint-initdb.d/1-schema.sql
