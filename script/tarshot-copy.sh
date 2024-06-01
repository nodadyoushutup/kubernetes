#!/bin/sh
echo "Starting job at $(date)"
BACKUP_FILE="/nfs/${NAMESPACE}_backup_$(date +%Y_%m_%d_%H_%M_%S).tar.gz"
tar -czf ${BACKUP_FILE} /pvc
chown 568:568 ${BACKUP_FILE}
echo "Job completed at $(date)"