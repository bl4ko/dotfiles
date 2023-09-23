# When app tries to use node and it is not lazy loaded by user, it will give 
# command not found error. To solve this we manually add node to the path.
# After first use of node, nvm will be loaded and we can use it normally.
export PATH="$$HOME/.nvm/versions/node/$(ls $HOME/.nvm/versions/node | sort -r | head -n 1)/bin:$PATH" 

lazynvm() {
  if test -f "$HOME/.nvm/nvm.sh"; then
    unset -f nvm node npm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
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
