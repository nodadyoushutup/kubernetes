#!/bin/bash

# List of node IP addresses
NODES=("192.168.0.211" "192.168.0.212" "192.168.0.213" "192.168.0.214" "192.168.0.215" "192.168.0.216" "192.168.0.217")

# SSH user
SSH_USER="ubuntu"

# Function to install nfs-common on a node
install_nfs_common() {
    NODE_IP=$1
    echo "Installing nfs-common on node $NODE_IP"
    ssh ${SSH_USER}@${NODE_IP} "sudo apt-get update && sudo apt-get install -y nfs-common"
    if [ $? -eq 0 ]; then
        echo "Successfully installed nfs-common on $NODE_IP"
    else
        echo "Failed to install nfs-common on $NODE_IP"
    fi
}

# Loop through each node and install nfs-common
for NODE in "${NODES[@]}"; do
    install_nfs_common ${NODE}
done
