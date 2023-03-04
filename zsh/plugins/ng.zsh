ng() {
  if command -v ng &> /dev/null; then
      unfunction "$0"
      source <(ng completion script) # Load Angular CLI autocompletion.
      $0 "$@"
  else
    echo "Angular CLI is not installed."
  fi
} 

