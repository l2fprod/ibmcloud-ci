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

echo "Installing base dependencies..."
apk add --no-cache \
  ansible \
  bash \
  binutils \
  ca-certificates \
  coreutils \
  curl \
  docker-cli \
  gettext \
  git \
  grep \
  jq \
  make \
  openssl \
  openssh-client \
  openvpn \
  sudo
curl -sfL https://direnv.net/install.sh | bash

echo "TFSwitch"
wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
apk add glibc-2.32-r0.apk
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
rm -f glibc-2.32-r0.apk

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

# Clean up
rm -rf /var/cache/apk/*