#!/bin/bash

# Namespace where ArgoCD is installed
NAMESPACE="argocd"

# Patch the argocd-cm ConfigMap to enable exec
kubectl patch cm argocd-cm -n $NAMESPACE --type='merge' -p='{"data": {"exec.enabled": "true"}}'

# Patch the argocd-cm ConfigMap to set the order of shells
kubectl patch cm argocd-cm -n $NAMESPACE --type='merge' -p='{"data": {"exec.shells": "bash,sh,powershell,cmd,zsh"}}'

# Patch the argocd-server Role to allow exec into pods
kubectl patch role argocd-server -n $NAMESPACE --type='json' -p='[{"op": "add", "path": "/rules/-", "value": {"apiGroups": [""], "resources": ["pods/exec"], "verbs": ["create"]}}]'

# Restart the ArgoCD server to apply the changes
kubectl rollout restart deployment argocd-server -n $NAMESPACE

echo "ArgoCD terminal configuration completed successfully."
