#!/bin/bash
docker compose down
docker volume rm logrepl_pg_master-data logrepl_pg_replica1-data logrepl_pg_replica2-data
