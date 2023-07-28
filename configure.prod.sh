#!/bin/sh
set -eux

sudo cp services/prod-blue.service /usr/lib/systemd/system/derpy-tools-blue.service
sudo cp services/prod-green.service /usr/lib/systemd/system/derpy-tools-green.service
sudo cp Caddyfile /etc/caddy/Caddyfile

sudo sed -i "s/  tls/  # tls/g" /etc/caddy/Caddyfile # Comment out certs
sudo chmod u=r /etc/caddy/Caddyfile

sudo systemctl daemon-reload

sudo systemctl restart caddy
sudo systemctl enable --now caddy

cp run.blue.sh ../run.blue.sh
cp run.green.sh ../run.green.sh
