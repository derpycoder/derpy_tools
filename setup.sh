#!/bin/sh
set -eux

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

echo -e ". "$HOME/.asdf/asdf.sh"\n. "$HOME/.asdf/completions/asdf.bash"" >> ~/.bashrc
