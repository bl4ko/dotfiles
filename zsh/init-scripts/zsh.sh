#!/bin/bash

function ensure_zsh_is_installed {
  if ! command -v zsh &> /dev/null; then
    echo -e "${INFO} Installing zsh..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          apt install -y zsh
        elif command -v dnf &> /dev/null; then
          dnf install -y zsh
        else
          echo -e "${CROSS} Unsupported package manager"
          exit 1
        fi
    elif [ "$(uname -s)" = "Darwin" ]; then
        brew install -y zsh
    else 
        echo -e "${CROSS} Unsupported OS: $(uname s)"
        exit 1
    fi
    echo -e "${TICK} zsh installed!"
  else
    echo -e "${TICK} zsh already installed, skipping..."
  fi
}