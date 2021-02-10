#!/bin/bash
set -e
export SHELLOPTS

# IBM Cloud CLI
echo ">> ibmcloud"
curl -fsSL https://clis.ng.bluemix.net/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# IBM Cloud CLI plugins
echo ">> ibmcloud plugins"
ibmcloud_plugins=( \
  code-engine \
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
  tke \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done
ibmcloud cf install --force
