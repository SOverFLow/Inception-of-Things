#!/bin/bash

SERVICE_IP=$(kubectl get service gitlab-webservice-default -n gitlab -o jsonpath='{.spec.clusterIP}')

# Check if the IP was retrieved successfully
if [ -z "$SERVICE_IP" ]; then
  echo "Failed to retrieve the IP address for the Service gitlab-webservice-default in namespace gitlab."
  exit 1
fi

# File to write the YAML content
OUTPUT_FILE="argo-app.yaml"

# YAML content with placeholder for IP
YAML_CONTENT=$(cat <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wilapp
  namespace: argocd
spec:
  project: default
  source:
    repoURL: http://NEW_IP:8181/root/myapp.git
    targetRevision: HEAD
    path: app
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    automated:
      prune: true
      selfHeal: true
EOF
)

# Replace the placeholder NEW_IP with the actual Service IP
YAML_CONTENT=$(echo "$YAML_CONTENT" | sed "s/NEW_IP/$SERVICE_IP/g")

# Write the updated YAML to the file
echo "$YAML_CONTENT" > "$OUTPUT_FILE"

echo "YAML file '$OUTPUT_FILE' created with IP address '$SERVICE_IP'."