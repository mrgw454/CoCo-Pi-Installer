#!/bin/bash

cd $HOME

# install required dependencies
sudo apt -y install curl build-essential

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"

echo
rustc --version
cargo --version

echo
echo
echo Done!
echo
