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
| Boiler | Short cycling | > 6 starts (Burner On) in the last hour, repeat after 1 h; message gives flow − return at the start, what's calling and a verdict | F1/F17 |
| Boiler | Flow above 80 °C | 2 min | - |
| Boiler | Pressure low / high / sensor | < 0.8 bar 10 min; > 2.5 bar 5 min; pin < 0.2 V | F20 |
| Boiler | Pressure falling | 24 h change < −0.1 bar, checked cold at 05:00 (statistics `change`) | F5 |
| Boiler | Firing without a call | 2 min (opto) | F2 |
| Boiler | Called but not firing (lockout?) | IN1 on, boiler off/idle 15 min (opto) | - |
| Hot water | Called but boiler not firing | Heat demand > 0 and boiler off/idle 15 min | F18 |
| Hot water | Reheat over 90 minutes | Heat demand 90 min | F9 |
| Hot water | Reheat cut short (window closed) | Bottom probe > 4 K below the hub's setpoint, 30 min after heat demand drops | - |
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
| Zones | Evohome hub fault | Any fault a hub reports through the cloud integration (relay lost, battery, sensor); one message when the list changes, one when it clears | F10 |
| Digest | Daily heating digest | 21:30: starts, firing hours, cylinder tops, tundish events, pressures when enabled | - |

Existing automations kept separate: the RAMSES gateway down/restart/reconnect alerts and the tundish drip/discharge alerts.

## Lessons from commissioning

- **Use `heat_demand`, not `relay_demand`, for the hot water zones.** Mid-reheat, both cylinders showed heat demand 100% and relay demand 0%; relay demand wandered (58, 42, 29 … %) with no reheat at all. Two false "reheat finished short" alerts came from the wrong sensor.
- **Check the notify action name:** the phone's action is `notify.mobile_app_<device>`; a guessed name made every alert fail until corrected (HA raises a repair per automation).
- **Check against the right sensor:** the first "reheat finished short" version used the outlet NTC, which lags at rest (51-52 °C with the cylinder at 57-60 °C), so it fired after every reheat. It now uses the bottom probe (the hub's own reading) against the hub's setpoint, which only trips when a window closes first.
- **A time trigger fires only if HA is running at that minute:** the first digest was missed because HA was restarting at 21:30. *Run actions* confirmed the notification path.
- **RAMSES values can lag:** a hub showed hot water off in its app ~8 min before HA saw it (gateway position), so short-persistence alerts on RAMSES values can be late or spurious until the gateway moves. The opto inputs, once live, give wired signals for the hot water alerts.
- **Several restarts in a day** can lock the Evohome cloud integration out (login limits); prefer reloads where they suffice.


## Changes 12-16 Nov 2026
- **Reheat cut short (window closed):** bottom probe vs setpoint, 30 min after the reheat ends (the outlet-based version was false after every reheat).
- **Hot water alerts on the relays:** not-firing, reheat > 1:30, reheat cut short and timer-blocking now use each hot water BDR91's own state (`binary_sensor.bdr_13_036609_active` right, `binary_sensor.bdr_13_073145_active` left), because the RAMSES heat demand for one cylinder stuck at 100 % for 11 h. They move to the opto inputs at the junction-box rewire, with RAMSES as a cross-check.
- **Failed ignitions:** counted only when no burn follows within 3 minutes; the alert was then disabled (15 Nov) because the clamp can't separate low-fire burning from the pump ([doc 16](16-boiler-states-short-cycling-and-v3.md)); replaced by v3's lockout check.
- **Weekly 60 °C:** now on the CS92 probes (the hubs' own control sensors), 0.5 °C allowance; both hubs set to 60 °C on 16 Nov.
- **New: cylinder inlet overnight floor drift** ([doc 17](17-cylinder-inlets-height-offset-tests-and-trend.md)).

## Changes 16-18 Nov 2026

- **Boiler states v3** ([doc 16](16-boiler-states-short-cycling-and-v3.md)): starts today, firing time and starts in the last hour now count **Boiler Burner On** ([`boiler_kpis.yaml`](../config/homeassistant/packages/boiler_kpis.yaml)); the lockout and hot-water-not-firing checks use "burner off"; the failed-ignition counters copy the ESP32's own count (lit by the fan jump, no flow rise within 2 minutes). v2 figures before 17 Nov are not meaningful.
- **Opto alerts switched on** (17 Nov) after commissioning.
- **"Boiler called, flow cold (lockout?)":** IN1 on for 15 minutes with the boiler flow below 35 °C throughout; the four relays are the fallback if IN1 is unavailable. Logbook line + phone + a daily counter in the digest. Its first event (17 Nov 16:50-21:11) was the junction box being isolated with the UFH relay still commanded on: correct, and the reason the check needs a wired call signal.
- **Pressure peak** (new package `boiler_pressure_peak.yaml`) and the **robust cold minimum** ([doc 04](04-pressure-and-leak-diagnosis.md)).
- **Digest additions:** morning UFH shortfall per zone (Family, Dining, Hall: temperature minus setpoint when the morning period ends) and calls without heat today. The shortfall sensors stay empty (not "unknown") outside their window, so reloads no longer log invalid-state errors.
- **RAMSES device health** (not-heard alert) lives in the Evohome repo ([B11](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration/blob/main/docs/B11-rf-health-and-hub-checks.md)).

## Changes 19 Nov 2026

- **Short-cycling wording from the data.** The message used to end "Likely low flow: only the UFH zone open, no bypass" every time; at 15:49 on 19 Nov that was wrong (return 35 °C: the floor was taking plenty of heat). It now gives the flow, return and their difference at the start that triggered it, **what's calling** (opto IN5-IN8, looked up by search so no entity ID is hard-coded), and a verdict: under 5 °C little heat taken (low flow); 5-15 °C load near the boiler's minimum; 15 °C or more not low flow. Example, 19:35: *"difference 0.3 °C. Calling: UFH. Little heat being taken…"* ([doc 18](18-bypass-trials-open-loads.md)).
- **New: Evohome hub faults.** A binary sensor collects every `activeFaults` entry the hubs report through the cloud integration, across all water heater and climate entities, and a phone alert fires whenever that list changes. **Why:** on 19 Nov the left hot water BDR91 was left off its backplate after mounting work (~15:40). The upstairs hub logged *dhw actuator communication lost* at 18:40 when the evening reheat started, but nothing reached the phone; the RAMSES not-heard check only messages at 08:05, and the 21:30 digest showed the left cylinder at 39 %. With this alert the fault arrives within one cloud update (~5 min). First live test: the "all cleared" message arrived after the relay was refitted at 22:13.
- **Lesson:** a device that disappears is best caught by the controller that depends on it. The hub knew within 10 minutes of needing the relay; the radio-silence check needed 3 hours.

## Changes 20-22 Nov 2026

- **Short cycling, "Calling:" from named signals.** Radiators now come from the RAMSES state of the upstairs heat-demand relay; UFH from IN7; cylinders from IN5/IN6. IN8 is not used: until Stage 2 it is the boiler switched live from any circuit ([doc 16 §11](16-boiler-states-short-cycling-and-v3.md#11-fix-and-findings-20-22-nov)). The boiler-and-demand card marks IN8 with the same footnote.
- **Cold point with water temperature** ([doc 04](04-pressure-and-leak-diagnosis.md#addendum-19-22-nov-2026-cold-point-the-real-leak-rate-top-up-fault-codes)); the digest's pressure line now reads "cold minimum X bar at Y °C water (previous Z at W °C)". A first version used `this` inside action variables, which isn't defined there; the previous value is now worked out inside the state and attribute templates.
- **Evohome hub faults: real changes only.** A reload or restart briefly made the entities unavailable, which sent a spurious "all cleared" (21 Nov 11:43: nothing in either hub's fault log). The alert now fires only when both the old and new states are on/off and the sorted fault lists differ, and it also writes the message to the logbook.
- **Low boiler pressure in practice (22 Nov 14:54):** a long pump run holds the reading ~0.1 bar low, so the 0.8 bar alert arrives on a long burn before the cold minimum gets there. Treated as the top-up signal.
- **Tundish (22 Nov):** two right-side drips; the "running" flag stays on while a drop sits on the plates, so the alert's start time is the event ([doc 05](05-dhw-cylinders-expansion-and-tundish.md#addendum-22-nov-2026-the-right-relief-valve-starts-to-weep)).
