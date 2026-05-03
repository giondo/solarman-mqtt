#!/bin/sh
# Home Assistant add-on: Solarman MQTT Bridge
# Entry point that converts Home Assistant add-on options to config and starts the service

set -e

CONFIG_FILE=/config/config.json
OPTIONS_FILE=/data/options.json

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log "Starting Solarman MQTT Bridge..."

# Check if options file exists and convert to config.json
if [ -f "$OPTIONS_FILE" ]; then
    log "Converting Home Assistant options to config.json..."
    python3 << 'EOF'
import json
import os

OPTIONS_FILE = "/data/options.json"
CONFIG_FILE = "/config/config.json"

try:
    # Read Home Assistant add-on options
    with open(OPTIONS_FILE, "r") as f:
        options = json.load(f)
    
    # Build the config structure for solarman.py
    config = {
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
    
    # Ensure config directory exists
    os.makedirs("/config", exist_ok=True)
    
    # Write the config file
    with open(CONFIG_FILE, "w") as f:
        json.dump(config, f, indent=2)
    
    print("✓ Configuration file created successfully")
except Exception as e:
    print(f"✗ Error converting options: {e}")
    exit(1)
EOF
else
    log "No options file found. Using existing config.json or creating a template..."
    if [ ! -f "$CONFIG_FILE" ]; then
        log "Creating sample config.json - please update with your credentials"
        mkdir -p /config
        cat > "$CONFIG_FILE" << 'SAMPLE'
{
  "name": "Solarman",
  "url": "api.solarmanpv.com",
  "appid": "your_appid_here",
  "secret": "your_secret_here",
  "username": "your_email@example.com",
  "password": "your_password_here",
  "orgId": "",
  "stationId": 0,
  "inverterId": "",
  "loggerId": 0,
  "interval": 300,
  "debug": false,
  "mqtt": {
    "broker": "core-mosquitto",
    "port": 1883,
    "topic": "solarmanpv",
    "username": "mqtt_user",
    "password": "mqtt_password"
  }
}
SAMPLE
    fi
fi

# Verify configuration
log "Verifying configuration..."
python3 << 'VERIFY'
import json
import sys

try:
    with open("/config/config.json", "r") as f:
        config = json.load(f)
    
    required_fields = ["appid", "secret", "username", "password", "stationId"]
    missing = [f for f in required_fields if not config.get(f)]
    
    if missing:
        print(f"✗ Missing required configuration fields: {', '.join(missing)}")
        sys.exit(1)
    
    print("✓ Configuration is valid")
except Exception as e:
    print(f"✗ Error verifying configuration: {e}")
    sys.exit(1)
VERIFY

# Start the Solarman application
log "Starting Solarman application..."
export CONFIG_PATH=/config/
exec python3 -u /solarman.py --repeat
