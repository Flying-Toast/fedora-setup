#!/bin/bash

cd $(dirname $(realpath $0))

mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
mv ~/.config/nvim/init.vim init.vim.old

#install vim-plug:
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cat config.vim >> ~/.config/nvim/init.vim
vim -c "PlugInstall | PlugUpdate | qa"
