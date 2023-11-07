#!/bin/bash

function check_curl {
  if ! command -v curl &> /dev/null; then
    echo -e "${INFO} Curl is not installed, installing..."
    if [ "$(uname -s)" = "Linux" ]; then 
      if command -v apt &> /dev/null; then
        if ! ${SUDO} apt install -y curl; then echo -e "${CROSS} Failed installing curl"; exit 1; fi
      elif command -v dnf &> /dev/null; then
        if ! ${SUDO} dnf install -y curl; then echo -e "${CROSS} Failed installing curl"; exit 1; fi
      else
        echo -e "${CROSS} Unsupported package manager"
        exit 1
      fi
    elif [ "$(uname -s)" = "Darwin" ]; then
      brew install -y curl
    else 
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
  else
    echo -e "${TICK} Curl already installed, skipping..."
  fi
}