# We install clipboard support for neovim
if [ $(uname -s) = "Linux" ]; then
  if command -v apt &> /dev/null; then
    if ! command -v xclip &>/dev/null; then
      ${SUDO} apt install xclip
      echo -e "${TICK} clipboard xclip installed"
     else 
      echo -e "${TICK} clipboard xclip already installed"
    fi
  else
    echo -e "${CROSS} clipboard for current system not supported"
  fi
fi
