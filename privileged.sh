#!/bin/bash

ln -s /usr/bin/nvim /usr/bin/vim

awk '$1=="INSTALL"{print $2}' packages | xargs dnf install -y
awk '$1=="REMOVE"{print $2}' packages | xargs dnf remove -y
