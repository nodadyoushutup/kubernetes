#Personal
ssh -f -N -L 8080:localhost:8080 user@192.168.0.99

#On cluster
kubectl port-forward svc/argocd-server -n argocd 8080:443