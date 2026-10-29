# Heating Plant Monitoring: Boiler, Cylinders and Safety Devices on ESPHome (WIP)

**Instrumenting a domestic heating plant the way a BMS instruments a plant room. Two ESP32-S3 boards running ESPHome monitor the boiler's flow/return temperatures, system pressure, electrical load and operating state; the boiler call, hot-water timer and cylinder stat signals alongside the Evohome relay states; both unvented hot-water cylinders (outlet temperatures, inlet pressures, tundish discharge); and the underfloor heating plant. A planned OpenTherm stage moves the boiler to modulating, PID-trimmed flow-temperature control, with Evohome as an input rather than the controller.**

[![YouTube](https://img.shields.io/badge/YouTube-The%20Control%20Cabinet-red?logo=youtube)](https://www.youtube.com/channel/UC5Cupmz7vlfcodpCX7k8iuQ)
[![Portfolio](https://img.shields.io/badge/Portfolio-the--control--cabinet-24292f?logo=github)](https://github.com/the-control-cabinet)
![ESPHome](https://img.shields.io/badge/ESPHome-ESP32--S3-000000)
![Signals](https://img.shields.io/badge/Points-26%20across%202%20boards-blue)
![Status](https://img.shields.io/badge/Status-Work%20in%20progress-orange)

> **The short version:** a plant-room points list built from scratch:
> - **temperatures** (NTC dividers)
> - **pressures** (0.5-4.5 V transducers through 10k/20k dividers)
> - **current** (SCT013 clamps with a bias network, banded into boiler states: Off, Idle, Pump, Ignition, Firing Low/High, Overrun, and a "firing without call" alarm)
> - **demand** (230 V opto-isolated boiler switched live, timer output and cylinder stat outputs)
> - **leak detection** (pulsed tundish plates)
>
> **Built so far:** the firmware for both boards, the boiler pressure sensor and the flow/return probes.
>
> **In progress:** noise fixes and calibration, divider simplification, clamp/opto/tundish/cylinder installs, slow-leak diagnosis, and a plumber visit for the expansion vessels and inlet gauges.
>
> **Then:** OpenTherm with a DIYLESS shield and PID logic.

**Portfolio position:** Stage 2.5 · Heating instrumentation and protocol integration. Feeds #4 optimum start, #5 energy, #6 alarms and #8 PID. Related: [Evohome controls & RAMSES-II](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration) · [Mains water metering](https://github.com/the-control-cabinet/mains-water-metering-modbus-rtu) · [HA integration schedule](https://github.com/the-control-cabinet/home-assistant-integration-schedule)

---

## Status at a glance

| Area | Status |
|---|---|
| ESPHome firmware: control room + understairs | ✅ Both written and flashed |
| Boiler pressure transducer | ✅ Installed · ⏳ zero by single-point offset against the mechanical gauge, noise, leak diagnosis (≈0.035 bar/day) |
| Boiler flow/return NTCs | ✅ Installed · ⚠️ noisy, fix defined |
| 10k/20k divider simplification | ⏳ Resistors in hand, YAML proposed |
| Boiler current clamp | ⏳ Fit on the boiler's **permanent live supply**, calibrate, band |
| Opto board (Hailege 8-ch; 4 inputs used, own enclosure) | ⏳ Materials in hand; install with the junction box tidy-up ([doc 11](docs/11-opto-board-installation.md)) |
| Cylinder hot-outlet NTCs ×2 | ⏳ Install, lag, calibrate |
| Cylinder inlet pressures ×2 | ⏳ With the plumber |
| Expansion vessels + relief valves | ⏳ Plumber |
| Tundish sensors ×2 | ⏳ Install |
| Understairs board: UFH pump + cooker clamps, UFH flow/return, (proposed) manifold pressure | ✅ Flashed · ⏳ sensors to connect (floating readings seen, guards to add) |
| OpenTherm + PID | 📐 Designed in its own repo: [opentherm-boiler-control-esphome](https://github.com/the-control-cabinet/opentherm-boiler-control-esphome) · node hardware assembled |

Full tracker: [docs/08](docs/08-commissioning-tracker.md)

## Architecture

```mermaid
flowchart TB
    subgraph PLANT["Plant"]
        B["Ideal Logic+ S30 boiler"]
        C1["Cylinder L (250 L unvented)"]
        C2["Cylinder R (250 L unvented)"]
        UFH["UFH manifold + pump"]
        BDR["4 × BDR91 + boiler switched live"]
    end
    subgraph CR["esp32-control-room-heating"]
        T["Flow/return NTCs"]
        P["Boiler pressure"]
        I["Boiler current (SCT013)"]
        O["4 × opto inputs<br/>(boiler call, timer, 2 × cylinder stat)"]
        DH["Cylinder outlet NTCs ×2<br/>inlet pressures ×2"]
        TD["Tundish plates ×2"]
    end
    subgraph US["understairs-monitor"]
        UP["UFH pump current"]
        UT["UFH flow/return NTCs"]
        CK["Cooker circuit current"]
    end
    B --> T & P & I
    BDR --> O
    C1 & C2 --> DH & TD
    UFH --> UP & UT
    CR & US -->|"ESPHome API (encrypted)"| HA["Home Assistant<br/>dashboards · alerts · history"]
    OT["esp8266-opentherm (planned)<br/>D1 mini + DIYLESS shield"] <-.->|"OpenTherm"| B
    OT <-.->|"API"| HA
    EVO["Evohome via RAMSES-II"] --> HA
```

## Points list

| # | Point | Board / GPIO | Type | Range / scaling | Status |
|---|---|---|---|---|---|
| 1 | Boiler flow temperature | CR GPIO4 | AI | NTC 10k B3977 | Installed (noisy) |
| 2 | Boiler return temperature | CR GPIO5 | AI | NTC 10k B3977 | Installed (noisy) |
| 3 | Boiler ΔT | derived | Calc | Flow − return | Live once 1-2 are clean |
| 4 | Boiler system pressure | CR GPIO1 | AI | 0-5 bar, 0.5-4.5 V, ÷0.667 | Installed (zero to set) |
| 5 | Boiler supply current | CR GPIO3 | AI | SCT013-015, 15 A/V | To install |
| 6 | Boiler electrical state | derived | Multi-state | Current bands + demand | With #5 |
| 7 | Firing without call | derived | Alarm | State vs demand | With #5 and #8 |
| 8 | Boiler call (switched-live joint) | CR GPIO14* | DI | Opto, 230 V | To install |
| 9 | Hot water enabled (timer output) | CR GPIO18* | DI | Opto | To install |
| 10 | Cylinder L stat passing | CR GPIO15 | DI | Opto | To install |
| 11 | Cylinder R stat passing | CR GPIO16 | DI | Opto | To install |
| 12 | Spare | CR GPIO17 | DI | Opto | Spare |
| 13 | Cylinder L hot-outlet temperature | CR GPIO8* | AI | NTC | To install |
| 14 | Cylinder R hot-outlet temperature | CR GPIO9* | AI | NTC | To install |
| 15 | Cylinder L inlet pressure | CR GPIO2* | AI | 0-150 psi (10.34 bar) | With plumber |
| 16 | Cylinder R inlet pressure | CR GPIO10* | AI | 0-150 psi | With plumber |
| 17-18 | Tundish 1 / 2 wet | CR GPIO39 / 20 | DI | Pulsed plates, 2N7000 | To install |
| 19 | Tundish events | derived | Counter | Persistent | With 17-18 |
| 20 | UFH pump current / running | US GPIO10 | AI + derived | SCT013-005 (> 0.10 A = running) | Firmware ✅, clamp to fit |
| 21-22 | UFH flow / return (mixed side) + ΔT | US GPIO4 / 5 | AI | NTC | Firmware ✅, placement to decide |
| 23 | Cooker circuit current / on | US GPIO2 | AI + derived | SCT013-030 (> 1.0 A = on) | Firmware ✅, clamp to fit |
| 24 | UFH manifold pressure | US GPIO1* | AI | 0-5 bar | 📐 Proposed (leak isolation) |
| 25 | UFH zone heat demand ×6 | via RAMSES-II | Network | From the HCC80R | ✅ Live (Evohome repo) |
| 26 | Board health (online, Wi-Fi, uptime) | both | Diagnostic | | Live |

\* proposed allocation after the divider rework ([docs/01](docs/01-hardware-and-io-schedule.md)). CSV: [data/io-schedule.csv](data/io-schedule.csv)

## Key design points

- **Signal conditioning ([docs/02](docs/02-signal-conditioning-and-noise.md)):**
  - NTC dividers from 3V3
  - **10k/20k dividers** bring the 5 V sensors down to ≤3.0 V at the ADC
  - SCT013 clamps on a **1.65 V bias** with a 10 µF coupling capacitor, so both half-cycles stay in range
  - **ADC1 only** for analogue signals, since ADC2 is unusable with Wi-Fi on
- **NTC noise fix:** 100 nF at each ADC pin, twisted/shielded leads away from mains, `samples: 16` + median + moving average, decoupled 3V3, and probes lagged in.
- **Boiler current ([docs/03](docs/03-boiler-current-and-states.md)):** clamp on the **permanent live**, with 3-5 turns for resolution. States are banded from current plus the demand input. Thresholds are set from a week of real data.
- **Slow leak ([docs/04](docs/04-pressure-and-leak-diagnosis.md)):** compare pressure at the same cold condition daily, compute the decay rate, then isolate circuits one at a time. The PRV discharge, auto air vents and joints are checked; the boiler's expansion vessel is already ruled out.
- **Cylinders and tundishes ([docs/05](docs/05-dhw-cylinders-expansion-and-tundish.md)):** the inlet pressure rise during reheat reveals expansion-vessel health. Tundish plates are pulsed (150 ms every 5 s) to limit electrolysis, debounced, and counted.
- **Demand monitoring ([docs/06](docs/06-demand-monitoring-opto.md), [docs/11](docs/11-opto-board-installation.md)):** 230 V opto-isolation of the boiler switched live, the timer output and both cylinders' stat-passing points; relay states come from RAMSES-II.
- **Understairs UFH plant ([docs/10](docs/10-understairs-ufh-and-circuits.md)):** the UFH pump and cooker clamps at the consumer unit, mixed-side flow/return ΔT, HCC80R zone demand via RAMSES-II, and a proposed manifold pressure sensor for split-system leak testing. The firmware is flashed, and a no-sensors-attached test showed floating inputs producing plausible values, a useful lesson.
- **OpenTherm plan ([docs/07](docs/07-opentherm-and-pid-plan.md)):**
  - DIYLESS shield as the OpenTherm master, on its **own ESP8266 D1 mini node** (control kept separate from monitoring)
  - weather compensation + RAMSES-II demand trim + PID with anti-windup and minimum on/off times
  - DHW priority
  - an **interlocked relay changeover** back to Evohome control (force-guided contacts)

## Configuration files

| File | Content |
|---|---|
| [`config/esphome/esp32-control-room-heating.yaml`](config/esphome/esp32-control-room-heating.yaml) | Current control-room firmware: NTCs, pressure, clamp + state machine, opto inputs, tundishes |
| [`config/esphome/esp32-control-room-heating-proposed.yaml`](config/esphome/esp32-control-room-heating-proposed.yaml) | Proposed: 10k/20k dividers, noise filters, cylinder NTCs and pressures, opto pin moves |
| [`config/esphome/understairs-monitor.yaml`](config/esphome/understairs-monitor.yaml) | UFH pump and cooker clamps, UFH manifold NTCs |
| [`config/homeassistant/plant-alerts.example.yaml`](config/homeassistant/plant-alerts.example.yaml) | Low pressure, tundish discharge, firing without call, cylinder overpressure |
| [`config/homeassistant/pressure-statistics.example.yaml`](config/homeassistant/pressure-statistics.example.yaml) | Noise floor (1 h std dev), mean, 7-day change |

All credentials are `!secret` references.

## Documents

| Doc | Covers |
|---|---|
| [01 Hardware and I/O schedule](docs/01-hardware-and-io-schedule.md) | Boards, pin rules, current vs proposed allocation, sensors |
| [02 Signal conditioning and noise](docs/02-signal-conditioning-and-noise.md) | Circuits, NTC noise fixes, calibration |
| [03 Boiler current and states](docs/03-boiler-current-and-states.md) | Clamp placement, turns, state banding, commissioning |
| [04 Pressure and leak diagnosis](docs/04-pressure-and-leak-diagnosis.md) | In-place zero/span (no draining), baseline stats, noise, leak-finding plan |
| [05 DHW cylinders, expansion and tundish](docs/05-dhw-cylinders-expansion-and-tundish.md) | Outlet temperatures, inlet pressures, plumber work, tundish sensors |
| [06 Demand monitoring (opto)](docs/06-demand-monitoring-opto.md) | BDR91 and switched-live inputs |
| [07 OpenTherm and PID: summary](docs/07-opentherm-and-pid-plan.md) | Summary, roadmap and link to the control repo |
| [08 Commissioning tracker](docs/08-commissioning-tracker.md) | Item-by-item status |
| [09 Safety](docs/09-safety.md) | Mains, gas, unvented cylinders, pressure fittings |
| [11 Opto board installation](docs/11-opto-board-installation.md) | Tap points from the junction box survey, enclosure, wiring, commissioning tests |
| [10 Understairs: UFH plant and circuits](docs/10-understairs-ufh-and-circuits.md) | UFH pump and cooker clamps, UFH temperatures and placement, HCC80R data via RAMSES-II, manifold pressure for leak isolation, floating-input lesson |

## Skills demonstrated

| Skill | Evidence |
|---|---|
| Plant-room points list | 26 points across AI, DI, derived, network and alarm types |
| Analogue signal conditioning | NTC dividers, 5 V→3.3 V dividers, CT bias and coupling, filtering |
| Current-based plant state detection | Boiler state machine from load current + demand |
| Pressure diagnostics | Leak decay-rate method; expansion-vessel health from inlet pressure |
| Life-safety-adjacent monitoring | Tundish discharge detection; unvented-cylinder safety checks |
| Isolation and segregation | 230 V opto inputs; mains vs low-voltage separation |
| Controls design | OpenTherm master with PID, weather compensation, fail-safe interlock |

📺 [The Control Cabinet on YouTube](https://www.youtube.com/channel/UC5Cupmz7vlfcodpCX7k8iuQ)

*Built and documented by James · part of [The Control Cabinet BMS portfolio](https://github.com/the-control-cabinet). MIT Licence.*
