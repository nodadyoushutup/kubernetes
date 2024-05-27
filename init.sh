#!/bin/bash

# Wait until the metallb pod is running
echo "Applying MetalLB manifests"
kubectl apply -f metallb/metallb-cm.yaml

# Wait until the Kubernetes CSI pods are running
echo "Applying Kubernetes CSI manifests"
kubectl apply -f kubernets-csi

# Create the argocd namespace
echo "Installing ArgoCD"
kubectl create namespace argocd

# Apply the ArgoCD installation manifests
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait until the argocd-server pod is running
echo "Waiting for argocd-server pod to be running..."
while [[ $(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
  echo -n "."
  sleep 5
done
echo "argocd-server pod is running."

# Apply the ArgoCD service manifest
kubectl apply -f argocd/argocd-svc.yaml

# Get the initial admin password
echo "Initial ArgoCD password"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo


echo "All components are deployed and running."

