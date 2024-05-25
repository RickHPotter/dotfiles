#!/bin/bash

set -e

run_command() {
	echo "Running: $1"
	eval $1
	if [ $? -ne 0 ]; then
		echo "Error: Command failed - $1"
		exit 1
	fi
}

current_user=$(whoami)

run_command "sudo apt-get update -qq && sudo apt-get install -qq autoconf automake bat bison build-essential cmake curl fzf g++ gawk git gpg imagemagick libaio-dev libbz2-dev libcurl4-openssl-dev libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev libmagickcore-dev libmagickwand-dev libncurses-dev libncurses5-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev libxml2-dev libxslt-dev libyaml-dev make openconnect patch ripgrep redis-server sqlite3 tmux unzip wget xclip xdg-utils zlib1g-dev zsh"
run_command "sudo apt-get clean"

run_command "sudo apt-get install -qq gnupg2"
gpg_keys=(
	409B6B1796C275462A1703113804BB82D39DC0E3
	7D2BAF1CF37B13E2069D6956105BD0E739499BDB
)

for key in "${gpg_keys[@]}"; do
	run_command "gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $key || gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys $key || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys $key"
done

bash -c "curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable"
run_command "echo 'bundler' >> /home/$current_user/.rvm/gemsets/global.gems"
run_command "echo 'rvm_silence_path_mismatch_check_flag=1' >> /home/$current_user/.rvmrc"

source /home/$current_user/.rvm/scripts/rvm

run_command "rvm install 3.2.0"
run_command "rvm use --default 3.2.0"
run_command "rvm docs generate"

read -p "Enter Ruby versions to install (comma separated) other than default 3.2.0: " ruby_versions

IFS=',' read -r -a versions <<<"$ruby_versions"
for version in "${versions[@]}"; do
	run_command "rvm install ${version// /}"
	run_command "rvm docs generate"
done

echo "Basic installation completed successfully."
