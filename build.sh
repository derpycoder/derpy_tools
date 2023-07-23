#!/usr/bin/env bash
# exit on error
set -o errexit

mix local.hex --force
mix local.rebar --force
mix phx.digest.clean --all

rm -rf _build

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
MIX_ENV=prod mix assets.deploy

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite

# Run migrations
# _build/prod/rel/derpy_tools/bin/derpy_tools eval "DerpyTools.Release.migrate"

# Run seeds
# MIX_ENV=prod mix run priv/repo/seeds.exs
