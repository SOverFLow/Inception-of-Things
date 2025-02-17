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

# Ensure Helm is installed
if ! command_exists helm; then
    echo_step "Helm is not installed! Exiting."
    exit 1
fi

# Ensure kubectl is installed and configured
if ! command_exists kubectl; then
    echo_step "kubectl is not installed or not configured properly! Exiting."
    exit 1
fi

# Add GitLab Helm repository
echo_step "Adding GitLab Helm repository..."
helm repo add gitlab https://charts.gitlab.io
helm repo update

# Create a namespace for GitLab
echo_step "Creating GitLab namespace..."
kubectl create namespace gitlab

# Install GitLab using Helm
echo_step "Deploying GitLab with Helm..."
helm upgrade --install gitlab gitlab/gitlab \
  --set global.hosts.https=false \
  --set global.hosts.domain=salamane.com \
  --set global.hosts.externalIP=localhost \
  --set certmanager-issuer.email=me@example.com \
  --set gitlab.gitlab-runner.enabled=false \
  --namespace gitlab


# # Wait for GitLab to be deployed
# echo_step "Waiting for GitLab pods to start..."
# kubectl -n gitlab rollout status deployment/gitlab-webservice-default

# # Print GitLab access information
# echo_step "GitLab has been deployed. To access GitLab locally, use the following commands:"

# # Get GitLab external IP address (use port-forwarding for local access)
# echo_step "If using port-forwarding:"
# echo "  kubectl port-forward --namespace gitlab svc/gitlab-webservice-default 8080:80"
# echo "Then open your browser and navigate to http://localhost:8080"

# echo_step "If using a load balancer or external IP (if set up), get the IP:"
# kubectl -n gitlab get svc -l app=gitlab

# echo_step "GitLab installation is complete!"
