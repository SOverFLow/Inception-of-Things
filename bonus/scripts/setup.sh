#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo_step() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# Update system
echo_step "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker if not present
if ! command_exists docker; then
    echo_step "Installing Docker..."
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo_step "Docker is already installed. Skipping..."
fi

# Install kubectl if not present
if ! command_exists kubectl; then
    echo_step "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
else
    echo_step "kubectl is already installed. Skipping..."
fi

# Install K3D if not present
if ! command_exists k3d; then
    echo_step "Installing K3D..."
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo_step "K3D is already installed. Skipping..."
fi

reboot
