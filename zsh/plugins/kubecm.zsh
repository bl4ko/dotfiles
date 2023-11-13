# Check if kubectl command is available
if (( ! $+commands[kubecm] )); then
  echo -e "${INFO} kubecm is not installed, but it is sourced as plugin!"
  return 
fi

# Add kubecm completions
if ! test -f "$DOTFILES/zsh/completions/_kubecm"; then
   kubecm completion zsh | tee "$DOTFILES/zsh/completions/_kubecm" >/dev/null
   source "$DOTFILES/zsh/completions/_kubecm"
else 
  source "$DOTFILES/zsh/completions/_kubecm"
  kubecm completion zsh | tee "$DOTFILES/zsh/completions/_kubecm" >/dev/null &|
fi

