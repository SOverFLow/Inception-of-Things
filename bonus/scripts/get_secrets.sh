#!/bin/bash

get_and_print_secret() {
  local namespace=$1
  local secret_name=$2
  local secret_key=$3

  echo "Retrieving secret ${secret_name} from namespace ${namespace}..."

  secret_value=$(kubectl get secret -n "${namespace}" "${secret_name}" -o jsonpath="{.data.${secret_key}}" | base64 --decode)

  if [ -z "${secret_value}" ]; then
    echo "Error: Secret ${secret_name} or key ${secret_key} not found."
    exit 1
  else
    echo "Secret Value: ${secret_value}"
  fi
}

echo "==== ArgoCD Admin Password ===="
get_and_print_secret "argocd" "argocd-initial-admin-secret" "password"

echo "==== GitLab Token ===="
get_and_print_secret "gitlab" "gitlab-gitlab-initial-root-password" "password" 

echo "Script completed."