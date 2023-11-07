#!/bin/bash

install_nvchad() {
  if [ -f "$HOME/.config/nvim/init.lua" ]; then
    echo -e "${TICK} nvchad already installed, skipping..."
    exit 0
  else
    ensure_nvim_config_directory_exists
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    echo -e "${INFO} Linking nvchad configs..."
    ln -sv "$DOTFILES/nvchad/custom" "$HOME/.config/nvim/lua/custom"
    echo -e "${TICK} nvchad installed successfuly!"
  fi
}

ensure_nvim_config_directory_exists() {
  if [ ! -d "$HOME/.config/nvim" ]; then
    echo -e "${INFO} Creating ${COL_CYAN}$HOME/.config${COL_NC} for nvim..."
    if output=$(mkdir -vp "$HOME/.config/nvim"); then
      echo "${output}"
      echo -e "${TICK} Successfully created."
    else
      echo -e "${CROSS} Failed creating: ${output}"
      exit 1
    fi
  fi
}