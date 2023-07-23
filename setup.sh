#!/bin/sh
set -eux

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

echo -e ". "$HOME/.asdf/asdf.sh"\n. "$HOME/.asdf/completions/asdf.bash"" >> ~/.bashrc
source ~/.bashrc

asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"

asdf install

sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh --stable-channel --disable-telemetry
