#!/bin/bash
set -e
export SHELLOPTS
export DEBIAN_FRONTEND=noninteractive
export LANG=C.UTF-8

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

echo ">> Installing dependencies..."
apt -qq update
PACKAGES=(
  ansible \
  bash \
  binutils \
  ca-certificates \
  coreutils \
  curl \
  direnv
  gettext \
  git \
  gnupg \
  grep \
  jq \
  make \
  openssl \
  openssh-client \
  openvpn \
  sudo \
  tcpdump
)

for package in "${PACKAGES[@]}"; do
  echo "Processing $package..."
  apt install -qq -y $package || true
done

# Docker in Docker | https://docs.docker.com/engine/install/ubuntu/
echo ">> Docker in Docker"
apt remove docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true
apt install -yy  
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -yy docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# for when tfswitch is broken
# echo "Terraform"
# curl -LO https://releases.hashicorp.com/terraform/1.1.9/terraform_1.1.9_linux_amd64.zip
# unzip terraform_1.1.9_linux_amd64.zip
# mv terraform /usr/local/bin/terraform
# chmod +x /usr/local/bin/terraform

echo "Packer"
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt install -yy packer

echo "TFSwitch"
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

# Kubernetes
echo ">> kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl --retry 10 --retry-delay 5 -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
mv kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

# Calico
echo ">> calicoctl"
curl -LO $(get_latest "projectcalico/calicoctl" linux-amd64)
mv calicoctl-linux-amd64 /usr/local/bin/calicoctl
chmod +x /usr/local/bin/calicoctl

# Helm
echo ">> helm 3"
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# OpenShift CLI
echo ">> OpenShift"
curl -LO https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable/openshift-client-linux.tar.gz
tar zxvf openshift-client-linux.tar.gz
mv oc /usr/local/bin/oc
rm -rf README.md kubectl openshift-client-linux.tar.gz

# MC for S3
echo ">> minio"
wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x /usr/local/bin/mc

# pyenv
echo ">> pyenv"
curl https://pyenv.run | bash

# Enable GIT for all directories to avoid prompt like `fatal: unsafe repository ('/app' is owned by someone else)`
git config --global --add safe.directory '*'

# Clean up
apt-get clean
