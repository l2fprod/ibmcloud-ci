echo "Installing base dependencies..."
apk add --no-cache \
  bash \
  binutils \
  ca-certificates \
  coreutils \
  curl \
  gettext \
  grep \
  jq \
  openssl \
  openssh-client \
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
echo ">> Terraform"
curl -LO "https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip" && \
  unzip terraform*.zip && \
  rm -f terraform*.zip && \
  chmod 755 terraform && \
  mv terraform /usr/local/bin

# Kubernetes
# echo ">> kubectl"
# curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl --retry 10 --retry-delay 5 -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
# mv kubectl /usr/local/bin/kubectl
# chmod +x /usr/local/bin/kubectl

# Helm
# echo ">> helm"
# curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

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
