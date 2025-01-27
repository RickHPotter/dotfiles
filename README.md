# Dotfiles Setup Guide

<!--toc:start-->
- [Dotfiles Setup Guide](#dotfiles-setup-guide)
  - [Warning](#warning)
  - [Prerequisites](#prerequisites)
  - [Step-by-Step Instructions](#step-by-step-instructions)
<!--toc:end-->

This guide will help you set up your environment using the provided scripts. Follow these steps to ensure everything is configured correctly.

## Warning

Before you begin, understand that this WILL overwrite your current environment.

## Prerequisites

Before you begin, make sure you have the necessary permissions to execute scripts. That includes being able to `sudo`. This was tested in Ubuntu.

## Step-by-Step Instructions

Open your terminal and navigate to the directory containing your scripts. Then, run the following commands:

```bash
chmod +x 01.\ sh_environment.sh
```

Then, run the following commands to execute the scripts:

```bash
source ~/.bashrc
ruby main.rb --except-neovim [--no-postgres --no-oracle --no-flutter no-kitty --no-fonts --no-git]
ruby main.rb --only-neovim

source ~/.bashrc

# MAKE kitty default
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which kitty) 50
update-alternatives --display x-terminal-emulator # check
gsettings set org.gnome.desktop.default-applications.terminal exec $(which kitty)
gsettings get org.gnome.desktop.default-applications.terminal exec # check
# CTRL+ALT+T now opens Kitty instead of the default terminal

cshs $(which zsh) # might be necessary
t_fin
CTRL + A + I # install tmux plugins
```
