#!/bin/bash
old_master="logrepl_pg_master"
new_master="logrepl_pg_replica1"
old_master_subscription="my_subscription"

docker start $old_master
sleep 1

# Disable any outgoing replication from the old master
echo "Disabling any publications on $old_master..."
docker exec -i "$old_master" psql -U postgres -d postgres -c "DROP PUBLICATION IF EXISTS my_publication;"

# Create a new subscription on the old master to the new master's publication
docker exec -i "$old_master" psql -U postgres -d postgres -c "DROP SUBSCRIPTION IF EXISTS $old_master_subscription;"
docker exec -i "$old_master" psql -U postgres -d postgres -c "CREATE SUBSCRIPTION $old_master_subscription CONNECTION 'dbname=postgres host=$new_master user=postgres password=postgres' PUBLICATION new_master_publication;"

echo "Subscription setup complete. $old_master is now a subscriber of $new_master."
