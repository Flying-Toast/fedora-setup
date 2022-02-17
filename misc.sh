#!/bin/bash

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
rm ~/.cargo/env

mkdir ~/workspace

mkdir ~/.config/git
touch ~/.config/git/config
git config --global pull.ff only
git config --global pager.diff "/usr/share/git-core/contrib/diff-highlight | less"
git config --global init.defaultBranch master

touch ~/Templates/empty

mv ~/.bashrc ./bashrc.old
cp ./bashrc ~/.bashrc

mkdir -p ~/.local/bin
mv ~/.local/bin ./localbin_OLD
cp -r ./localbin ~/.local/bin
