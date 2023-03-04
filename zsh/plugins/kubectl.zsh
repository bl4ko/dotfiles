if command -v kubectl &> /dev/null; then
  if ! test -f "$DOTFILES/zsh/completions/_kubectl"; then
    kubectl completion zsh | tee "$DOTFILES/zsh/completions/_kubectl" >/dev/null
    source "$DOTFILES/zsh/completions/_kubectl"
  else 
    source "$DOTFILES/zsh/completions/_kubectl"
    kubectl completion zsh | tee "$DOTFILES/zsh/completions/_kubectl" >/dev/null &|
  fi
fi

