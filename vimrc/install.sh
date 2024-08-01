#!/bin/bash

cd $(dirname $(realpath $0))

mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
mv ~/.config/nvim/init.vim init.vim.old

PLUG_INSTALL_TO=~/.local/share/nvim/site/autoload/plug.vim
[ ! -e $PLUG_INSTALL_TO ] && curl -fLo $PLUG_INSTALL_TO --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cat config.vim >> ~/.config/nvim/init.vim
nvim -c "PlugInstall | qa"
