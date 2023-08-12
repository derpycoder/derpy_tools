#!/bin/sh

set -o allexport

litestream restore -if-db-not-exists -o ../data/derpy_tools_canary.db -replica local_backup /home/derpycoder/data/derpy_tools_stg.db

source config/.env.canary.stg
_build/prod/rel/derpy_tools/bin/derpy_tools start

set +o allexport
