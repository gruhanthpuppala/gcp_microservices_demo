#!/bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail

# Install wget if not already installed
sudo apt update && sudo apt install -y wget apt-transport-https gpg

# Install .NET SDK (Fix for Ubuntu 20.04 or compatible OS)
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-8.0
echo "✅ .NET SDK 8.0 installed"

# Install kubectl
sudo apt install -y kubectl git
echo "✅ kubectl installed"

# Install Go
wget https://golang.org/dl/go1.19.10.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.10.linux-amd64.tar.gz
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.profile
source ~/.profile
echo "✅ Go installed"

# Install build-essential (gcc, used for go test)
sudo apt install -y build-essential

# Install addlicense (used for license checks in workflows)
go install github.com/google/addlicense@latest
sudo ln -s $HOME/go/bin/addlicense /usr/local/bin

# Install skaffold
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
chmod +x skaffold
sudo mv skaffold /usr/local/bin
echo "✅ Skaffold installed"

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${USER}
echo "✅ Docker installed, rebooting..."

# Reboot to apply Docker setup
sudo reboot
