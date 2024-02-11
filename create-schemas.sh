#!/bin/bash
databases=("logrepl_pg_master" "logrepl_pg_replica1" "logrepl_pg_replica2")
schema_file="./schema.sql"

for db in "${databases[@]}"; do
    echo "Copying schema to $db..."
    docker cp "$schema_file" "$db:/tmp/schema.sql"

    echo "Loading schema in $db..."
    docker exec -i "$db" psql -U postgres -d postgres -f /tmp/schema.sql

    echo "Removing schema file from $db..."
    docker exec -i "$db" rm /tmp/schema.sql

    echo "Schema loaded successfully in $db!"
done
