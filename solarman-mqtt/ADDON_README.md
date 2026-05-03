# Solarman MQTT Bridge Add-on for Home Assistant

![Solarman Workflow](https://github.com/hareeshmu/solarman/actions/workflows/image.yml/badge.svg)

A Home Assistant add-on that retrieves Solar PV data from the Solarman API and publishes it to an MQTT broker for use in Home Assistant automations and dashboards.

## About

This add-on bridges Solarman Smart platform data (used by various solar inverter manufacturers like Sofar) with Home Assistant through MQTT. It periodically fetches:
- Power output (W)
- Energy generation (kWh)
- Other device metrics from your solar installation

## Prerequisites

1. **Solarman API Credentials**: Required to access your solar data
   - Request API AppID and Secret from: service@solarmanpv.com
   - Your Solarman account email and password
   - Station ID and Device details from your Solarman account

2. **MQTT Broker**: Home Assistant with built-in Mosquitto add-on or external MQTT broker
   - Broker address (e.g., `core-mosquitto` for built-in)
   - MQTT credentials

## Installation

1. Add the repository to Home Assistant add-ons (if not pre-installed)
2. Install the "Solarman MQTT Bridge" add-on
3. Configure the add-on with your credentials (see Configuration section)
4. Start the add-on
5. Check the add-on logs for success

## Configuration

### Solarman Settings

| Option | Required | Description | Example |
|--------|----------|-------------|---------|
| **api_url** | Yes | Solarman API endpoint | `api.solarmanpv.com` |
| **appid** | Yes | API Application ID | `1234567890` |
| **secret** | Yes | API Application Secret | `234abcdefg123456` |
| **username** | Yes | Solarman account email | `user@example.com` |
| **password** | Yes | Solarman account password | - |
| **orgId** | No | Organization ID (if required) | - |
| **stationId** | Yes | Your solar station ID | `1234567` |
| **inverterId** | Yes | Inverter serial number | `SA12345MB12345` |
| **loggerId** | No | Logger device ID | `789543245` |
| **interval** | Yes | Polling interval in seconds | `300` (5 minutes) |
| **debug** | No | Enable debug logging | `false` |

### MQTT Settings

| Option | Default | Description |
|--------|---------|-------------|
| **broker** | `core-mosquitto` | MQTT broker hostname/IP |
| **port** | `1883` | MQTT broker port |
| **topic** | `solarmanpv` | Base MQTT topic for publishing |
| **username** | - | MQTT username |
| **password** | - | MQTT password |

### Example Configuration

```json
{
  "solarman": {
    "api_url": "api.solarmanpv.com",
    "appid": "1234567890",
    "secret": "234abcdefg123456",
    "username": "user@example.com",
    "password": "yourpassword",
    "orgId": "",
    "stationId": 1234567,
    "inverterId": "SA12345MB12345",
    "loggerId": 789543245,
    "interval": 300,
    "debug": false
  },
  "mqtt": {
    "broker": "core-mosquitto",
    "port": 1883,
    "topic": "solarmanpv",
    "username": "mqtt_user",
    "password": "mqtt_password"
  }
}
```

## MQTT Topics

The add-on publishes data to MQTT topics under the configured base topic. Check the logs to see which metrics are available from your specific inverter.

Example topics (depending on your device):
- `solarmanpv/power` - Current power output in Watts
- `solarmanpv/energy` - Total energy in kWh
- `solarmanpv/[device_sn]/power` - Device-specific metrics

## Home Assistant Integration

Once the add-on is running and publishing to MQTT, add the following to your `configuration.yaml` to create sensors:

```yaml
mqtt:
  sensor:
    - name: "Solar Power"
      unique_id: solar_power
      state_topic: "solarmanpv/power"
      unit_of_measurement: "W"
      device_class: "power"
    
    - name: "Solar Energy"
      unique_id: solar_energy
      state_topic: "solarmanpv/energy"
      unit_of_measurement: "kWh"
      device_class: "energy"
```

Or use Home Assistant's MQTT integration UI to auto-discover devices.

## Supported Hardware

- **CPU Architectures**: amd64, armv7, aarch64
- **Minimum Requirements**: 
  - 512MB RAM
  - 100MB storage for add-on
  - Network connectivity

## Troubleshooting

### "Unable to fetch token" error
- Verify API credentials (appid, secret) are correct
- Check Solarman email and password
- Ensure the account has API access enabled
- Contact service@solarmanpv.com if issues persist

### No MQTT messages being published
- Verify MQTT broker is running and accessible
- Check MQTT credentials are correct
- Review add-on logs for connection errors
- Ensure network connectivity to the broker

### Enable Debug Logging
Set `debug: true` in configuration to see detailed logs including:
- API requests and responses
- MQTT publish operations
- Data parsing details

## Performance Notes

- **Interval**: Recommended 300-600 seconds (5-10 minutes) to avoid API rate limits
- **Network**: Requires stable internet connection to Solarman API
- **Resources**: Minimal CPU and memory usage

## Support

For issues related to:
- **This add-on**: Check Home Assistant add-on logs
- **Solarman API**: Contact service@solarmanpv.com
- **MQTT**: Verify Mosquitto add-on is running

## License

See LICENSE file in repository

## Credits

Based on original work by hareeshmu/solarman: https://github.com/hareeshmu/solarman
