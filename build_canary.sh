#!/usr/bin/env bash
# exit on error
set -o errexit

rm -rf ../data/derpy_tools_canary.db
rm -rf ../data/derpy_tools_canary.db-shm
rm -rf ../data/derpy_tools_canary.db-wal

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
MIX_ENV=prod mix assets.deploy

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite
