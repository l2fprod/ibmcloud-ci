#!/bin/bash
set -e
export SHELLOPTS

function get_latest {
  latest_content=$(curl -H "Authorization: token $GITHUB_TOKEN" --silent "https://api.github.com/repos/$1/releases/latest")
  if (echo $latest_content | grep "browser_download_url" | grep -q $2 >/dev/null); then
    echo $latest_content | jq -r .assets[].browser_download_url | grep $2
  else
    echo "Failed to get $1: $latest_content"
    exit 2
  fi
}

# IBM Cloud CLI
echo ">> ibmcloud"
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# IBM Cloud CLI plugins
echo ">> ibmcloud plugins"
ibmcloud_plugins=( \
  cloud-databases \
  cloud-functions \
  cloud-internet-services \
  container-registry \
  container-service \
  vpc-infrastructure \
  key-protect \
  power-iaas \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done

# IBM provider for Terraform
echo ">> ibm terraform provider"
curl -LO $(get_latest "IBM-Cloud/terraform-provider-ibm" linux_amd64)
unzip linux_amd64.zip
rm -f linux_amd64.zip
mkdir /usr/local/share/terraform
mv terraform-provider-ibm* /usr/local/share/terraform/terraform-provider-ibm
echo 'providers {
  ibm = "/usr/local/share/terraform/terraform-provider-ibm"
}' > /root/.terraformrc
