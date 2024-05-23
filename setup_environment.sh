#!/bin/bash

set -e

# Function to run commands and check for errors
bash() {
	echo "Running: $1"
	eval $1
	if [ $? -ne 0 ]; then
		echo "Error: Command failed - $1"
		exit 1
	fi
}

# Get the current user
current_user=$(whoami)

# List of packages to install
packages=(
	autoconf automake
	bison build-essential
	cmake
	fzf
	g++ gawk git gpg
	imagemagick
	libaio-dev libbz2-dev libcurl4-openssl-dev libevent-dev libffi-dev libgdbm-dev libglib2.0-dev libgmp-dev libjpeg-dev
	libmagickcore-dev libmagickwand-dev libncurses-dev libncurses5-dev libpq-dev libreadline-dev libsqlite3-dev libssl-dev
	libxml2-dev libxslt-dev libyaml-dev
	make
	openconnect
	patch postgresql
	ripgrep redis-server
	sqlite3
	tmux
	unzip
	wget
	xclip xdg-utils
	zlib1g-dev zsh
)

# Update and install packages
bash "sudo apt-get update -y && sudo apt-get install -y ${packages[@]}"
bash "sudo apt-get clean"

# Install RVM
bash "sudo apt-get install -y gnupg2" # Ensure gpg is available
gpg_keys=(
	409B6B1796C275462A1703113804BB82D39DC0E3
	7D2BAF1CF37B13E2069D6956105BD0E739499BDB
)

for key in "${gpg_keys[@]}"; do
	bash "gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $key || gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys $key || gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys $key"
done

bash "curl -sSL https://get.rvm.io | bash -s -- --autolibs=read-fail stable"
bash "echo 'bundler' >> /home/$current_user/.rvm/gemsets/global.gems"
bash "echo 'rvm_silence_path_mismatch_check_flag=1' >> /home/$current_user/.rvmrc"

# Source RVM scripts
source /home/$current_user/.rvm/scripts/rvm

# Install default Ruby version
bash "rvm install 3.2.0"
bash "rvm use --default 3.2.0"
bash "rvm docs generate"

# Prompt for additional Ruby versions to install
read -p "Enter Ruby versions to install (comma separated) other than default 3.2.0: " ruby_versions

IFS=',' read -r -a versions <<<"$ruby_versions"
for version in "${versions[@]}"; do
	bash "rvm install ${version// /}" # Remove any leading/trailing spaces
	bash "rvm docs generate"
done

echo "Basic installation completed successfully."
