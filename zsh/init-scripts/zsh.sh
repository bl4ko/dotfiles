#!/bin/bash

function ensure_zsh_is_installed {
  if ! command -v zsh &> /dev/null; then
    echo -e "${INFO} Installing zsh..."
    if [ "$(uname -s)" = "Linux" ]; then
        if command -v apt &> /dev/null; then
          if ! ${SUDO} apt install -y zsh; then echo -e "${CROSS} Failed installing zsh"; exit 1; fi
        elif command -v dnf &> /dev/null; then
          if ! ${SUDO} dnf install -y zsh; then echo -e "${CROSS} Failed installing zsh"; exit 1; fi
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
    echo -e "${TICK} zsh installed successfully!"
  else
    echo -e "${TICK} zsh already installed, skipping..."
  fi
}

ensure_zsh_is_installed