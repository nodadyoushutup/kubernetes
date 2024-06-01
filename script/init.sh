#!/bin/bash
set -e

# Verify if NAMESPACE environment variable is set
if [ -z "$NAMESPACE" ]; then
  echo "NAMESPACE environment variable is not set."
  exit 1
fi

# Define the tar.gz file path
TAR_FILE="/init/${NAMESPACE}_init.tar.gz"

# Check if the tar.gz file exists
if [ -f "$TAR_FILE" ]; then
  echo "Found $TAR_FILE. Extracting to /config..."

  # Extract the contents to /config and overwrite any existing files
  tar -xzvf "$TAR_FILE" -C /config --overwrite
  echo "Extraction complete."
else
  echo "File $TAR_FILE does not exist. No migration action is necessary."
fi
