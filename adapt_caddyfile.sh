#!/bin/sh

is_blue=`systemctl is-active derpy-tools-blue`
is_green=`systemctl is-active derpy-tools-green`

if [ "$is_blue" = "active" ]; then
    sudo sed -i "s/reverse_proxy localhost:4003/reverse_proxy localhost:4002/g" /etc/caddy/Caddyfile
    sudo systemctl restart caddy

    echo "blue"
elif [ "$is_green" = "active" ]; then
    sudo sed -i "s/reverse_proxy localhost:4002/reverse_proxy localhost:4003/g" /etc/caddy/Caddyfile
    sudo systemctl restart caddy

    echo "green"
else
    sudo systemctl start caddy

    echo "neither"
fi
