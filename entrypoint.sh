#!/bin/bash
set -e

# Ensure GoTTY binary is available
if ! command -v gotty >/dev/null 2>&1; then
    echo "ERROR: GoTTY not found in PATH!" >&2
    exit 127
fi

# Default command if none provided
CMD_TO_RUN="${@:-/bin/bash}"

echo "Starting GoTTY on port 8080..."
exec gotty --port 8080 --permit-write --reconnect $CMD_TO_RUN
