#!/bin/sh
set -e

DEFAULT_FILE="/tmp/git/conf/qbittorrent-default.conf"
CONF_FILE="/config/qBittorrent/qBittorrent.conf"

# Function to add a configuration key-value pair to a specified section
add_config_to_section() {
    local key="$1"
    local value="$2"
    local section="$3"
    local file="$4"
    local tempfile=$(mktemp)

    echo "Checking if '$key' exists in the [$section] section of $file."

    awk -v key="$key" -v value="$value" -v section="$section" '
    BEGIN { in_section = 0; key_found = 0; }
    /^\[.*\]/ { in_section = 0; }
    /^\['"$section"'\]/ { in_section = 1; }
    in_section && $0 ~ "^" key "=" { key_found = 1; $0 = key "=" value; }
    { print; }
    END {
        if (!key_found) {
            if (!in_section) {
                print "[" section "]";
            }
            print key "=" value;
        }
    }
    ' "$file" > "$tempfile"

    mv "$tempfile" "$file"
    echo "'$key=$value' added to the [$section] section in the configuration."
}

# Check if the destination configuration file exists
if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file not found at $CONF_FILE."
    echo "Copying default configuration from $DEFAULT_FILE to $CONF_FILE."

    # Ensure the destination directory exists
    mkdir -p $(dirname "$CONF_FILE")

    # Copy the default configuration file to the destination
    cp "$DEFAULT_FILE" "$CONF_FILE"

    add_config_to_section "Session\\Port" "$PORT_TRAFFIC" "BitTorrent" "$CONF_FILE"

    echo "Default configuration copied."
else
    echo "Configuration file already exists at $CONF_FILE. Checking contents."

    # Call the function with your specific key-value pair and section
    # add_config_to_section "WebUI\\HostHeaderValidation" "false" "Preferences" "$CONF_FILE"
fi
