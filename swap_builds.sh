#!/bin/sh

is_blue=`systemctl is-active derpy-tools-blue`
is_green=`systemctl is-active derpy-tools-green`

if [ "$is_blue" != "active" ] && [ $is_green != "active" ]; then
    sudo sed -i "s/reverse_proxy localhost:4003/reverse_proxy localhost:4002/g" /etc/caddy/Caddyfile

    sudo systemctl start derpy-tools-blue
    sudo systemctl enable --now derpy-tools-blue

    sudo systemctl restart caddy

    echo "blue"
elif [ "$is_blue" = "active" ]; then
    sudo sed -i "s/reverse_proxy localhost:4002/reverse_proxy localhost:4003/g" /etc/caddy/Caddyfile

    sudo systemctl stop derpy-tools-blue
    sudo systemctl disable derpy-tools-blue
    sudo systemctl start derpy-tools-green
    sudo systemctl enable --now derpy-tools-green

    sudo systemctl restart caddy

    echo "green"
else
    sudo sed -i "s/reverse_proxy localhost:4003/reverse_proxy localhost:4002/g" /etc/caddy/Caddyfile

    sudo systemctl stop derpy-tools-green
    sudo systemctl disable derpy-tools-green
    sudo systemctl start derpy-tools-blue
    sudo systemctl enable --now derpy-tools-blue

    sudo systemctl restart caddy

    echo "blue"
fi
