#!/bin/bash
set -e
export SHELLOPTS

# IBM Cloud CLI
echo ">> ibmcloud"
curl -fsSL https://clis.cloud.ibm.com/install/linux > /tmp/bxinstall.sh
sh /tmp/bxinstall.sh
rm /tmp/bxinstall.sh

# IBM Cloud CLI plugins
echo ">> ibmcloud plugins"
ibmcloud_plugins=( \
  code-engine \
  cloud-databases \
  cloud-dns-services \
  cloud-internet-services \
  cloud-object-storage \
  container-registry \
  container-service \
  vpc-infrastructure \
  key-protect \
  power-iaas \
  schematics \
  sl \
  tg \
  tke \
)
for plugin in "${ibmcloud_plugins[@]}"
do
  ibmcloud plugin install $plugin -f -r "IBM Cloud"
done
ibmcloud config --check-version=false

rm -rf /root/.bluemix/tmp /tmp/*
