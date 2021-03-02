if [ ! -z "$SHOW_VERSIONS" ]; then
  echo "
  >>> Tools"
  kubectl version --client=true
  helm version -c

  ibmcloud version
  ibmcloud plugin list
fi

eval "$(direnv hook bash)"
