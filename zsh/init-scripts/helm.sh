#!/bin/bash

function install_helm {
  if ! command -v helm &> /dev/null; then
    echo -e "${INFO} helm is not installed, installing..."
    if [ "$(uname -s)" = "Linux" ]; then 
      STABLE_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4)
      if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
         curl -LO "https://get.helm.sh/helm-${STABLE_VERSION}-linux-amd64.tar.gz"
         curl -LO "https://get.helm.sh/helm-${STABLE_VERSION}-linux-amd64.tar.gz.sha256sum"
         # Check checksum
         if sha256sum -c helm-${STABLE_VERSION}-linux-amd64.tar.gz.sha256sum; then
           echo -e "${TICK} Checksum passed, extracting..."
           rm -v helm-${STABLE_VERSION}-linux-amd64.tar.gz.sha256sum
           tar -vxzf helm-${STABLE_VERSION}-linux-amd64.tar.gz
           mv -v linux-amd64/helm $HOME/.local/bin/helm
           rm -rfv linux-amd64 helm-*
           echo -e "${TICK} helm installed successfully"
         else 
           echo -e "${CROSS} Checksum failed, exiting..."
           rm -v helm-${STABLE_VERSION}-linux-amd64.tar.gz*
           exit 1
         fi 
      elif [ "$(uname -m)" = "arm64" ] || [ "$(uname -m)" = "aarch64" ]; then
        curl -LO "https://get.helm.sh/helm-${STABLE_VERSION}-linux-arm64.tar.gz"
        curl -LO "https://get.helm.sh/helm-${STABLE_VERSION}-linux-arm64.tar.gz.sha256sum"
        if sha256sum -c helm-${STABLE_VERSION}-linux-arm64.tar.gz.sha256sum; then
          echo -e "${TICK} Checksum passed, extracting..."
          rm -v helm-${STABLE_VERSION}-linux-arm64.tar.gz.sha256sum
          tar -vxzf helm-${STABLE_VERSION}-linux-arm64.tar.gz
          mv -v linux-arm64/helm $HOME/.local/bin/helm
          rm -rfv linux-arm64 helm-*
          echo -e "${TICK} helm installed successfully"
        else 
          echo -e "${CROSS} Checksum failed, exiting..."
          rm -v helm-${STABLE_VERSION}-linux-arm64.tar.gz*
          exit 1
        fi
      else 
        echo -e "${CROSS} Unsupported architecture for helm: $(uname -s):$(uname -m)"
        exit 1
      fi
    elif [ "$(uname -s)" = "Darwin" ]; then
      brew install -y helm
    else 
      echo -e "${CROSS} Unsupported OS: $(uname -s)"
      exit 1
    fi
  else
    echo -e "${TICK} Helm already installed, skipping..."
  fi
}

install_helm
