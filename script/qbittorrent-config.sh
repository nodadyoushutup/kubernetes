#!/bin/sh
set -e

INIT_PORT_TRAFFIC=${INIT_PORT_TRAFFIC:-31025}
DEFAULT_FILE="/tmp/git/conf/qbittorrent-default.conf"
CONF_FILE="/config/qBittorrent/qBittorrent.conf"

add_config_to_section() {
    local KEY="$1"
    local VALUE="$2"
    local SECTION="$3"
    local FILE="$4"
    local TEMP_FILE=$(mktemp)

    echo "Checking if '$KEY' exists in the [$SECTION] section of $FILE."

    awk -v key="$KEY" -v value="$VALUE" -v section="$SECTION" '
    BEGIN { in_section = 0; key_found = 0; }
    /^\[.*\]/ { in_section = 0; }
    /^\['"$SECTION"'\]/ { in_section = 1; }
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
    ' "$FILE" > "$TEMP_FILE"

    mv "$TEMP_FILE" "$FILE"
    echo "'$key=$VALUE' added to the [$SECTION] section in the configuration."
}

if [ ! -f "$CONF_FILE" ]; then
    echo "Configuration file not found at $CONF_FILE."
    echo "Copying default configuration from $DEFAULT_FILE to $CONF_FILE."
    mkdir -p $(dirname "$CONF_FILE")
    cp "$DEFAULT_FILE" "$CONF_FILE"
    add_config_to_section "Session\\Port" "$INIT_PORT_TRAFFIC" "BitTorrent" "$CONF_FILE"
    echo "Default configuration copied."
else
    echo "Configuration file already exists at $CONF_FILE. Checking contents."
fi
