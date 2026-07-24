#!/bin/bash

{
    echo  "# "
    "# Configure Terminal colors"
    "source ~/_1_terminal_colors.sh"
} >> ~/.profile

source "~/.profile"
bind -d ~/.inputrc
