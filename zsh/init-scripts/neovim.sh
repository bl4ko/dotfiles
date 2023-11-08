#!/bin/bash

# Check if nvchad is already installed
is_nvchad_installed() {
  [ -f "$DOTFILES/nvchad/init.lua" ]
}

# Install Neovim on Linux
install_neovim_linux() {
  local arch
  arch="$(uname -m)"
  if [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
    install_neovim_linux_arm
  elif [ "$arch" = "x86_64" ] || [ "$arch" = "amd64" ]; then
    install_neovim_linux_amd64
  else
    echo -e "${CROSS} Unsupported architecture: $arch"
    exit 1
  fi
}

install_neovim_linux_arm() {
  echo -e "${INFO} We are on arm, so we will build neovim from source..."
  install_neovim_dependencies
  download_and_build_neovim
}

install_neovim_linux_amd64() {
  if ! curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz -o $DOTFILES/build_from_source/nvim-linux64.tar.gz; then echo -e "${CROSS} Failed downloading neovim"; exit 1; fi
  tar xzvf "$DOTFILES/build_from_source/nvim-linux64.tar.gz"
  ln -s "$DOTFILES/build_from_source/nvim-linux64/bin/nvim" "$HOME/.local/bin/nvim"
  rm -rfv "$DOTFILES/build_from_source/nvim-linux64.tar.gz"
}

install_neovim_dependencies() {
  echo -e "${INFO} Installing dependencies for neovim: ${COL_CYAN}https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites${COL_NC}..."
  if command -v apt &> /dev/null; then 
    if ! ${SUDO} apt-get -y install ninja-build gettext cmake unzip curl; then echo -e "${CROSS} Failed installing dependencies"; exit 1; fi
  elif command -v dnf &> /dev/null; then
    if ! ${SUDO} dnf -y install ninja-build cmake gcc make unzip gettext curl; then echo -e "${CROSS} Failed installing dependencies"; exit 1; fi
  else
    echo -e "${CROSS} Unsupported package manager"
    exit 1
  fi
  echo -e "${TICK} Dependencies installed!"
}

download_and_build_neovim() {
  echo -e "${INFO} Downloading neovim source..."
  git clone https://github.com/neovim/neovim
  cd ./neovim || ( echo "Failed moving to neovim directory" && exit 1 )
  git switch -c stable
  make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local -DCMAKE_BUILD_TYPE=RelWithDebInfo"
  # make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"
  make install
  cd .. && rm -rfv neovim
  echo -e "${TICK} neovim installed!"
}

install_neovim() {
  echo -e "${INFO} Installing ${COL_CYAN}neovim${COL_NC}..."
  if command -v nvim &> /dev/null; then
    echo -e "${TICK} neovim already installed, skipping..."
  else
    if [ "$(uname -s)" = "Linux" ]; then
      install_neovim_linux
    elif [ "$(uname -s)" = "Darwin" ]; then
      brew install -v neovim
    else
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
    echo -e "${TICK} neovim installed successfully!" 
  fi
}

