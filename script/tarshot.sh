#!/bin/sh
set -e

log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1"
}

delete_pvc() {
    local pvc_name=$1
    if kubectl get pvc "$pvc_name" -n ${NAMESPACE} &> /dev/null; then
    log "Removing finalizers from PVC"
    kubectl patch pvc ${NAMESPACE}-pvc-tarshot -n ${NAMESPACE} --type=json -p '[{"op": "remove", "path": "/metadata/finalizers"}]' && log "Finalizers removed from PVC"
    sleep 1
    log "Deleting PVC $pvc_name"
    kubectl delete pvc "$pvc_name" -n ${NAMESPACE} --ignore-not-found && log "PVC $pvc_name deleted"
    else
    log "PVC $pvc_name not found" &> /dev/null
    fi
}

delete_volumesnapshot() {
    local volumesnapshot_name=$1
    if kubectl get volumesnapshot "$volumesnapshot_name" -n ${NAMESPACE} &> /dev/null; then
    log "Removing finalizers from VolumeSnapshot"
    kubectl patch volumesnapshot ${NAMESPACE}-volumesnapshot-tarshot -n ${NAMESPACE} --type=json -p '[{"op": "remove", "path": "/metadata/finalizers"}]' && log "Finalizers removed from VolumeSnapshot"
    sleep 1
    log "Deleting VolumeSnapshot $volumesnapshot_name"
    kubectl delete volumesnapshot "$volumesnapshot_name" -n ${NAMESPACE} --ignore-not-found && log "VolumeSnapshot $volumesnapshot_name deleted"
    else
    log "VolumeSnapshot $volumesnapshot_name not found"
    fi
}

delete_job() {
    local job_name=$1
    if kubectl get job "$job_name" -n ${NAMESPACE} &> /dev/null; then
    log "Removing finalizers from Job"
    kubectl patch job ${NAMESPACE}-job-tarshot -n ${NAMESPACE} --type=json -p '[{"op": "remove", "path": "/metadata/finalizers"}]' && log "Finalizers removed from Job"
    sleep 1
    log "Deleting Job $job_name"
    kubectl delete job "$job_name" -n ${NAMESPACE} --ignore-not-found && log "Job $job_name deleted"
    else
    log "Job $job_name not found"
    fi
}

delete_assets() {
    local msg=${1:-"Deleting ephemeral assets"}
    log "$msg"
    delete_job "${NAMESPACE}-job-tarshot"
    delete_pvc "${NAMESPACE}-pvc-tarshot"
    delete_volumesnapshot "${NAMESPACE}-volumesnapshot-tarshot"
    log "Ephemeral assets have been deleted"
}

apply_asset() {
    local resource_type=$1
    local resource_name=$2
    local condition_field=$3
    local condition_value=$4
    local yaml_file=$5
    log "Applying $resource_type configuration" && envsubst < "$yaml_file" | kubectl apply -f -
    while [ "$(kubectl get "$resource_type" "$resource_name" -n ${NAMESPACE} -o jsonpath="{.status.$condition_field}")" != "$condition_value" ]; do
        log "Waiting for the $resource_type $resource_name to be $condition_value..."
        sleep 10
    done
}

apply_assets() {
    log "Starting backup job"
    apply_asset "volumesnapshot" "${NAMESPACE}-volumesnapshot-tarshot" "readyToUse" "true" "/tmp/git/backup/volumesnapshot-tarshot.yaml"
    apply_asset "pvc" "${NAMESPACE}-pvc-tarshot" "phase" "Bound" "/tmp/git/backup/pvc-tarshot.yaml"
    apply_asset "job" "${NAMESPACE}-job-tarshot" "succeeded" "1" "/tmp/git/backup/job-tarshot.yaml"
    log "Backup job completed"
}

delete_assets "Purging orphan assets (if they exist)"
apply_assets
delete_assets "Deleting ephemeral assets"