# DerpyTools

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Deployment

- git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
- echo -e ". "$HOME/.asdf/asdf.sh"\n. "$HOME/.asdf/completions/asdf.bash"" >> ~/.bashrc

- source ~/.bashrc
- asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
- asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

- sudo apt-get install zip unzip libssl-dev make automake autoconf libncurses5-dev gcc g++
- export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
- export ERL_AFLAGS="-kernel shell_history enabled"

- asdf install

- rm -rf _build
- mix local.hex --force
- mix local.rebar --force
- mix phx.digest.clean --all
- bash build.sh

- export HOSTNAME=derpytools.site
- _build/prod/rel/derpy_tools/bin/derpy_tools eval "DerpyTools.Release.migrate" && _build/prod/rel/derpy_tools/bin/derpy_tools start


- sudo systemctl enable --now caddy
- sudo cp Caddyfile /etc/caddy/Caddyfile
- sudo nano /etc/caddy/Caddyfile
- sudo systemctl reload caddy

- sudo caddy run

- brew install kevinburke/safe/hostsfile

## For Staging Environment
- mkcert derpytools derpytools.site "*.derpytools.site" localhost 127.0.0.1 ::1
- mkdir -p certs/caddy
- mv derpytools+5.pem certs/caddy/cert.pem
- mv derpytools+5-key.pem certs/caddy/key.pem

- sudo hostsfile add derpytools.site 127.0.0.1
- sudo hostsfile add derpytools.site www.derpytools.site 192.168.64.16
- cat /etc/hosts

## Clone to get the data
- ssh-keygen -o -t ed25519 -C "abhijit@derpytools.com"
- cat ~/.ssh/id_ed25519.pub
Put the public key in SSH key of the profile. To be able to clone the private repo.
- git clone git@github.com:derpycoder/derpy_tools.git


- multipass launch -c 1 -m 1G -d 10G -n north-blue jammy --cloud-init cloud-init.yaml
- multipass launch -c 1 -m 1G -d 10G -n south-blue jammy --cloud-init cloud-init.yaml
- code ~/.ssh/config (Then change the IP Addresses)

- cloud-init schema --config-file cloud-init.yaml


## Systemd

- sudo cp services/derpy-tools.service /usr/lib/systemd/system/derpy-tools.service

- sudo systemctl start derpy-tools
- sudo systemctl stop derpy-tools
- sudo journalctl -f -u derpy-tools

- sudo systemctl daemon-reload
- sudo systemctl enable --now caddy
- sudo systemctl enable --now derpy-tools

- sudo cp Caddyfile /etc/caddy/Caddyfile
- sudo cp -r certs/ /etc/systemd/system/certs
- sudo nano /etc/caddy/Caddyfile

tls /etc/systemd/system/certs/caddy/cert.pem /etc/systemd/system/certs/caddy/key.pem

- sudo chmod a=r /etc/systemd/system/certs/caddy/cert.pem
- sudo chmod a=r /etc/systemd/system/certs/caddy/key.pem

- systemctl status caddy
- sudo journalctl -f -u caddy

- sudo systemctl reload caddy
- sudo systemctl stop caddy

- mkpasswd -m bcrypt
- mkpasswd -m sha-512


# Automatically done by install script, but other tools can use similar approach

- sudo groupadd --system caddy
- sudo useradd --system \
    --gid caddy \
    --create-home \
    --home-dir /var/lib/caddy \
    --shell /usr/sbin/nologin \
    --comment "Caddy web server" \
    caddy

- brew install benbjohnson/litestream/litestream

- wget https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64.deb
- sudo dpkg -i litestream-v0.3.9-linux-amd64.deb

- sudo systemctl enable litestream
- sudo systemctl start litestream

- sudo journalctl -u litestream -f

https://litestream.io/reference/config/

/etc/litestream.yml

dbs:
  - path: /var/lib/db
    replicas:
      - name: storj_backup
        type:   s3
        bucket: litestream.storj.io
        path:   db
        validation-interval: 6h

      <!-- - name: minio_backup
        type: s3
        bucket: litestream.min.io
        path: db
        skip-verify: true -->

      - name: local_backup
        path: /backup/db

- sudo systemctl restart litestream

- litestream replicate -config litestream.yml

- litestream restore -config litestream.yml -replica local_backup -o fruits2.db fruits.db
- litestream restore -config litestream.yml -replica backblaze_backup -o fruits3.db fruits.db

- litestream restore -if-db-not-exists -config litestream.yml -o fruits.db fruits.db

- litestream databases -config litestream.yml
- litestream snapshots -config litestream.yml fruits.db
- litestream generations -config litestream.yml fruits.db

- brew install --cask db-browser-for-sqlite

- sudo apt install sqlite3


## Env Variable Set
- set -o allexport (To set every env variable in a .env file to be exported)
- source derpy_tools/config/.env.prod
- set +o allexport


- exec prod_build_green/rel/derpy_tools/bin/derpy_tools start
- exec prod_build_blue/rel/derpy_tools/bin/derpy_tools start

## Grafana & Prometheus

- brew install prometheus
- prometheus --config.file prometheus.yml

- brew install grafana
- brew services start Grafana

- ${HOMEBREW_PREFIX}/share/grafana (Grafana homepath)
- code /opt/homebrew/share/grafana/conf/defaults.ini

- grafana cli --homepath ${HOMEBREW_PREFIX}/share/grafana admin reset-admin-password wubalubadubdub

- admin, wubalubadubdub

## Setting up PromEx
(YOUR_PROMETHEUS_DATASOURCE_ID=prometheus)
- mix prom_ex.gen.config --datasource prometheus

- multipass set local.north-blue.memory=2G

<!-- - scp -rp ../derpy_tools/. north-blue:derpy_tools -->
<!-- Ignore deps, data -->
- rsync -ruPlhS --stats --exclude-from .rsyncignore ./ east-blue:derpy_tools
- bash harden.sh
- bash setup.sh
- source ~/.bashrc
- bash install.sh
- bash configure.stg.sh
- bash build_and_run.sh

- bash swap_builds.sh
- bash build_canary.sh
