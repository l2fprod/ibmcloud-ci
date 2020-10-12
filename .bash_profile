if [ ! -z "$SHOW_VERSIONS" ]; then
  echo "
  >>> Installed Terraform versions"
  find /usr/local/bin/ -name "terraform*" -executable -type f

  echo "
  >>> Default Terraform version"
  terraform version

  echo "
  >>> Installed Terraform plugins"
  find /root/.terraform.d/plugins/linux_amd64/ -type f -executable -exec {} \;

  echo "
  >>> Tools"
  kubectl version --client=true
  helm version -c

  ibmcloud version
  ibmcloud plugin list
fi
