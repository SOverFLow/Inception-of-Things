#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

echo_step() {
    echo -e "${GREEN}[+] $1${NC}"
}

command_exists() {
    command -v "$1" > /dev/null 2>&1
}

if ! command_exists k3d; then
    echo_step "k3d is not installed! Installing..."
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo_step "k3d is already installed. Skipping installation."
fi

if ! command_exists kubectl; then
    echo_step "kubectl is not installed! Exiting."
    exit 1
fi

echo_step "Creating K3D cluster..."
k3d cluster create mycluster -p "8080:80" -p "8443:443"
