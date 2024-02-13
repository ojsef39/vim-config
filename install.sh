#!/bin/bash

# Check if current device is mac or x86-linux
if [[ "$OSTYPE" == "darwin"* ]]; then
	IS_MAC=true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	IS_MAC=false
else
	echo "Unsupported OS, cannot continue (See ReadMe.md)"
	exit 1
fi

if [ "$IS_MAC" = true ]; then
	# CHeck if brew is installed
	if ! command -v brew >/dev/null; then
		echo "Homebrew is not installed, please install it first (https://brew.sh/)"
		exit 1
	fi
	brew install neovim npm ripgrep
	# Install neovim and npm (npm is needed for language servers)
	# Check if user is using zrsh or bash
	if [ -n "$ZSH_VERSION" ]; then
		#Append to .zshrc
		echo "alias vim=nvim" >>~/.zshrc
	elif [ -n "$BASH_VERSION" ]; then
		# Append to .bashrc
		echo "alias vim=nvim" >>~/.bashrc
	else
		echo "Not zsh or bash, cannot continue"
	fi
else
	# Check if using apt
	if command -v apt >/dev/null || which apt >/dev/null; then
		sudo apt update
		sudo apt install -y curl libfuse2 ripgrep python3 golang unzip npm
	else
		echo "Sorry, this script only supports apt for now"
		exit 1
	fi

	# Install neovim and npm (npm is needed for language servers)
	if [ "$(uname -m)" == "x86_64" ]; then
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x nvim.appimage
		./nvim.appimage --appimage-extract
		./squashfs-root/AppRun --version
		rm -r /squashfs-root
		rm nvim.appimage
		sudo mv squashfs-root /
		rm /usr/bin/nvim
		sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
	else
		# Check if using apt
		if command -v apt >/dev/null || which apt >/dev/null; then
			sudo apt install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config doxygen make
		else
			echo "Sorry, this script only supports apt for now"
			exit 1
		fi
		git clone https://github.com/neovim/neovim.git
		cd neovim
		make CMAKE_BUILD_TYPE=RelWithDebInfo
		sudo make install
		cd .. && rm -rf neovim
	fi

	# Install nodejs and npm higher than 20 (thanks LTS Ubuntu)
	sudo apt autoremove -y nodejs
	curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
	sudo bash nodesource_setup.sh
	rm nodesource_setup.sh
	sudo apt install -y nodejs
	npm install -g npm@9.6.4

	# Append to .bashrc
	echo 'export PATH="$PATH:/opt/nvim/"' >>~/.bashrc
	echo "alias vim=nvim" >>~/.bashrc
fi

# Copy all files except readme and install.sh to ~/.config/nvim/
for file in *; do
	# check if folder exists
	if [ ! -d ~/.config/nvim ]; then
		mkdir -p ~/.config/nvim/
	fi
	if [ "$file" != "README.md" ] && [ "$file" != "install.sh" ]; then
		cp -r "$file" ~/.config/nvim/
	fi
done
echo "Files moved to ~/.config/nvim/"

# Ask if user wants to install fastfetch
if [ "$IS_MAC" = true ]; then
	read -p "Do you want to install fastfetch? Mac only for now (y/n)" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		brew install fastfetch
	fi
fi

nvim
