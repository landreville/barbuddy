#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER barbuddy WITH ENCRYPTED PASSWORD 'md523188df7bbde866dddfa12e8c46eee27';
    GRANT ALL PRIVILEGES ON DATABASE postgres TO barbuddy;
EOSQL

