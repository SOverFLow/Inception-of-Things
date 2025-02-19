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

# Setup the cluster
./cluster_setup.sh

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

# Wait for the service to have endpoints
echo "Waiting for service gitlab-webservice-default to be ready..."
kubectl wait --for=condition=Ready pod -l app=webservice -n gitlab --timeout=500s

if [ $? -eq 0 ]; then
  echo "Service gitlab-webservice-default is ready. Starting port-forwarding..."

  # Start port-forwarding in the background
  kubectl port-forward svc/gitlab-webservice-default 8888:8181 -n gitlab &

  echo "Port-forwarding started"

else
  echo "Timed out waiting for service gitlab-webservice-default to be ready."
  exit 1
fi

