#!/bin/bash

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
rm ~/.cargo/env

opam init -n
opam install -y utop dune

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

mv ~/.utoprc ./utoprc.old
cp ./utoprc ~/.utoprc

mkdir ~/.config/utop
mv ~/.config/utop/init.ml ./init.ml.old
cp init.ml ~/.config/utop/

mv ~/.config/.lambda-term-inputrc ./lambda-term-inputrc.old
cp ./lambda-term-inputrc ~/.config/.lambda-term-inputrc

mkdir -p ~/.local/bin
mv ~/.local/bin ./localbin_OLD
cp -r ./localbin ~/.local/bin
