#!/bin/bash

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

awk '$1=="+"{print $2}' packages | xargs dnf install -y
awk '$1=="+weak"{print $2}' packages | xargs dnf install -y
awk '$1=="-"{print $2}' packages | xargs dnf remove -y

sudo dnf swap ffmpeg-free ffmpeg --allowerasing

ln -s /usr/bin/nvim /usr/bin/vi

updatedb

systemctl enable powertop
