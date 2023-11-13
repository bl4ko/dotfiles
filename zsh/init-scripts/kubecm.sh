#!/bin/bash

function install_kubecm {
  if ! command -v kubecm &>/dev/null; then 
    echo -e "${INFO} kubecm is not installed. Installing it..."
    if [ $(uname -s) = "Linux" ]; then
      # Extract the latest version from the github releases page
      LATEST_VERSION=$(curl -s https://api.github.com/repos/sunny0826/kubecm/releases/latest | grep "tag_name" | awk '{print substr($2, 2, length($2)-3)}')
      CHECKSUM_STRINGS=$(curl -L https://github.com/sunny0826/kubecm/releases/download/${LATEST_VERSION}/checksums.txt)
      
      if [ $(uname -m) = "x86_64" ] || [ $(uname -m) = "amd64" ]; then
        curl -LO https://github.com/sunny0826/kubecm/releases/download/${LATEST_VERSION}/kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz
        CHECKSUM_STRING=$(echo "${CHECKSUM_STRINGS}" | grep "kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz" | awk '{print $1}')
        if [ -z "${CHECKSUM_STRING}" ]; then # Ensure CHECKSUM_STRING is not empty
          echo -e "${CROSS} failed to get checksum string for kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz"
          exit 1
        fi
        # Check that the checksum matches
        CHECKSUM=$(sha256sum kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz | awk '{print $1}')
        if [ "${CHECKSUM}" != "${CHECKSUM_STRING}" ]; then
          echo -e "${CROSS} checksum of kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz does not match!"
          exit 1
        else 
          echo -e "${TICK} checksum of kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz matches!"
        fi

        tar -xzf kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz
        mv kubecm $HOME/.local/bin
        rm -rfv kubecm_${LATEST_VERSION}_Linux_x86_64.tar.gz

      elif [ $(uname -m) = "arm64" ] || [ $(uname -m) = "aarch64"]; then
        curl -LO https://github.com/sunny0826/kubecm/releases/download/${LATEST_VERSION}/kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz
        CHECKSUM_STRING=$(echo "${CHECKSUM_STRINGS}" | grep "kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz" | awk '{print $1}')
        if [ -z "${CHECKSUM_STRING}" ]; then # Ensure CHECKSUM_STRING is not empty
          echo -e "${CROSS} failed to get checksum string for kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz"
          exit 1
        fi
        # Check that the checksum matches
        CHECKSUM=$(sha256sum kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz | awk '{print $1}')
        if [ "${CHECKSUM}" != "${CHECKSUM_STRING}" ]; then
          echo -e "${CROSS} checksum of kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz does not match!"
          exit 1
        else 
          echo -e "${TICK} checksum of kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz matches!"
        fi
        tar -xzf kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz
        mv kubecm $HOME/.local/bin
        rm -rfv kubecm_${LATEST_VERSION}_Linux_arm64.tar.gz
      else
        echo -e "${CROSS} unsupported architecture!"
        exit 1
      fi
    elif [ $(uname -s) = "Darwin" ]; then 
      brew install -y kubecm
    else
      echo -e "${CROSS} unsupported OS!"
      exit 1
    fi
  else 
    echo -e "${TICK} kubecm is already installed!"
  fi
}

install_kubecm