#!/bin/bash
set -e

# Verify if NAMESPACE environment variable is set
if [ -z "$NAMESPACE" ]; then
  echo "NAMESPACE environment variable is not set."
  exit 1
fi

# Define the tar.gz file path
FILE="/init/${NAMESPACE}_init.tar.gz"

# Check if the tar.gz file exists
if [ -f "$FILE" ]; then
  echo "Removing existing files"
  rm -rf /config/**
  echo "Found $FILE. Extracting to /config..."
  tar -xzvf "$FILE" -C /config --overwrite
  echo "Extraction complete."
else
  echo "File $FILE does not exist. No migration action is necessary."
fi
