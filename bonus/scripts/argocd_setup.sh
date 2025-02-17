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

# Ensure kubectl is installed and configured
if ! command_exists kubectl; then
    echo_step "kubectl is not installed or not configured properly! Exiting."
    exit 1
fi

# Create a namespace for ArgoCD
echo_step "Creating ArgoCD namespace..."
kubectl create namespace argocd

# Install ArgoCD 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD pods to start
echo_step "Waiting for ArgoCD pods to start..."
kubectl -n argocd rollout status deployment/argocd-server

# Expose ArgoCD UI for local access (port-forwarding)
echo_step "Setting up port-forwarding to access ArgoCD UI locally..."
kubectl -n argocd port-forward svc/argocd-server 8080:443 &

# Print ArgoCD access information
echo_step "ArgoCD has been deployed!"
echo_step "To access the ArgoCD UI locally, go to: http://localhost:8080"
echo_step "Login using the following credentials:"
echo_step "Username: admin"
echo_step "Password: Get the password using the following command:"
echo_step "  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo_step "Once logged in, you can start configuring ArgoCD to manage your Kubernetes clusters and applications."

