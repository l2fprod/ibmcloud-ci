#!/bin/bash
set -e
export SHELLOPTS

function get_latest {
  latest_content=$(curl -H "Authorization: token $GITHUB_TOKEN" --silent "https://api.github.com/repos/$1/releases/latest")
  latest_url=$(echo $latest_content | jq -r '.assets[] | select(.browser_download_url | test("'$2'")) | .browser_download_url')
  if [ ! -z "$latest_url" ]; then
    echo $latest_url
  else
    echo "Failed to get $1: $latest_content"
    exit 2
  fi
}

function get_most_recent_matching {
  releases=$(curl -H "Authorization: token $GITHUB_TOKEN" --silent "https://api.github.com/repos/$1/releases")
  most_recent_matching=$(echo -E $releases | jq -r '.[] | .assets | .[] | select(.browser_download_url | test("'$2'")) | .browser_download_url' | head -n 1)
  if [ ! -z "$most_recent_matching" ]; then
    echo $most_recent_matching
  else
    echo "Failed to get $1: $releases"
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
  cloud-dns-services \
  cloud-functions \
  cloud-internet-services \
  cloud-object-storage \
  container-registry \
  container-service \
  vpc-infrastructure \
  key-protect \
  power-iaas \
  schematics \
  tg \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done
ibmcloud cf install --force

# IBM provider for Terraform
echo ">> terraform provider"
mkdir -p /root/.terraform.d/plugins/linux_amd64

echo ">>> 0.x"
curl -LO $(get_most_recent_matching "IBM-Cloud/terraform-provider-ibm" ".*v0.*linux_amd64.*")
unzip linux_amd64.zip -d /root/.terraform.d/plugins/linux_amd64
rm -f linux_amd64.zip

echo ">>> latest (1.x)"
curl -LO $(get_most_recent_matching "IBM-Cloud/terraform-provider-ibm" ".*v1.*linux_amd64.*")
unzip linux_amd64.zip -d /root/.terraform.d/plugins/linux_amd64
rm -f linux_amd64.zip
