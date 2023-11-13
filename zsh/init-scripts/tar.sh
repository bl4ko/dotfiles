#!/bin/bash

# Ensure tar is installed
function check_tar {
  if command -v tar &>/dev/null; then
    echo -e "${TICK} tar already installed, skipping..."
  else
    echo -e "${INFO} tar not found, will try to install it..."
    if [ "$(uname -s)" = "Linux" ]; then
      if command -v apt &>/dev/null; then
        if ! ${SUDO} apt install -y tar; then echo -e "${CROSS} Failed installing tar"; exit 1; fi
      elif command -v dnf &>/dev/null; then
        if ! ${SUDO} dnf install -y tar; then echo -e "${CROSS} Failed installing tar"; exit 1; fi
      else
        echo -e "${CROSS} Unsupported package manager"
        exit 1
      fi
    else
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
  fi
}

check_tar