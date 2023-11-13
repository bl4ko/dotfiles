#!/bin/bash

function set_default_shell {
  if [ "$(uname -s)" = "Darwin" ]; then
    default_shell=$(dscl . -read /Users/"$(whoami)" UserShell | awk '{print $2}')
  else 
    default_shell=$(getent passwd "$(whoami)" | awk -F: '{print $NF}')
  fi
  echo -e "${INFO} Current default shell is ${COL_LIGHT_CYAN}${default_shell}${COL_NC}"

  # Check if current shell is already zsh
  if [[ "${default_shell}" =~ zsh$ ]]; then
    echo -e "${TICK} Current shell is already zsh, skipping..."
    return
  else 
    prompt_user "${INFO} Do you want to change default shell to zsh? [y/n]"
    if [[ "${answer}" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      if ! ${SUDO} chsh -s "$(which zsh)"; then echo -e "${CROSS} Failed setting zsh as default shell!"; exit 1; fi
      echo -e "${TICK} Successfuly set zsh as default shell"
    else 
      echo -e "${INFO} Skipping..."
      return
    fi
  fi
}

set_default_shell