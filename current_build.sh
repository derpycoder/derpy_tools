#!/bin/sh

is_blue=`systemctl is-active derpy-tools-blue`
is_green=`systemctl is-active derpy-tools-green`

if [ "$is_blue" = "active" ]; then
    echo "blue"
elif [ "$is_green" = "active" ]; then
    echo "green"
else
    echo "neither"
fi
