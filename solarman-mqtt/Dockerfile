# Home Assistant add-on: Solarman MQTT Bridge
FROM python:3.10-alpine

# Install Python requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install required packages
RUN apk add --no-cache jq curl bash

# Copy application files
WORKDIR /
COPY solarman.py .
COPY mqtt.py .
COPY run.sh .
COPY test-solarmanapi.sh .

# Make startup script executable
RUN chmod +x /run.sh /test-solarmanapi.sh

# Set environment
ENV CONFIG_PATH=/config/

# Run the startup script
CMD ["/run.sh"]