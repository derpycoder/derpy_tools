#!/bin/sh

set -o allexport

source config/.env.canary.prod
_build/prod/rel/derpy_tools/bin/derpy_tools start

set +o allexport
