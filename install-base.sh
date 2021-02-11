set -e
export SHELLOPTS

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
  grep \
  jq \
  make \
  openssl \
  openssh-client \
  openvpn \
  sudo

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

# Helm
echo ">> helm"
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# MC for S3
echo ">> minio"
wget -O /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x /usr/local/bin/mc

# Clean up
rm -rf /var/cache/apk/*