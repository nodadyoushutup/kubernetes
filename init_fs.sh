#!/bin/bash

# List of node IP addresses
NODES=("192.168.0.201" "192.168.0.202" "192.168.0.203" "192.168.0.204" "192.168.0.205" "192.168.0.206" "192.168.0.207")

# SSH user
SSH_USER="ubuntu"

# Function to install nfs-common on a node
install_fs_pkgs() {
    NODE_IP=$1
    echo "Installing nfs-common on node $NODE_IP"
    ssh ${SSH_USER}@${NODE_IP} "sudo apt-get update && sudo apt-get install -y nfs-common"
    ssh ${SSH_USER}@${NODE_IP} "sudo apt-get update && sudo apt-get install -y ceph-common"
    ssh ${SSH_USER}@${NODE_IP} "sudo apt-get update && sudo apt-get install -y ceph-fuse"
    if [ $? -eq 0 ]; then
        echo "Successfully installed nfs-common on $NODE_IP"
    else
        echo "Failed to install nfs-common on $NODE_IP"
    fi
}


# Loop through each node and install nfs-common
for NODE in "${NODES[@]}"; do
    install_fs_pkgs ${NODE}
done
