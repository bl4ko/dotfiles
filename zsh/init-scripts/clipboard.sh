# We install clipboard support for neovim
if [ $(uname -s) = "Linux" ]; then
  if command -v apt &> /dev/null; then
    ${SUDO} apt install xclip
    echo -e "${INFO} clipboard xclip installed"
  else
    echo -e "${INFO} clipboard for current system not supported"
  fi
fi
