FROM postgres:10.3-alpine

ENV POSTGRES_PASSWORD

COPY setup.sh /docker-entrypoint-initdb.d/0-setup.sh
COPY backup.sql /docker-entrypoint-initdb.d/1-backup.sql
#COPY schema.sql /docker-entrypoint-initdb.d/1-schema.sql
#COPY data.sql /docker-entrypoint-initdb.d/2-data.sql
