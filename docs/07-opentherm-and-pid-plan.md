# 07 · OpenTherm and PID: Summary and Roadmap

[← Back to README](../README.md) · **Full design:** [opentherm-boiler-control-esphome](https://github.com/the-control-cabinet/opentherm-boiler-control-esphome)

The control stage now has its **own repo**. This page keeps the summary and the link from the monitoring side.

## Summary
- **Goal:** move the Ideal Logic+ S30 from on/off switching (BDR91 switched lives) to **modulating flow-temperature control over OpenTherm**: weather compensation + PID trim, DHW priority, anti-cycling.
- **Constraint:** Honeywell's OpenTherm bridge serves **one** Evohome controller, and this house has **two**. A passive OpenTherm "listener" can't work, because with BDR91 switching there's no OpenTherm traffic.
- **Design:** a dedicated **ESP8266 D1 mini + DIYLESS master shield** node owns the boiler. Both Evohome systems keep zone control, and their demand becomes an input via:
  - **this repo's opto inputs** (hard-wired BDR91 states),
  - **RAMSES-II** (per-zone heat demand),
  - the **cloud** (back-up).
- **Fail-safe:** an interlocked changeover between OpenTherm and the original BDR91 switched lives (relay de-energised = Evohome on/off).

## What this monitoring repo provides to the control stage
| Signal | Source here |
|---|---|
| Every BDR91 demand (radiators, UFH, cylinder L/R) | Opto inputs, control-room board |
| Flow/return temperatures (independent check of OpenTherm values) | NTCs, control-room board |
| Boiler electrical state (cycle counting baseline) | Current clamp, control-room board |
| System pressure | Transducer (OpenTherm may not report it) |
| UFH plant state | Understairs board |

## Delivery sequence

| Step | What | Repo |
|---|---|---|
| **A** | Plant monitoring install + on/off **baseline** (2-4 weeks) | [Heating plant monitoring](https://github.com/the-control-cabinet/heating-plant-monitoring-esphome) |
| **B** | **Supervisory layer:** HA + Node-RED platform, command authority, fail-safe patterns | [Supervisory layer](https://github.com/the-control-cabinet/ha-node-red-supervisory-layer) |
| **C** | **Optimum start/stop** on today's on/off control (first function on B) | [Optimum start/stop](https://github.com/the-control-cabinet/optimum-start-stop-supervisory) |
| **D** *(in parallel with A-C)* | **PID rig exercise** (+ interlocks), and the OpenTherm node **bench test** | [PID rig](https://github.com/the-control-cabinet/pid-anti-hunt-control-rig) |
| **E** | **OpenTherm on the boiler:** read-only → weather comp → PID trim → preheat boost linked to C | [OpenTherm control](https://github.com/the-control-cabinet/opentherm-boiler-control-esphome) |
| **F** | Before/after report: baseline → C → E | [Energy dashboard](https://github.com/the-control-cabinet/home-energy-dashboard) |

This repo is step **A**: its baseline is what C and E are measured against.

## Roadmap
- [x] Design record (see the control repo)
- [x] Node hardware assembled: shield orientation proven from the PCB tracks
- [ ] Monitoring baseline (on/off) captured: **this repo's commissioning first**
- [ ] Boiler connection + changeover; OpenTherm read-only session
- [ ] Control live, PID tuning, before/after report (control repo docs 08-10)
