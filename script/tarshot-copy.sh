#!/bin/sh
# script/tarshot-copy.sh
echo "Starting job at $(date)"
FILE="/tarshot/${NAMESPACE}-backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz"
tar -czvf ${FILE} /config --owner=568 --group=568
echo "Job completed at $(date)"