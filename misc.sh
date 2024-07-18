#!/bin/bash

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
rm ~/.cargo/env
~/.cargo/bin/rustup component add rust-src
~/.cargo/bin/rustup component add rust-analyzer

mkdir ~/workspace

mkdir ~/.config/git
touch ~/.config/git/config
git config --global pull.ff only
git config --global pager.diff "/usr/share/git-core/contrib/diff-highlight | less"
git config --global init.defaultBranch master
git config --global merge.conflictstyle diff3

touch ~/Templates/empty

mv ~/.bashrc ./bashrc.old
cp ./bashrc ~/.bashrc

mv ~/.irbrc ./irbrc.old
cp ./irbrc ~/.irbrc

mkdir -p ~/.local/bin
mv ~/.local/bin ./localbin_OLD
cp -r ./localbin ~/.local/bin

mkdir -p ~/.local/share/scramble_notif
cp -n ./tnoodle-cli.jar ~/.local/share/scramble_notif
cp ./scramblenotif.sh ~/.local/share/scramble_notif
