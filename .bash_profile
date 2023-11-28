if [ ! -z "$SHOW_VERSIONS" ]; then
  echo "
  >>> Tools"
  kubectl version -o yaml
  helm version -c

  ibmcloud version
  ibmcloud plugin list
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

eval "$(direnv hook bash)"

# disable Terraform calling home
# https://www.terraform.io/docs/cli/commands/index.html#upgrade-and-security-bulletin-checks
export CHECKPOINT_DISABLE=true
