#!/bin/sh
# script/pvc-bound.sh 

echo "Waiting for PVC to be bound in ${NAMESPACE} namespace..."
until [ "$(kubectl get pvc ${NAMESPACE}-pvc -n ${NAMESPACE} -o jsonpath='{.status.phase}')" = "Bound" ]; do
    echo "PVC not bound yet. Waiting..."
    sleep 2
done
echo "PVC is bound."