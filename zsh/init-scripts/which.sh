#!/bin/bash

function ensure_which_is_installed {
  # Ensure which is installed
  if ! command -v which &> /dev/null; then
    echo -e "${INFO} which command not found, will try to install it..."
    if [ "$(uname -s)" = "Linux" ]; then
      if command -v apt &> /dev/null; then
        if ! ${SUDO} apt install -y which; then echo -e "${CROSS} Failed installing which"; exit 1; fi
      elif command -v dnf &> /dev/null; then
        if ! ${SUDO} dnf install -y which; then echo -e "${CROSS} Failed installing which"; exit 1; fi
      else
        echo -e "${CROSS} Unsupported package manager"
        exit 1
      fi
    elif [ "$(uname -s)" = "Darwin" ]; then
      brew install -y which
    else 
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
  else
    echo -e "${TICK} which already installed, skipping..."
  fi
}

ensure_which_is_installed