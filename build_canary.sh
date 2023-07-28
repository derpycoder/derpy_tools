#!/usr/bin/env bash
# exit on error
set -o errexit

mix local.hex --force
mix local.rebar --force
mix phx.digest.clean --all

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
MIX_ENV=prod mix assets.deploy

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite
