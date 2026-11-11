# 15 · Alerts: the Heating Plant Package

[← Back to README](../README.md)

Phone notifications for the plant, as one Home Assistant package: [config/homeassistant/packages/heating_plant_alerts.yaml](../config/homeassistant/packages/heating_plant_alerts.yaml). It holds the helpers, the derived sensors and **23 automations** in one file, so it can be versioned and published as a unit (automations in a package are listed in the UI but edited in the file). Several are the [FDD rules](https://github.com/the-control-cabinet/fdd-rules-heating-plant) running live.

## Switches (commissioning gates)

| Switch | Turn on when | Gates |
|---|---|---|
| Alerts: boiler pressure | The boiler gauge box is built and the sensor re-checked on GPIO6 | Low/high pressure, 24 h decay, pin fault |
| Alerts: cylinder inlet pressures | Both gauges live (on, 11 Nov) | Inlet high/low, pin fault |
| Alerts: opto demand inputs | The opto board's mains side is wired | Firing without call, lockout, timer, relay, stat and end-switch checks |

Gates keep an unconnected or floating sensor from raising false alarms (the boiler pressure pin read a meaningless 0.75 bar while disconnected), and silence the pressure alerts during plumbing work.

## The alerts

| Area | Alert | Logic (persistence) | FDD |
|---|---|---|---|
| Boiler | Short cycling | > 6 ignition attempts in the last hour (history_stats), repeat after 1 h | F1/F17 |
| Boiler | Flow above 80 °C | 2 min | - |
| Boiler | Pressure low / high / sensor | < 0.8 bar 10 min; > 2.5 bar 5 min; pin < 0.2 V | F20 |
| Boiler | Pressure falling | 24 h change < −0.1 bar, checked cold at 05:00 (statistics `change`) | F5 |
| Boiler | Firing without a call | 2 min (opto) | F2 |
| Boiler | Called but not firing (lockout?) | IN1 on, boiler off/idle 15 min (opto) | - |
| Hot water | Called but boiler not firing | Heat demand > 0 and boiler off/idle 15 min | F18 |
| Hot water | Reheat over 90 minutes | Heat demand 90 min | F9 |
| Hot water | Reheat finished below 55 °C | Top 10 min after heat demand drops | - |
| Hot water | Cylinder outlet above 70 °C | 5 min | - |
| Hot water | Weekly temperature not reached | Sunday 21:45: weekly max of each top below the target helper (60 °C) | - |
| Hot water | Inlet pressure high / low / sensor | > 4.5 bar 2 min; < 2 bar 10 min; pin < 0.2 V | F19, F20 |
| Opto | Timer blocking hot water | Heat demand and IN2 off 5 min | F16 |
| Opto | Relay commanded but output off | Heat demand, IN2 on, IN3/IN4 off 5 min | - |
| Opto | Cylinder stat not passing | IN3/IN4 on, IN5/IN6 off 10 min | F15 |
| Opto | Valve open but no boiler call | IN5/IN6/IN7 on, IN1 off 5 min | - |
| Sensors | Temperature probe fault | Any NTC < −10 or > 110 °C, 5 min | F20 |
| Boards | Control-room ESP32 offline | 5 min | F10 |
| Boards | ESP32 too warm | Chip > 75 °C, 10 min (found by name pattern) | - |
| Zones | Zone below 5.5 °C | Any climate entity, 10 min | - |
| Zones | Calling but not warming | Heat demand ≥ 95% and > 1 °C below setpoint, 2 h | F7 |
| Zones | Evohome battery low | Any thm/trv/dhw battery sensor on, 1 h | - |
| Digest | Daily heating digest | 21:30: starts, firing hours, cylinder tops, tundish events, pressures when enabled | - |

Existing automations kept separate: the RAMSES gateway down/restart/reconnect alerts and the tundish drip/discharge alerts.

## Lessons from commissioning

- **Use `heat_demand`, not `relay_demand`, for the hot water zones.** Mid-reheat, both cylinders showed heat demand 100% and relay demand 0%; relay demand wandered (58, 42, 29 … %) with no reheat at all. Two false "reheat finished short" alerts came from the wrong sensor.
- **Check the notify action name:** the phone's action is `notify.mobile_app_<device>`; a guessed name made every alert fail until corrected (HA raises a repair per automation).
- **A time trigger fires only if HA is running at that minute:** the first digest was missed because HA was restarting at 21:30. *Run actions* confirmed the notification path.
- **RAMSES values can lag:** a hub showed hot water off in its app ~8 min before HA saw it (gateway position), so short-persistence alerts on RAMSES values can be late or spurious until the gateway moves. The opto inputs, once live, give wired signals for the hot water alerts.
- **Several restarts in a day** can lock the Evohome cloud integration out (login limits); prefer reloads where they suffice.
