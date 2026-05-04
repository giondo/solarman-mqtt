# ⚡ Solarman MQTT Bridge - Home Assistant App

[![Validate Add-on](https://github.com/giondo/solarman-mqtt/actions/workflows/validate.yml/badge.svg)](https://github.com/giondo/solarman-mqtt/actions)

A **Home Assistant App** that retrieves current Solar PV data from the Solarman API and publishes Power (W) and Energy (kWh) metrics to an MQTT broker for home automation. Perfect for integrating solar inverters using the Solarman Smart platform (like Sofar inverters with logger) into Home Assistant.

## 🚀 Quick Installation

### Home Assistant App Store add repo (Recommended)

1. In Home Assistant, go to **Settings → Apps → Install APP**
2. Click the three dots menu (⋮) in the top right
3. Select **Repositories**
4. Click the **Add** button
5. Paste this repository URL:
   ```
   https://github.com/giondo/solarman-mqtt
   ```
6. Click **Add**
7. Close the dialog and return to the App Store
8. 📖 Configuration

### Home Assistant App Store install App (Recommended)

1. In Home Assistant, go to **Settings → Apps → Install APP**
2. Select Solarman MQTT Bridge
3. Click on Install

The add-on provides a web UI for configuration in Home Assistant. Configure:

- **Solarman API Settings**:
  - API URL (default: `api.solarmanpv.com`)
  - AppID and Secret
  - Username (email) and password
  - Station ID and Device IDs
  - Polling interval (seconds, default: 300)

- **MQTT Settings**:
  - Broker address (default: `core-mosquitto` for built-in)
  - Port (default: 1883)
  - Topic prefix (default: `solarmanpv`)
  - MQTT username and password

See [ADDON_README.md](ADDON_README.md) for detailed configuration options.

## 🔧 Advanced: Manual Docker Usage

Supported platforms: `linux/amd64`, `linux/386`, `linux/arm/v7`, `linux/arm/v6`, `linux/arm64`

### Docker Example

```bash
# Clone and setup
git clone https://github.com/giondo/solarman-mqtt
cd solarman-mqtt
cp config.sample.json config.json
# Edit config.json with your credentials

# Run with Docker
docker run -d \
  --name solarman \
  --restart unless-stopped \
  -v $(pwd)/config.json:/config/config.json \
  giondo/solarman-mqtt:latest
```

### Docker Compose

```yaml
version: "3.7"
services:
  solarman:
    image: giondo/solarman-mqtt:latest
    container_name: solarman
    restart: unless-stopped.json # setup your config
sudo docker run --name solarman -d --restart unless-stopped -v /YOUR/PATH/HERE/config.json:/config.json hareeshmu/solarman:latest
```

### Using docker-compose

This `docker-compose.yml` example can be used with docker-compose or podman-compose

```lang=yaml
version: "3.7"
services:
  solarman:
    image: hareeshmu/solarman:latest
    container_name: solarman
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - /YOUR/PATH/HERE/config.json:/config.json
    restart: unless-stopped
```

### Using Python

Run `pip install -r requirements.txt` and start `python3 solarman.py`.

Run `pip install -r requirements.txt` and start `python3 solarman.py --repeat`.

## MQTT topics

### Station (Plant)

```lang=bash
solarmanpv/station/batteryPower
solarmanpv/station/batterySoc
solarmanpv/station/chargePower
solarmanpv/station/dischargePower
solarmanpv/station/generationPower
solarmanpv/station/gridPower
solarmanpv/station/irradiateIntensity
solarmanpv/station/lastUpdateTime
solarmanpv/station/purchasePower
solarmanpv/station/usePower
solarmanpv/station/wirePower
```

### Inverter

```lang=bash
solarmanpv/inverter/deviceId
solarmanpv/inverter/deviceSn
solarmanpv/inverter/deviceState
solarmanpv/inverter/deviceType

solarmanpv/inverter/attributes # contains all inverter datalist entries.
```

#### Inverter Attributes

```lang=bash
SN: XXXXXXXXXX
Device_Type: 4
Production_Compliance_Type: 0
Rated_Power: 300.00
Year: 48
Month: 0
Day: 0
Hour: 0
Minute: 0
Seconds: 0
Communication_Protocol_Version: V0.2.0.1
Control_Board_Firmware_Version: V0.1.1.2
Communication_Board_Firmware_Version: V0.2.0.7
DC_Voltage_PV1: 0.00
DC_Voltage_PV2: 0.00
DC_Voltage_PV3: 0.00
DC_Voltage_PV4: 0.00
DC_Current_PV1: 0.00
DC_Current_PV2: 0.00
DC_Current_PV3: 0.00
DC_Current_PV4: 0.00
DC_Power_PV1: 0.00
DC_Power_PV2: 0.00
DC_Power_PV3: 0.00
DC_Power_PV4: 0.00
AC_Voltage_1: 0.00
AC_Current_1: 0.00
Total_AC_Output_Power(Active): 0
AC_Output_Frequency_1: 0.00
Total_Production(Active): 2.50
Total_Production_1: 2.50
Total_Production_2: 0.00
Total_Production_3: 0.00
Total_Production_4: 0.00
Daily_Production(Active): 0.70
Daily_Production_1: 0.70
Daily_Production_2: 0.00
Daily_Production_3: 0.00
Daily_Production_4: 0.00
AC_Radiator_Temp: -10.00
Micro_Inverter_Port_1: XXXXXXXXXX-1
Micro_Inverter_Port_2: XXXXXXXXXX-2
Micro_Inverter_Port_3: XXXXXXXXXX-3
Micro_Inverter_Port_4: XXXXXXXXXX-4
Number_Of_MPPT_Paths: 1
Number_Of_Phases: 1
Running_Status: 4
Overfrequency_And_Load_Reduction_Starting_Point: 50.20
Islanding Protection Enabled: Enable
Overfrequency_And_Load_Reduction_Percentage: 44
GFDI Enabled: Disable
Grid-connected Standard: 0
Grid Voltage_Upper_Limit: 275.00
Grid Voltage_Lower_Limit: 180.00
Grid Frequency_Upper_Limit: 52.00
Grid Frequency_Lower_Limit: 47.50
Start-up Self-checking Time: 60
```

### Logger (Collector)

```lang=bash
solarmanpv/logger/deviceId
solarmanpv/logger/deviceSn
solarmanpv/logger/deviceState
solarmanpv/logger/deviceType

solarmanpv/logger/attributes # contains all logger datalist entries
```

#### Logger Attributes

```lang=bash
Embedded_Device_SN: XXXXXXXXXX
Module_Version_No: MW3_15_5406_1.35
Extended_System_Version: V1.1.00.07
Total_running_time: 1
Offset_time: 1634486607
Data_Uploading_Period: 5
Data_Acquisition_Period: 60
Max._No._of_Connected_Devices: 1
Signal_Strength: 100
Heart_Rate: 120
IV_Curve_Supported: 1
Batch_Command_Supported: 1
Support_Reporting_Upgrading_Progress: 0
AT+UPGRADE_Command_Supported: 255
Method_Of_Protocol_Upgrade: 255
```

## Home Assistant

### Yaml configuration in your Home assistant

please refer to the [configuration.yaml](ha-yaml/configuration.yaml) file for the configuration of the Home Assistant integration.

All Credits go to [Hareeshmu](https://github.com/hareeshmu) for the initial implementation of this App.