# 06 · Demand Monitoring: BDR91 and Boiler Switched Lives via Opto-Isolation

[← Back to README](../README.md)

## What's monitored (revised after the Oct 2026 survey)

| Input | Source (230 V) | Meaning |
|---|---|---|
| Boiler call | Boiler switched-live joint | The boiler is being called (by any demand) |
| Hot water enabled | 6-way pos 3, TS715Si output | The timer is enabling both hot-water relays |
| Cylinder L stat passing | 6-way pos 2 | Left relay calling and its stat and cut-out closed |
| Cylinder R stat passing | 6-way pos 1 | Right relay calling and its stat and cut-out closed |

The earlier plan tapped all four BDR91 outputs. RAMSES-II already reports those relay states, and the survey showed the radiator relay output is joined into the boiler switched live (so it can't be read on its own). The four inputs above are the ones the radio can't provide. Tap points, enclosure and wiring: [doc 11](11-opto-board-installation.md).

## Circuit
- **Module:** Hailege **8-channel AC 220 V optocoupler** (AC detect, selectable 3-5 V or 24 V logic level). **4 channels used, 4 spare.**
- Each 230 V input sits in parallel with the switched live it watches (L input, N common).
- ⚠️ **Power the module's logic side from 3.3 V, not 5 V.** Its outputs are pulled up to its own VCC, so at 5 V they would swing to 5 V into ESP32 pins that aren't 5 V-tolerant. The module supports 3-5 V logic, so 3.3 V keeps the outputs safe. (This supersedes the earlier "VCC on 5 V" note.)
- Outputs go to the ESP32 with internal pull-ups and 100 ms on/off debounce. These modules normally pull the output **low when AC is present**, so `inverted: true` is expected. Confirm on each channel.
- **Spare channels (4):** candidates are the UFH valve drive (6-way pos 4) and relay outputs for a physical cross-check of RAMSES-II.
- **Galvanic isolation** keeps mains off the ESP32 entirely.
- The output polarity (`inverted:`) is **unconfirmed**. Test each channel against a real demand event and flip it if needed.

## Safety
- The board sits in **its own ABS enclosure** beside the junction box, with tails in 3095Y flex from Wago-rebuilt joints. **Isolate at the Boiler B6 RCBO before working.**
- Label the module's mains side, and keep low-voltage wiring segregated.

## What it enables
- **Demand vs. boiler state:** combined with the current clamp, it detects "firing without a call", short-cycling and overrun behaviour.
- **Per-zone demand history:** which controller and cylinder drives boiler run time (feeds the energy dashboard and optimum-start work).
- **Cylinder diagnostics:** RAMSES relay calling while the stat-passing input is off means the stat is satisfied or the **cut-out has tripped** (FDD rule F15).
- **Timer watchdog:** hot water disabled while Evohome calls for DHW (FDD rule F16).
