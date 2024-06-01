#!/bin/sh
echo "Starting job at $(date)"
BACKUP_FILE="/tarshot/${NAMESPACE}_backup_$(date +%Y_%m_%d_%H_%M_%S).tar.gz"
tar -czvf ${BACKUP_FILE} /config
# chown 568:568 ${BACKUP_FILE}
echo "Job completed at $(date)"