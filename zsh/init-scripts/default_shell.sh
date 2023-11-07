#!/bin/bash

function set_default_shell {
  default_shell=$(getent passwd "$(whoami)" | awk -F: '{print $NF}')
  echo -e "${INFO} Current default shell is ${COL_LIGHT_CYAN}${default_shell}${COL_NC}"

  # Check if current shell is already zsh
  if [[ "${default_shell}" =~ "zsh$" ]]; then
    echo -e "${TICK} Current shell is already zsh, skipping..."
    return
  else 
    # Prompt user if he wants to change default shell to zsh
    echo -e "${INFO} Do you want to change default shell to zsh? [y/n]"
    read -r answer
    if [[ ! "${answer}" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
      echo -e "${INFO} Skipping..."
      return
    else 
      if chsh -s "$(which zsh)"; then
        echo -e "${TICK} Successfuly set zsh as default shell"
      else
        echo -e "${CROSS} Failed setting zsh as default shell!"
        exit 1
      fi
    fi
  fi
}