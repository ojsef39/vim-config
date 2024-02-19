#!/bin/bash
# Check if current device is mac or x86-linux
if [[ "$OSTYPE" == "darwin"* ]]; then
	IS_MAC=true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	IS_MAC=false
	if [[ "$DISTRO" == "ubuntu" ]]; then
		LINUX_DIST="ubuntu"
	fi
else
	echo "Unsupported OS, cannot continue (See ReadMe.md)"
	exit 1
fi

echo "Starting installation…"

if [ "$IS_MAC" = true ]; then
	# CHeck if brew is installed
	if ! command -v brew >/dev/null; then
		echo "Homebrew is not installed, please install it first (https://brew.sh/)"
		exit 1
	fi
	brew install neovim npm ripgrep
	# Install neovim and npm (npm is needed for language servers)
	# Check if user is using has zsh or bash
	if [ -f ~/.zshrc ]; then
		if ! grep -q 'alias vim=nvim' ~/.zshrc; then
			#Append to .zshrc
			echo "alias vim=nvim" >>~/.zshrc
		fi
	fi
	# No elif because user could have both
	if [ -f ~/.bashrc ]; then
		if ! grep -q 'alias vim=nvim' ~/.bashrc; then
			# Append to .bashrc
			echo "alias vim=nvim" >>~/.bashrc
		fi
	fi
else
	# Check if using apt
	if command -v apt >/dev/null || which apt >/dev/null; then
		sudo apt update
		sudo apt install -y curl libfuse2 ripgrep python3 python3-neovim golang unzip npm
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
		# Check if version is the same before installing
		nvim_version=$(nvim -v | head -n 1 | awk '{print $2}' | sed 's/\(-dev\).*/\1/')
		nvim_version=${nvim_version#v} # Remove leading 'v' if present

		# Extract version from CMakelist
		cd neovim
		make_MAJOR=$(grep "NVIM_VERSION_MAJOR" CMakeLists.txt | cut -d ' ' -f 2 | tr -d ')')
		make_MINOR=$(grep "NVIM_VERSION_MINOR" CMakeLists.txt | cut -d ' ' -f 2 | tr -d ')')
		make_PATCH=$(grep "NVIM_VERSION_PATCH" CMakeLists.txt | cut -d ' ' -f 2 | tr -d ')')
		make_PRERELEASE=$(grep "NVIM_VERSION_PRERELEASE" CMakeLists.txt | cut -d ' ' -f 2 | tr -d '"' | tr -d ')')
		make_VERSION="v${make_MAJOR}.${make_MINOR}.${make_PATCH}${make_PRERELEASE}"

		echo "make version: $make_VERSION"
		echo "nvim_version: $nvim_version"
		exit 1 ## Testing

		if [ "$nvim_version" != "$make_VERSION" ]; then
			make CMAKE_BUILD_TYPE=Release
			sudo make install
			cd .. && rm -rf neovim
		else
			echo "Neovim is already installed and up to date"
		fi
	fi

	# Install nodejs and npm higher than 20 (thanks LTS Ubuntu)
	sudo apt autoremove -y nodejs
	curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh
	sudo bash nodesource_setup.sh
	rm nodesource_setup.sh
	sudo apt install -y nodejs
	npm install -g npm@9.6.4

	# Append to .bashrc, check before if the path is already there
	if ! grep -q '/opt/nvim/' ~/.bashrc; then
		echo 'export PATH="$PATH:/opt/nvim/"' >>~/.bashrc
	fi
fi
echo "Done installing, moving files now…"

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
read -p "Do you want to install fastfetch? (Y/n)" yn
if [ "$IS_MAC" = true ]; then
	case $yn in
	[Yy]* | "")
		brew install fastfetch
		if [ -f ~/.zshrc ]; then
			if ! grep -q 'fastfetch' ~/.zshrc; then
				#Append to .zshrc
				echo "fastfetch" >>~/.zshrc
			fi
		fi
		;;
	*) echo "You can install fastfetch by typing 'brew install fastfetch' in the terminal. Not installed…" ;;
	esac
elif [ "$LINUX_DIST" == "ubuntu" ]; then
	case $yn in
	[Yy]* | "")
		if uname -m | grep -q "x86_64"; then
			wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.8.3/fastfetch-linux-x86_64.deb
			dpkg -i fastfetch-linux-x86_64.deb
		elif uname -m | grep -q "aarch64"; then
			wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.8.3/fastfetch-linux-aarch64.deb
			dpkg -i fastfetch-linux-aarch64.deb
		fi
		if [ -f ~/.bashrc ]; then
			if ! grep -q 'fastfetch' ~/.bashrc; then
				# Append to .bashrc
				echo "fastfetch" >>~/.bashrc
			fi
		fi
		;;
	*) echo "See https://github.com/fastfetch-cli/fastfetch/ on how to install. Not installed…" ;;
	esac
fi

# Ask if user wants to open nvim now
read -p "Do you want to open nvim now? (Recommended) (Y/n)" yn
case $yn in
[Yy]* | "") nvim ;;
*) echo "You can open nvim by typing 'nvim' in the terminal. Done…" ;;
esac
