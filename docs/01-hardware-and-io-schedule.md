# 01 · Hardware and I/O Schedule

[← Back to README](../README.md) · Data: [`data/io-schedule.csv`](../data/io-schedule.csv)

## Boards

| Board | ESPHome name | Location | Role |
|---|---|---|---|
| ESP32-S3-DevKitC-1 (16 MB) | `esp32-control-room-heating` | Boiler / control room | Boiler temperatures, pressure, current, demand signals, tundishes, DHW cylinders |
| ESP32-S3-DevKitC-1 (16 MB) | `understairs-monitor` | Understairs (UFH manifold, consumer unit) | UFH pump and cooker circuit current, UFH manifold flow/return |
| diymore ESP8266 D1 mini + DIYLESS Master OpenTherm Shield (planned) | `esp8266-opentherm` | By the boiler, 3D-printed enclosure | OpenTherm master (control stage), kept separate from the monitoring board |

Both use encrypted API keys and credentials from `secrets.yaml`, MQTT keepalive 60 s, and OTA.

## Pins to avoid on the ESP32-S3 (board-wide)

| Pins | Reason |
|---|---|
| GPIO35, 36, 37 | Octal PSRAM |
| GPIO48 | On-board RGB LED |
| GPIO0, 45, 46 | Strapping pins |
| GPIO43, 44 | UART console |
| **ADC2 (GPIO11-20) for analogue** | ADC2 is unusable while Wi-Fi is on. Those pins are fine for **digital** use |
| **ADC1 = GPIO1-10** | The only ADC pins usable with Wi-Fi, so they're the scarce resource on this board |

## Control room: current vs proposed allocation

| Signal | Current | Proposed | Type | Status |
|---|---|---|---|---|
| Boiler flow temp (NTC) | GPIO4 | GPIO4 | ADC1 | Installed, noisy |
| Boiler return temp (NTC) | GPIO5 | GPIO5 | ADC1 | Installed, noisy |
| Boiler system pressure | GPIO1 (+ anchor GPIO2, bridge GPIO42) | **GPIO1** (10k/20k divider) | ADC1 | Installed, zero to calibrate |
| Boiler supply current (SCT013-015) | GPIO3 (+ cap anchor GPIO13) | GPIO3 | ADC1 | To install |
| Boiler demand (boiler switched live, opto) | GPIO6 | **GPIO14** | Digital | To install |
| Radiator demand (BDR91, opto) | GPIO7 | **GPIO18** | Digital | To install |
| UFH demand (BDR91, opto) | GPIO15 | GPIO15 | Digital | To install |
| Cylinder left demand (BDR91, opto) | GPIO16 | GPIO16 | Digital | To install |
| Cylinder right demand (BDR91, opto) | GPIO17 | GPIO17 | Digital | To install |
| Tundish plate power (pulsed) | GPIO21 | GPIO21 | Digital out | To install |
| Tundish 1 / 2 sense | GPIO39 / GPIO20 | same | Digital in | To install |
| Cylinder left hot-outlet temp | - | **GPIO8** | ADC1 | To install |
| Cylinder right hot-outlet temp | - | **GPIO9** | ADC1 | To install |
| Cylinder left inlet pressure | - | **GPIO2** | ADC1 | With plumber |
| Cylinder right inlet pressure | - | **GPIO10** | ADC1 | With plumber |

**Why the reshuffle:**
- **20 kΩ resistors** turn the three-resistor divider (10k + 10k + 10k with an "anchor" and a "bridge" pin) into a simple **two-resistor 10k/20k divider**. The ratio is the same (2/3), but it frees two GPIOs per sensor.
- **The opto inputs move off GPIO6/7** to digital-only pins, keeping every ADC1 pin for analogue signals.
- The result is **8 analogue signals on ADC1** (GPIO1, 2, 3, 4, 5, 8, 9, 10), with GPIO6 and 7 left spare.

## Understairs board (firmware flashed, sensors to connect)

| Signal | GPIO | Sensor |
|---|---|---|
| Cooker circuit current | GPIO2 | SCT013-030 (30 A = 1 V) |
| UFH pump current | GPIO10 (anchor GPIO12) | SCT013-005 (5 A = 1 V) |
| UFH flow temp (mixed) | GPIO4 | NTC 10k B3977 |
| UFH return temp | GPIO5 | NTC 10k B3977 |
| UFH manifold pressure (proposed) | GPIO1 | 0-5 bar transducer, 10k/20k divider |

Full detail: [doc 10](10-understairs-ufh-and-circuits.md)

## Sensors used

| Sensor | Range / output | Supply |
|---|---|---|
| NTC strap-on probes | 10 kΩ at 25 °C, **B = 3977** (corrected from the generic 3950) | Divider from 3V3 |
| Boiler pressure transducer | 0-5 bar, G1/4, 0.5-4.5 V | 5 V |
| Cylinder inlet transducers | 0-150 psi (0-10.34 bar), 0.5-4.5 V | 5 V |
| SCT013 current clamps | 015 = 15 A/1 V; 030 = 30 A/1 V; 005 = 5 A/1 V; built-in burden | Bias network |
| Opto-isolator module | Hailege 8-ch AC 220 V optocoupler; 230 V input → isolated logic output | **3.3 V logic supply** (outputs pulled up to VCC) |
| Tundish leak plates | Gold-plated contact plates + 2N7000 MOSFET | Pulsed 3V3 |
