#!/bin/sh
set -e

DEFAULT_FILE="/script/qBittorrent-default.conf"
CONF_FILE="/config/qBittorrent/qBittorrent.conf"

# Check if the destination configuration file exists
if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file not found at $CONF_FILE."
    echo "Copying default configuration from $DEFAULT_FILE to $CONF_FILE."

    # Ensure the destination directory exists
    mkdir -p $(dirname "$CONF_FILE")

    # Copy the default configuration file to the destination
    cp "$DEFAULT_FILE" "$CONF_FILE"

    echo "Default configuration copied."
else
    echo "Configuration file already exists at $CONF_FILE. Checking contents."

    # Check if "WebUI\HostHeaderValidation=false" exists in the file
    if ! grep -q "^WebUI\\HostHeaderValidation=false" "$CONF_FILE"; then
        echo "Adding 'WebUI\HostHeaderValidation=false' to the Preferences section in $CONF_FILE."

        # Find the line number where the [Preferences] section starts
        PREF_LINE=$(grep -n "^\[Preferences\]" "$CONF_FILE" | cut -d ':' -f 1)

        if [ -n "$PREF_LINE" ]; then
            # Add the setting right after the Preferences section header
            PREF_LINE=$((PREF_LINE + 1))
            sed -i "${PREF_LINE}iWebUI\\HostHeaderValidation=false" "$CONF_FILE"
        else
            # If the Preferences section is not found, append the line at the end of the file
            echo "[Preferences]" >> "$CONF_FILE"
            echo "WebUI\\HostHeaderValidation=false" >> "$CONF_FILE"
        fi

        echo "'WebUI\HostHeaderValidation=false' added to the configuration."
    else
        echo "'WebUI\HostHeaderValidation=false' is already present in $CONF_FILE."
    fi
fi
