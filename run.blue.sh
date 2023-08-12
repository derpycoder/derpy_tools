#!/bin/sh
set -eux

prod_build_blue/bin/derpy_tools eval DerpyTools.Release.migrate
prod_build_blue/bin/derpy_tools start

# Run migrations
# _build/prod/rel/derpy_tools/bin/derpy_tools eval "DerpyTools.Release.migrate"

# Run seeds
# MIX_ENV=prod mix run priv/repo/seeds.exs
