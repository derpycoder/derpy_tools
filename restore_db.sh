#!/bin/sh

set -o allexport

source config/.env.prod

litestream restore -if-db-not-exists -o ../data/derpy_tools_canary.db -replica backblaze_backup /home/derpycoder/data/derpy_tools_stg.db

litestream restore -if-db-not-exists -o ../data/derpy_tools_stg.db /home/derpycoder/data/derpy_tools_stg.db
litestream restore -if-db-not-exists -o ../data/derpy_tools_prod.db /home/derpycoder/data/derpy_tools_prod.db

set +o allexport
