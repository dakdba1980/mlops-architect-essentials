#!/bin/bash

# __define-ocg__  Kubernetes config setup script with custom contexts and clusters

# Define variables
varOcg="kube_custom.config"
varFiltersCg="htttp://5.6.7.8"

# Remove old config if it exists
rm -f "$varOcg"

# Create 'development' cluster
kubectl config set-cluster development \
  --server="htttp://0.0.1.1" \
  --certificate-authority="temp_ca_file" \
  --kubeconfig="$varOcg"

# Create 'staging' cluster
kubectl config set-cluster staging \
  --server="$varFiltersCg" \
  --certificate-authority="temp_ca_file" \
  --kubeconfig="$varOcg"

# Create 'dev-frontend' context
kubectl config set-context dev-frontend \
  --cluster="development" \
  --namespace="frontend" \
  --user="developer" \
  --kubeconfig="$varOcg"

# Create 'dev-staging' context
kubectl config set-context dev-staging \
  --cluster="staging" \
  --namespace="frontend" \
  --user="developer" \
  --kubeconfig="$varOcg"

# Print out the created configuration file
if [[ -f "$varOcg" ]]; then
  echo "✅ kubeconfig file created successfully:"
  cat "$varOcg"
else
  echo "❌ kubeconfig file was not created properly."
fi
