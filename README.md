# 💤 My Lazy Neovim Config

Feel free to steal this config ;)

If youre on a new system you can run `install.sh` and it will install
neovim and dependencies needed for my config.
Check [How to install?](https://github.com/ojsef39/vim-config/tree/dev-1.0?tab=readme-ov-file#how-to-install) and [How to update?](https://github.com/ojsef39/vim-config/tree/dev-1.0?tab=readme-ov-file#how-to-updatei).

Requrements:

- apt or brew
- MacOS (Tested on ARM, should work on x86 too)
- Linux (Tested on x86 & ARM - Note: ARM version could be buggy)

Dependencies (if needed, will be installed by script):

- MacOS:

  - neovim
  - npm
  - ripgrep
  - fastetch (optional)

- Linux:

  - x86_64:

    - neovim (Latest AppImage)

  - ARM:

    - neovim (Latest Cmake build)
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

  - All:
    - NodeJS (20.x)
    - npm (9.6.4)
    - ripgrep
    - curl
    - libfuse2
    - python3 (for language server)
    - golang (for language server)
    - unzip

## How to install

1. Clone the repo
2. Run `install.sh`

## How to update

1. Run `update.sh`
