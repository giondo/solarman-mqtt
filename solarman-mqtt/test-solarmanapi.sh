#!/bin/bash
set -e

CONFIG_FILE="${CONFIG_PATH:-./}config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    echo "Please copy config.sample.json to config.json and update it with your credentials."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required but not installed. Please install it."
    exit 1
fi

# Read configuration from config.json
APP_ID=$(jq -r '.appid' "$CONFIG_FILE")
APP_SECRET=$(jq -r '.secret' "$CONFIG_FILE")
EMAIL=$(jq -r '.username' "$CONFIG_FILE")
PASSWORD=$(jq -r '.password' "$CONFIG_FILE")
API_URL=$(jq -r '.url' "$CONFIG_FILE")

# Solarman API requires SHA256 hashed password
HASHED_PASSWORD=$(echo -n "$PASSWORD" | sha256sum | awk '{print $1}')

echo "Fetching access token from ${API_URL}..."

# Request access token
TOKEN_RESPONSE=$(curl -s --request POST \
  --url "https://${API_URL}/account/v1.0/token?appId=${APP_ID}&language=en" \
  --header 'Content-Type: application/json' \
  --data '{
    "appSecret": "'"${APP_SECRET}"'",
    "email": "'"${EMAIL}"'",
    "password": "'"${HASHED_PASSWORD}"'"
  }')

ACCESS_TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token // empty')

if [ -z "$ACCESS_TOKEN" ]; then
    echo "Error: Failed to obtain access token."
    echo "API Response: $TOKEN_RESPONSE"
    exit 1
fi

echo "Access token obtained successfully. Fetching station list..."

# Request station list using the obtained token
curl -s --request POST \
  --url "https://${API_URL}/station/v1.0/list" \
  --header "Authorization: bearer ${ACCESS_TOKEN}" \
  --header 'Content-Type: application/json' \
  --data '{
    "page": 1,
    "size": 10
  }' | jq .