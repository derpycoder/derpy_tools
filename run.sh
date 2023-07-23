#!/bin/sh
set -eux

# TODO: Move both starts to Systemd

caddy start

_build/prod/rel/derpy_tools/bin/derpy_tools migrate && _build/prod/rel/derpy_tools/bin/derpy_tools start
