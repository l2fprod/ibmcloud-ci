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

# modules not needed
#  gcc \
#  g++ \
#  python \
#  py-pip \
#  wget \
#  vim \
#  tmux \
#  unzip \
#  util-linux \
#  libgcc \
#  make \
#  ncurses \
#  findutils \
#  figlet \
#  zip
# pip install virtualenv

# Terraform
latest_terraform_version="0.12.29"
echo "Terraform ($latest_terraform_version -- marking as latest)"
curl -LO "https://releases.hashicorp.com/terraform/${latest_terraform_version}/terraform_${latest_terraform_version}_linux_amd64.zip"
unzip terraform_${latest_terraform_version}_linux_amd64.zip terraform
mv terraform /usr/local/bin/terraform-${latest_terraform_version}
rm -f terraform_${latest_terraform_version}_linux_amd64.zip
ln -s /usr/local/bin/terraform-${latest_terraform_version} /usr/local/bin/terraform-latest
ln -s /usr/local/bin/terraform-${latest_terraform_version} /usr/local/bin/terraform

echo "Terraform (0.11.14)"
curl -LO "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip"
unzip terraform_0.11.14_linux_amd64.zip terraform
mv terraform /usr/local/bin/terraform-0.11.14
rm -f terraform_0.11.14_linux_amd64.zip

echo "TFSwitch"
wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.32-r0/glibc-2.32-r0.apk
apk add glibc-2.32-r0.apk
curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash

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

# NVM for Node.JS
# apk add nodejs npm
# npm config delete prefix
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash
# source /root/.nvm/nvm.sh
# nvm install 6.9.1 || true
# nvm use --delete-prefix v6.9.1
# npm install -g nodemon
# apk del nodejs

# Yarn
# echo "Yarn"
# apk add yarn
