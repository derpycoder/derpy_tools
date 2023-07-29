#!/bin/sh
set -eux

sudo cp services/prod-blue.service /usr/lib/systemd/system/derpy-tools-blue.service
sudo cp services/prod-green.service /usr/lib/systemd/system/derpy-tools-green.service
sudo cp services/litestream.service /lib/systemd/system/litestream.service
sudo cp services/caddy.service /lib/systemd/system/caddy.service
sudo cp Caddyfile /etc/caddy/Caddyfile
sudo cp litestream.yml /etc/litestream.yml

sudo sed -i "s/  tls/  # tls/g" /etc/caddy/Caddyfile # Comment out certs
sudo chmod u=r /etc/caddy/Caddyfile

sudo systemctl daemon-reload

sudo systemctl enable --now caddy

bash adapt_caddyfile.sh

sudo systemctl restart litestream
sudo systemctl start litestream

cp run.blue.sh ../run.blue.sh
cp run.green.sh ../run.green.sh
