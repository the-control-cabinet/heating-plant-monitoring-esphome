# 10 · Understairs Board: Underfloor Heating Plant and Circuit Monitoring

[← Back to README](../README.md) · Firmware: [`config/esphome/understairs-monitor.yaml`](../config/esphome/understairs-monitor.yaml)

## Why a second board here
The **underfloor heating (UFH) plant** (mixing valve, UFH pump, 6-zone manifold, and the Honeywell **HCC80R** UFH controller with its **HCS80** 3-zone expansion) sits in the understairs closet, as does the **consumer unit**. A board there can monitor:
- the UFH pump and the cooker circuit, with current clamps at the consumer unit (the oven isolator goes straight into a back box, so there's no accessible cable at the oven)
- the UFH flow and return temperatures after the mixing valve
- (proposed) UFH manifold pressure, for leak isolation
- plus BLE proxy and scanner duties for that part of the house

## Status
**Firmware written and flashed. Field sensors not yet connected.**

When the board was first flashed with **nothing attached**, it reported plausible-looking values: about 4.3-4.5 A "cooker", 0.83-0.85 A "pump", and a 68.6/62.9 °C manifold with a 4.3-7.2 K ΔT. Those were **floating-input readings**. Unconnected ADC pins pick up noise, and the ct_clamp and NTC maths turn it into convincing numbers. Lesson: **never trust a reading until the sensor is connected and checked against a known value.** Guards are added below.

## Points

| Point | GPIO | Sensor | Circuit | Status |
|---|---|---|---|---|
| UFH pump current | GPIO10 (cap anchor GPIO12) | **SCT013-005** (5 A = 1 V RMS) | 3V3-10k-GPIO10-10k-GND bias; clamp → 10 µF → bias node | Firmware ✅ · clamp to fit |
| UFH pump running | derived | - | Current > 0.10 A | Firmware ✅ |
| Cooker circuit current | GPIO2 (cap anchor) | **SCT013-030** (30 A = 1 V RMS) | Same bias/coupling network | Firmware ✅ · clamp to fit at the CU |
| Cooker on | derived | - | Current > 1.0 A | Firmware ✅ |
| UFH flow temperature (mixed) | GPIO4 | NTC 10k B3977 strap-on | 3V3-10k-GPIO4-NTC-GND + 100 nF | Firmware ✅ · probe placement to decide |
| UFH return temperature | GPIO5 | NTC 10k B3977 strap-on | as above | Firmware ✅ · probe placement to decide |
| UFH ΔT | derived | - | Flow − return | Firmware ✅ |
| **UFH manifold pressure** (proposed) | **GPIO1** | 0-5 bar 0.5-4.5 V transducer (same type as the boiler's) | Sensor-10k-GPIO1-20k-GND | 📐 Proposed |
| Board health, BLE scanner | - | - | - | ✅ |

Free ADC1 pins after the proposal: GPIO3, 6, 7, 8 and 9.

**Clamp choice:** SCT013-005 for the pump (≈0.3-1 A load needs the 5 A range for resolution); SCT013-030 for the cooker (several amps up to circuit rating). An opto input on the pump was considered. The clamp was chosen because it shows **how hard** the pump is working (speed or mode), not just on/off.

## UFH temperature probe placement
After the mixing valve the pipework is **steel fittings through the pump into the manifold**, not two clean copper runs. Options, best first:
1. **Flow:** on the steel pipe between the pump outlet and the flow rail (or on the flow rail's end cap). **Return:** on the return rail body or its outlet pipe before the mixing valve.
2. Use **thermal paste and lagging over each probe**, so it reads the pipe and not the closet air.
3. **Cross-check** against the mixing valve's set temperature and the manifold's own dial thermometers, if fitted.

The ΔT (flow − return on the mixed side) shows how much heat the floor is taking. Typically it's 5-10 K when zones are calling.

## What the HCC80R can (and can't) provide
- The **HCC80R has no integration ports** to wire into.
- Its data is available **over RAMSES-II** through the ramses_esp gateway ([Evohome repo](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration)): **per-zone heat demand** for the six UFH zones (fixed in ramses_cc 0.60.10), zone temperatures and setpoints, and the controller's demand to the UFH BDR91.
- **The combined picture:** RAMSES zone demand (what's asked for) + pump current (pump running and how hard) + mixed flow/return ΔT (heat delivered) + UFH BDR91 opto (boiler call). That's a complete UFH plant view.
- **Diagnostics it enables:**
  - pump running with no zone demand (overrun, or a stuck relay)
  - zones demanding with no ΔT (closed actuator or airlock)
  - a ΔT that's too high (low flow, so check the manifold flow meters)

## Proposed: manifold pressure for leak isolation
The UFH loop is part of the **same sealed primary system** as the boiler, so in normal running a manifold sensor reads about the same as the boiler sensor (allowing for the height difference). Its value is during the **slow-leak investigation** ([doc 04](04-pressure-and-leak-diagnosis.md)):
- With the **manifold isolated** from the rest of the system, a sensor on the manifold side shows directly whether the **UFH circuit itself** is losing pressure, while the boiler sensor watches everything else.
- Two sensors give a **split-system pressure test without a pressure-test kit**.
- Fit it on a spare manifold port (drain or vent tapping) with the right G1/4 adaptor. The 10k/20k divider puts it on GPIO1.

## Guards against false readings (to add)
- **NTC open-circuit:** if the computed resistance is above ~200 kΩ (probe disconnected), publish *unavailable* rather than a temperature.
- **Clamp noise floor:** treat readings below a measured no-load floor (e.g. < 0.05 A on the 5 A clamp) as 0 A.
- **Plausibility:** flag a UFH flow above 60 °C (UFH should run cooler, typically 35-50 °C after mixing) as a sensor or mixing fault.

## Calibration
- **Clamps:** zero with the circuit off; compare with a clamp meter while running → `calibrate_linear`. A pump draws little, so consider 2-3 turns through the 5 A clamp.
- **NTCs:** two-point check against a reference thermometer, or against the manifold dial thermometers when stable.
- **Pressure:** a single-point offset against a gauge, as in [doc 04](04-pressure-and-leak-diagnosis.md).
