#!/bin/bash
# Home Assistant add-on: Solarman MQTT Bridge
# This script converts Home Assistant add-on options to a config.json file

set -e

CONFIG_FILE=/config/config.json

# Create config from options
python3 << 'EOF'
import json
import os
import sys

# Get options from Home Assistant
options = {}
config_data = {}

# Check if options.json exists (set by Home Assistant)
if os.path.exists("/tmp/solarman_options.json"):
    with open("/tmp/solarman_options.json", "r") as f:
        options = json.load(f)

# If no options file, try to read from HOME ASSISTANT addon config
# This will be handled by Home Assistant's internal system

# Build the config structure
config = {
    "name": options.get("solarman", {}).get("name", "Solarman"),
    "url": options.get("solarman", {}).get("api_url", "api.solarmanpv.com"),
    "appid": options.get("solarman", {}).get("appid", ""),
    "secret": options.get("solarman", {}).get("secret", ""),
    "username": options.get("solarman", {}).get("username", ""),
    "password": options.get("solarman", {}).get("password", ""),
    "orgId": options.get("solarman", {}).get("orgId", ""),
    "stationId": options.get("solarman", {}).get("stationId", 0),
    "inverterId": options.get("solarman", {}).get("inverterId", ""),
    "loggerId": options.get("solarman", {}).get("loggerId", 0),
    "interval": options.get("solarman", {}).get("interval", 300),
    "debug": options.get("solarman", {}).get("debug", False),
    "mqtt": {
        "broker": options.get("mqtt", {}).get("broker", "core-mosquitto"),
        "port": options.get("mqtt", {}).get("port", 1883),
        "topic": options.get("mqtt", {}).get("topic", "solarmanpv"),
        "username": options.get("mqtt", {}).get("username", ""),
        "password": options.get("mqtt", {}).get("password", "")
    }
}

# Write the config file
with open("/config/config.json", "w") as f:
    json.dump(config, f, indent=2)

print("✓ Configuration file created successfully")
EOF

# Start the Solarman application
export CONFIG_PATH=/config/
exec python3 -u /solarman.py --repeat
