#!/usr/bin/env zsh

set -e

ruby main.rb --except-neovim
source ~/.zshrc
ruby main.rb --only_neovim
source ~/.zshrc
