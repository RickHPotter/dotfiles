#!/bin/bash

set -e

RED="\e[31m"
GREEN="\e[32m"
WHITE="\e[37m"
BOLD="\e[1m"
RESET="\e[0m"

BG_BLACK="\e[40m"

INFO="${BG_BLACK}${WHITE}${BOLD}"
SUCCESS="${BG_BLACK}${GREEN}${BOLD}"
ERROR="${BG_BLACK}${RED}${BOLD}"

run_command() {
	echo -e "${INFO}Running: ${1}${RESET}"
	eval $1
	if [ $? -ne 0 ]; then
		echo -e "${ERROR}Error: Command failed - ${1}${RESET}"
		exit 1
	fi
}

install_packages() {
	run_command "sudo apt-get update -qq && sudo apt-get install -qq autoconf automake bat bison build-essential cmake curl fzf g++ gawk git gpg graphviz imagemagick libaio-dev libbz2-dev libcurl4-openssl-dev libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libgraphicsmagick1-dev libjpeg-dev libmagickcore-dev libmagickwand-dev libncurses-dev libncurses5-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxslt-dev libyaml-dev make openconnect patch ripgrep redis-server sshuttle sqlite3 tmux unzip wget xclip xdg-utils zlib1g-dev zsh"
	run_command "sudo apt-get clean"

	echo -e "${SUCCESS}Packages installed successfully.${RESET}"
}

install_rvm() {
	run_command "sudo apt-get install -qq gnupg2"
	gpg_keys=(
		409B6B1796C275462A1703113804BB82D39DC0E3
		7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	)

	for key in "${gpg_keys[@]}"; do
		run_command "gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $key || gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys $key || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys $key"
	done

	bash -c "curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable > /dev/null"
	if [ $? -ne 0 ]; then
		echo -e "${ERROR}An error occurred during RVM installation. Check error.log for details.${RESET}"
		exit 1
	fi
	run_command "echo 'bundler' >> ~/.rvm/gemsets/global.gems"
	run_command "echo 'rvm_silence_path_mismatch_check_flag=1' >> ~/.rvmrc"

	source ~/.rvm/scripts/rvm

	echo -e "${SUCCESS}RVM installed successfully.${RESET}"
}

install_rubies() {
	run_command "rvm autolibs enable"
	run_command "rvm install 3.4.1"
	run_command "rvm use --default 3.4.1"
	run_command "rvm docs generate"

	read -p "Enter Ruby versions to install (comma separated) other than default 3.4.1: " ruby_versions

	IFS=',' read -r -a versions <<<"$ruby_versions"
	for version in "${versions[@]}"; do
		run_command "rvm install ${version// /}"
		run_command "rvm docs generate"
	done

	echo -e "${SUCCESS}Rubies installed successfully.${RESET}"
}

install_packages
install_rvm
install_rubies

echo -e "${SUCCESS}Basic installation completed successfully.${RESET}"
