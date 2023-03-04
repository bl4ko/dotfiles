if command -v helm &> /dev/null; then
  if ! test -f "$DOTFILES/zsh/completions/_helm"; then
    helm completion zsh | tee "$DOTFILES/zsh/completions/_helm" >/dev/null
    source "$DOTFILES/zsh/completions/_helm"
  else 
    source "$DOTFILES/zsh/completions/_helm"
    helm completion zsh | tee "$DOTFILES/zsh/completions/_helm" >/dev/null &|
  fi
fi

