## ---------------------------- COMMAND-NOT-FOUND ------------------------------------------------
# https://packages.ubuntu.com/search?keywords=command-not-found
if [ -f /etc/zsh_command_not_found ]; then
  . /etc/zsh_command_not_found
else
  echo "command-not-found is missing..."
  # echo "installing command-not-found..."
  # sudo apt update && sudo apt install command-not-found
  #. /etc/zsh_command_not_found
fi

