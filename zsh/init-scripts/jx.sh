#!/bin/bash
# Don't need it currently bmaybe in the future

# # https://docs.sigstore.dev/system_config/installation/
# function ensure_cosign_installed() {
#   if ! command -v cosign &> /dev/null; then
#     echo -e "${INFO} cosign not found, installing..."
#     if [ $(uname -s) = "Linux" ]; then
#       if [ $(uname -m) = "x86_64" ] || [ $(uname -m) || "amd64" ]; then
#         if ! curl -LO "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64"; then echo -e "${CROSS} Failed to download cosign"; exit 1; fi
#         mv cosign-linux-amd64 "$HOME/.local/bin/cosign"
#         chmod +x "$HOME/.local/bin/cosign"
#       elif [ $(uname -m) = "arm64" ] || [ $(uname -m) || "aarch64" ]; then
#         if ! curl -LO "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-aarch64"; then echo -e "${CROSS} Failed to download cosign"; exit 1; fi
#         mv cosign-linux-aarch64 "$HOME/.local/bin/cosign"
#         chmod +x "$HOME/.local/bin/cosign"
#       else
#         echo -e "${ERROR} Unsupported architecture"
#         exit 1
#       fi
#     elif [ $(uname -s) = "Darwin" ]; then
#       brew install cosign
#     else 
#       echo -e "${ERROR} Unsupported OS"
#       exit 1
#     fi
#   else
#     echo -e "${TICK} cosign already installed"
#   fi
# }

# function install_jx() {
#   if ! command -v jx &>/dev/null; then
#     if [ $(uname -s) = "Linux" ]; then
#       ensure_cosign_installed
#       LATEST_RELEASE=$(curl -s https://api.github.com/repos/jenkins-x/jx/releases/latest | grep tag_name | cut -d '"' -f 4)
#       if [ $(uname -m) = "x86_64" ] || [ $(uname -m) || "amd64" ]; then
#         curl -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-amd64.tar.gz -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-amd64.tar.gz.sig -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-amd64.tar.gz.pem
#         COSIGN_EXPERIMENTAL=1 cosign verify-blob --certificate jx-linux-amd64.tar.gz.pem --signature jx-linux-amd64.tar.gz.sig jx-linux-amd64.tar.gz
#         tar -zxvf jx-linux-amd64.tar.gz
#         mv jx "$HOME/.local/bin/jx"
#         rm -rfv jx-linux-amd64.tar.gz*
#       elif [ $(uname -m) = "arm64" ] || [ $(uname -m) || "aarch64" ]; then
#         curl -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-arm.tar.gz -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-arm.tar.gz.sig -LO https://github.com/jenkins-x/jx/releases/latest/download/jx-linux-arm.tar.gz.pem
#         COSIGN_EXPERIMENTAL=1 cosign verify-blob --certificate jx-linux-arm.tar.gz.pem --signature jx-linux-arm.tar.gz.sig jx-linux-arm.tar.gz
#         tar -zxvf jx-linux-arm.tar.gz
#         mv jx "$HOME/.local/bin/jx"
#         rm -rfv jx-linux-arm.tar.gz*
#       else
#         echo -e "${ERROR} Unsupported architecture"
#         exit 1
#       fi
#     elif [ $(uname -s) = "Darwin"]; then
#       echo -e "${INFO} TODO - install jx on macos"
#     fi
#   else 
#     echo -e "${TICK} jx already installed"
#   fi
# }

# install_jx
