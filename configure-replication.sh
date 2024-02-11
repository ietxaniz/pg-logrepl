#!/bin/bash

# Define the master database and the replicas
master_db="logrepl_pg_master"
replicas=("logrepl_pg_replica1" "logrepl_pg_replica2")

# Configure the master database
echo "Configuring $master_db as master..."
docker exec -i "$master_db" psql -U postgres -d postgres -c "DROP PUBLICATION IF EXISTS my_publication;"
docker exec -i "$master_db" psql -U postgres -d postgres -c "CREATE PUBLICATION my_publication FOR ALL TABLES;"

# Configure each replica to follow the master
for replica in "${replicas[@]}"; do
    echo "Configuring $replica to replicate from $master_db..."

    # Construct the connection string
    conninfo="host=$master_db port=5432 user=postgres password=postgres dbname=postgres"

    # Configure the subscription on the replica
    docker exec -i "$replica" psql -U postgres -d postgres -c "DROP SUBSCRIPTION IF EXISTS ${replica}_subscription;"
    docker exec -i "$replica" psql -U postgres -d postgres -c "CREATE SUBSCRIPTION ${replica}_subscription CONNECTION 'dbname=postgres host=$master_db user=postgres password=postgres' PUBLICATION my_publication;"

    echo "$replica configured to replicate from $master_db."
done

echo "Master and replicas configured successfully for logical replication."
