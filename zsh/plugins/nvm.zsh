# export PATH="$HOME/.nvm/versions/node/v16.19.1/:$PATH"

lazynvm() {
  if test -f "$HOME/.nvm/nvm.sh"; then
    unset -f nvm node npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  else
    echo "$HOME/.nvm/nvm.sh is missing..." >&2
    return 1
  fi
}

nvm() {
  lazynvm
  nvm "$@"
}

node() {
  lazynvm
  node "$@"
}

npm() {
  lazynvm
  npm "$@"
}

