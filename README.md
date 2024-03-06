# 💤 My Lazy Neovim Config

Feel free to steal this config ;)

If youre on a new system you can run `install.sh` and it will install
neovim and dependencies needed for my config.

See below how to install and update.

## Requrements

- apt or brew
- MacOS (Tested on ARM, should work on x86_64 too)
- Linux (Tested on x86_64 & ARM - Note: ARM version could be buggy)

## Dependencies (if needed, will be installed by script)

<details open><summary>MacOS:</summary>

- neovim (latest from brew)
- npm
- ripgrep
- fastetch (optional)
</details>

<details open><summary>Linux:</summary>

<details open><summary>x86_64:</summary>

- neovim (latest AppImage)
</details>

<details><summary>ARM:</summary>

- neovim (latest Cmake build)
- ninja-build
- gettext
- libtool
- libtool-bin
- autoconf
- automake
- cmake
- g++
- pkg-config
- doxygen
- make

</details>

<details open><summary>All linux versions:</summary>

- NodeJS (20.x)
- npm (9.6.4)
- fastetch (optional)
- ripgrep
- curl
- libfuse2
- python3 (for language server)
- golang (for language server)
- unzip
</details>
</details>

## How to install

1. Clone the repo
2. Run `sudo install.sh`

## How to update

1. Run `sudo update.sh`
