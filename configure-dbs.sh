#!/bin/bash

max_number_of_replicas=4
max_wal_senders=8

# List of all PostgreSQL instances (including master and replicas)
databases=("logrepl_pg_master" "logrepl_pg_replica1" "logrepl_pg_replica2")

for db in "${databases[@]}"; do
    echo "Configuring PostgreSQL instance $db for logical replication..."
    docker exec -i "$db" bash -c "sed -i 's/^#*wal_level .*$/wal_level = logical/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "sed -i 's/^#*max_replication_slots .*$/max_replication_slots = $max_number_of_replicas/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "sed -i 's/^#*max_wal_senders .*$/max_wal_senders = $max_wal_senders/' /var/lib/postgresql/data/postgresql.conf"
    docker exec -i "$db" bash -c "grep -qxF 'host replication all all md5' /var/lib/postgresql/data/pg_hba.conf || echo 'host replication all all md5' >> /var/lib/postgresql/data/pg_hba.conf"

    echo "Restarting PostgreSQL instance $db to apply configuration changes..."
    docker restart "$db"
done

# Wait for the databases to restart, adjust the sleep as needed
sleep 2

echo "All PostgreSQL instances configured successfully for logical replication."