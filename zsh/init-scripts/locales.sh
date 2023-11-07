#!/bin/bash

function setup_locales {
  echo -e "${INFO} Checking if en_US.UTF-8 locale is installed..."
  # Check if locale is installed
  if locale -a | grep -qi "en_us.utf8"; then
    echo -e "${TICK} en_US.UTF-8 locale is already installed, skipping..."
  else
    echo -e "${INFO} en_US.UTF-8 locale is not installed, installing..."
    # Check if we are on ubuntu
    if [ "$(uname -s)" = "Linux" ]; then
      if command -v apt &> /dev/null; then
        apt-get install -y locales
        locale-gen en_US.UTF-8
        update-locale
      elif command -v dnf &> /dev/null; then
        dnf install -y glibc-langpack-en
      else
        echo -e "${CROSS} Unsupported package manager for $(uname -s)"
        exit 1
      fi
    else 
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
    # We need to check if locale-gen is installed
  fi
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
}