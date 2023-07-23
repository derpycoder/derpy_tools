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
- asdf plugin-add caddy https://github.com/salasrod/asdf-caddy.git

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
- exec _build/prod/rel/derpy_tools/bin/derpy_tools eval "DerpyTools.Release.migrate" && _build/prod/rel/derpy_tools/bin/derpy_tools start


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
