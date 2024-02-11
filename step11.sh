#!/bin/bash
docker exec -i logrepl_pg_replica1 psql -U postgres -d postgres -c "INSERT INTO users (username, email) VALUES ('newuser5', 'newuser5@example.com');"
./step02.sh
