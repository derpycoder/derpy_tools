#!/bin/sh
set -eux

sudo cp services/stg-blue.service /usr/lib/systemd/system/derpy-tools-blue.service
sudo cp services/stg-green.service /usr/lib/systemd/system/derpy-tools-green.service
sudo cp services/litestream.service /lib/systemd/system/litestream.service
sudo cp Caddyfile /etc/caddy/Caddyfile
sudo cp litestream.yml /etc/litestream.yml

sudo sed -i "s/tls \/certs/# tls \/certs/g" /etc/caddy/Caddyfile # Comment out dev certs
sudo sed -i "s/# tls \/etc/tls \/etc/g" /etc/caddy/Caddyfile # Enable stg certs
sudo chmod a=r /etc/caddy/Caddyfile

sudo cp -r certs/caddy/* /etc/caddy/certs
sudo mkdir /etc/caddy/certs -p
sudo chmod a=r /etc/caddy/certs/cert.pem
sudo chmod a=r /etc/caddy/certs/key.pem

sudo systemctl daemon-reload

sudo systemctl enable --now caddy

bash adapt_caddyfile.sh

sudo systemctl enable litestream
sudo systemctl restart litestream

cp run.blue.sh ../run.blue.sh
cp run.green.sh ../run.green.sh
