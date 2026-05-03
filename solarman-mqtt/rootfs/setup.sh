#!/bin/bash
set -e

# This script prepares the Docker image with all necessary files
# It's copied to rootfs during the Docker build

# Create necessary directories
mkdir -p /etc/services.d/solarman

# Copy the main startup script
echo '#!/bin/bash' > /etc/services.d/solarman/run
echo 'export CONFIG_PATH=/config/' >> /etc/services.d/solarman/run
echo 'exec python3 -u /solarman.py --repeat' >> /etc/services.d/solarman/run
chmod +x /etc/services.d/solarman/run

echo "✓ Add-on environment prepared"
