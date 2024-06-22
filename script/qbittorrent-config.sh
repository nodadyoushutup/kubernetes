#!/bin/sh
set -e

DEFAULT_FILE="/script/qBittorrent-default.conf"
CONF_FILE="/config/qBittorrent/qBittorrent.conf"

# Function to add a configuration key-value pair to a specified section
add_config_to_section() {
    local key="$1"
    local value="$2"
    local section="$3"
    local file="$4"

    echo "Checking if '$key' exists in the [$section] section of $file."

    # Check if the key already exists in the specified section
    if ! grep -q "^$key=$value" "$file"; then
        echo "Adding '$key=$value' to the [$section] section in $file."

        # Find the line number where the section starts
        local section_line=$(grep -n "^\[$section\]" "$file" | cut -d ':' -f 1)

        if [ -n "$section_line" ]; then
            # Add the setting right after the section header
            section_line=$((section_line + 1))
            sed -i "${section_line}i$key=$value" "$file"
        else
            # If the section is not found, append the section and setting at the end of the file
            echo "[$section]" >> "$file"
            echo "$key=$value" >> "$file"
        fi

        echo "'$key=$value' added to the [$section] section in the configuration."
    else
        echo "'$key=$value' is already present in the [$section] section."
    fi
}

# Check if the destination configuration file exists
if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file not found at $CONF_FILE."
    echo "Copying default configuration from $DEFAULT_FILE to $CONF_FILE."

    # Ensure the destination directory exists
    mkdir -p $(dirname "$CONF_FILE")

    # Copy the default configuration file to the destination
    cp "$DEFAULT_FILE" "$CONF_FILE"

    add_config_to_section "Session\\Port" $PORT_TRAFFIC "BitTorrent" "$CONF_FILE"

    echo "Default configuration copied."
else
    echo "Configuration file already exists at $CONF_FILE. Checking contents."

    # Call the function with your specific key-value pair and section
    add_config_to_section "WebUI\\HostHeaderValidation" "false" "Preferences" "$CONF_FILE"
fi
