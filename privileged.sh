#!/bin/bash

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

awk '$1=="+"{print $2}' packages | xargs dnf install -y
awk '$1=="-"{print $2}' packages | xargs dnf remove -y

ln -s "/home/$SUDO_USER/.local/share/nvim-0.9.5/bin/nvim" /usr/bin/vim

updatedb

systemctl enable powertop
