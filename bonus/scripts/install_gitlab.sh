#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
NC='\033[0m'

echo_step() {
    echo -e "${GREEN}[+] $1${NC}"
}

command_exists() {
    command -v "$1" > /dev/null 2>&1
}

if ! command_exists helm; then
    echo_step "Helm is not installed! Exiting."
    exit 1
fi

if ! command_exists kubectl; then
    echo_step "kubectl is not installed or not configecho_stepured properly! Exiting."
    exit 1
fi

echo_step "Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io
helm repo update

echo_step "Creating GitLab namespace..."
kubectl create namespace gitlab

echo_step "Deploying GitLab with Helm..."
helm upgrade --install gitlab gitlab/gitlab \
  --set global.hosts.https=false \
  --set global.hosts.domain=salamane.com \
  --set global.hosts.externalIP=localhost \
  --set certmanager-issuer.email=me@example.com \
  --set gitlab.gitlab-runner.enabled=false \
  --namespace gitlab
