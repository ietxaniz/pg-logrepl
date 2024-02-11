#!/bin/bash
docker exec -i logrepl_pg_master psql -U postgres -d postgres -c "INSERT INTO users (username, email) VALUES ('newuser', 'newuser@example.com');"
