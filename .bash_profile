if [ ! -z "$SHOW_VERSIONS" ]; then
  echo "
  >>> Tools"
  kubectl version -o yaml
  helm version -c

  ibmcloud version
  ibmcloud plugin list
fi

eval "$(direnv hook bash)"

# disable Terraform calling home
# https://www.terraform.io/docs/cli/commands/index.html#upgrade-and-security-bulletin-checks
export CHECKPOINT_DISABLE=true

# tofuenv
export PATH="$PATH:$HOME/.tofuenv/bin"
