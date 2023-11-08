# Kubernetes prompt: https://github.com/jonmosco/kube-ps1.git


if ! command -v kubectl &> /dev/null; then 
  echo -e "${CROSS} kubectl is not installed but kube_ps1 is enabled..."; 
else
  # Use kubeon and kubeoff to enable and disable the prompt 
  # (kubeoff -g to disable globally)
  if [ ! -f "$DOTFILES/zsh/plugins/loaded/kube-ps1/kube-ps1.sh" ]; then
    echo -e "${INFO} Zsh-kube-ps1 is not installed..."
    echo -e "${INFO} Installing kube-ps1..."
    git clone -v https://github.com/jonmosco/kube-ps1.git "$DOTFILES/zsh/plugins/loaded/kube-ps1"
    echo -e "${TICK} zsh-kube-ps1 installed"
    if ! command -v kubectl >/dev/null 2>&1; then 
      echo "${CROSS} kubectl is not installed..."; 
    fi
  fi
  source "${DOTFILES}/zsh/plugins/loaded/kube-ps1/kube-ps1.sh"
  KUBE_PS1_PREFIX="-%F{cyan}[%f"
  KUBE_PS1_SUFFIX="%F{cyan}]%f"
  KUBE_PS1_SEPARATOR="%F{cyan}|%f"
  # KUBE_PS1_SYMBOL_PADDING=true
  # kube_ps1_autohide() { kube_ps1 | sed 's/^(.*}N\/A%.*:.*}N\/A%.*)$//' }
fi

