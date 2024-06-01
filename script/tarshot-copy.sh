#!/bin/sh
echo "Starting job at $(date)"
FILE="/tarshot/${NAMESPACE}-backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz"
tar -czvf ${FILE} /config
# chown 568:568 ${FILE}
echo "Job completed at $(date)"