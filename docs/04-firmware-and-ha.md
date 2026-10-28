# 04 · Firmware and Home Assistant

[← Back to README](../README.md) · YAML: [config/esphome/esp8266-opentherm.yaml](../config/esphome/esp8266-opentherm.yaml)

## Node
- ESPHome on the D1 mini (`esp8266`, `d1_mini`), native **OpenTherm** component on **GPIO4 (in)** / **GPIO5 (out)**.
- Fleet standards apply: encrypted API, OTA, `!secret` credentials, a shared fallback-hotspot secret, `captive_portal`, INFO logging, debug sensors.
- **The control logic runs on the node** ([doc 07](07-control-strategy.md)), so the boiler is still controlled sensibly if HA is offline.

## Data from the boiler (as supported; confirm in the first session)
| Entity | Purpose |
|---|---|
| Boiler flow temperature (`t_boiler`) | Control feedback; compare with the strap-on NTC |
| Return temperature (`t_ret`) | Condensing check |
| Relative modulation (`rel_mod_level`) | Load; anti-cycling insight |
| Flame on (`flame_on`) | Cycle counting |
| Fault indication / codes | Alarms |
| CH pressure (`ch_pressure`) | May not be reported; the transducer stays the reference |

## Controls sent to the boiler
| Item | Source |
|---|---|
| CH enable | Node logic: any demand, and not inhibited |
| CH flow setpoint (`t_set`) | Node logic: weather compensation + PID trim, clamped |
| DHW enable | Kept on (the cylinders are on zone valves; the boiler sees DHW demand as CH) |

## Inputs from HA (with stale-data handling)
| Input | Fallback if stale > 10 min |
|---|---|
| Outdoor temperature | Assume a cold design day (e.g. 0 °C) |
| Zone demand (from [doc 05](05-evohome-integration.md)) | Hard-wired demand only |
| Tuning parameters (helpers) | Last stored values |
