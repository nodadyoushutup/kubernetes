#!/bin/bash

# List of node IP addresses
NODES=("192.168.0.214" "192.168.0.215" "192.168.0.216" "192.168.0.217")

# Path to be created
DIR_PATH="/mnt/config/radarr"

# User and group to own the directory
USER_ID=568
GROUP_ID=568

# SSH user
SSH_USER="ubuntu"

# Function to create directory and set ownership on a node
setup_node() {
    NODE_IP=$1
    echo "Setting up node $NODE_IP"
    ssh ${SSH_USER}@${NODE_IP} "sudo mkdir -p ${DIR_PATH} && sudo chown -R ${USER_ID}:${GROUP_ID} ${DIR_PATH}"
    if [ $? -eq 0 ]; then
        echo "Successfully set up $NODE_IP"
    else
        echo "Failed to set up $NODE_IP"
    fi
}

# Loop through each node and set it up
for NODE in "${NODES[@]}"; do
    setup_node ${NODE}
done
