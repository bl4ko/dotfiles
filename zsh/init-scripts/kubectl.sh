#!/bin/bash

function install_kubectl {
  if ! command -v kubectl &> /dev/null; then
    echo -e "${INFO} Kubectl is not installed, installing..."
    if [ "$(uname -s)" = "Linux" ]; then 
      # Check if uname -m, is x86_64 or amd64 architecture
      if [ "$(uname -m)" = "x86_64" ] || [ "$(uname -m)" = "amd64" ]; then
         curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
         curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
         if (echo "$(<kubectl.sha256) kubectl" | sha256sum --check); then 
           echo -e "${TICK} Kubectl checksum verified"
           mv kubectl "$HOME/.local/bin"
           rm kubectl.sha256
         else
           echo -e "${CROSS} Kubectl checksum verification failed"
           rm kubectl kubectl.sha256
           exit 1
         fi
         chmod +x "$HOME/.local/bin/kubectl"
      else # arm64 architecture
         curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl" --output-dir "$HOME/.local/bin"
         chmod +x "$HOME/.local/bin/kubectl"
      fi
    elif [ "$(uname -s)" = "Darwin" ]; then
      brew install -y kubernetes-cli
    else 
      echo -e "${CROSS} Unsupported OS: $(uname s)"
      exit 1
    fi
  else
    echo -e "${TICK} Kubectl already installed, skipping..."
  fi
}

install_kubectl
