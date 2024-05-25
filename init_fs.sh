#!/bin/bash

# List of worker node IP addresses
NODES=("192.168.0.204" "192.168.0.205" "192.168.0.206" "192.168.0.207")

# SSH user
SSH_USER="ubuntu"

# Path to local ceph.conf and ceph.client.admin.keyring
LOCAL_CEPH_CONF="./ceph.conf"
LOCAL_KEYRING="./keyring"

# Function to initialize a Ceph worker node
init_ceph_node() {
    NODE_IP=$1
    echo "Initializing Ceph on node $NODE_IP"
    
    # Install required packages
    ssh ${SSH_USER}@${NODE_IP} "sudo apt-get update && sudo apt-get install -y nfs-common ceph-common ceph-fuse"
    
    # # Ensure /etc/ceph directory exists
    # ssh ${SSH_USER}@${NODE_IP} "sudo mkdir -p /etc/ceph"
    
    # # Copy ceph.conf and keyring to the node's home directory
    # scp ${LOCAL_CEPH_CONF} ${SSH_USER}@${NODE_IP}:/home/${SSH_USER}/ceph.conf
    # scp ${LOCAL_KEYRING} ${SSH_USER}@${NODE_IP}:/home/${SSH_USER}/ceph.client.admin.keyring
    
    # # Move the files to /etc/ceph and set the correct permissions
    # ssh ${SSH_USER}@${NODE_IP} "sudo mv /home/${SSH_USER}/ceph.conf /etc/ceph/ceph.conf"
    # ssh ${SSH_USER}@${NODE_IP} "sudo mv /home/${SSH_USER}/ceph.client.admin.keyring /etc/ceph/ceph.client.admin.keyring"
    # ssh ${SSH_USER}@${NODE_IP} "sudo chmod 600 /etc/ceph/ceph.client.admin.keyring && sudo chown ceph:ceph /etc/ceph/ceph.client.admin.keyring"
    
    if [ $? -eq 0 ]; then
        echo "Successfully initialized Ceph on $NODE_IP"
    else
        echo "Failed to initialize Ceph on $NODE_IP"
    fi
}

# Loop through each node and initialize Ceph
for NODE in "${NODES[@]}"; do
    init_ceph_node ${NODE}
done
