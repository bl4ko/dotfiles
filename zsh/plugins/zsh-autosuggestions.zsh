source $DOTFILES/utils.sh
# Enable auto-suggestions based on the history: https://github.com/zsh-users/zsh-autosuggestions
if [ ! -f $DOTFILES/zsh/plugins/loaded/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  echo "${INFO} Zsh-autosuggestions is missing."
  echo "${INFO} Downloading (https://github.com/zsh-users/zsh-autosuggestions)..."
  git clone -v https://github.com/zsh-users/zsh-autosuggestions ~/dotfiles/zsh/plugins/loaded/zsh-autosuggestions
  echo "${TICK} Zsh-autosuggestions downloaded."
fi
. $DOTFILES/zsh/plugins/loaded/zsh-autosuggestions/zsh-autosuggestions.zsh # Source the plugin
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999' # Change suggestion color to grey
ZSH_AUTOSUGGEST_STRATEGY=(history) # https://github.com/zsh-users/zsh-autosuggestions#suggestion-strategy
# ZSH_AUTOSUGGEST_MANUAL_REBIND=false # https://github.com/zsh-users/zsh-autosuggestions#disabling-automatic-widget-re-binding
unset ZSH_AUTOSUGGEST_USE_ASYNC # https://github.com/zsh-users/zsh-autosuggestions#asynchronous-mode

