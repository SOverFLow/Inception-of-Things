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

# Generate configiration for ArgoCD
./generate_argo_app.sh

# Push the application the repo
./push_application.sh

# Create a namespace for ArgoCD
echo_step "Creating ArgoCD namespace..."
kubectl create namespace argocd

# Install ArgoCD 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for ArgoCD pods to start
echo_step "Waiting for ArgoCD pods to start..."
kubectl -n argocd rollout status deployment/argocd-server

# Config the argocd application
kubectl apply -f ../confs/argo-app.yaml

# Expose ArgoCD UI for local access (port-forwarding)
echo_step "Setting up port-forwarding to access ArgoCD UI locally..."
kubectl -n argocd port-forward svc/argocd-server 8282:443 &

