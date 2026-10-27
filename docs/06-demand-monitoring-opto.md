# 06 · Demand Monitoring: BDR91 and Boiler Switched Lives via Opto-Isolation

[← Back to README](../README.md)

## What's monitored

| Input | Source (230 V) | Meaning |
|---|---|---|
| Boiler demand | Boiler switched-live terminal | The boiler is being called (by any zone) |
| Radiator heating demand | Radiator BDR91 output | Upstairs radiator controller calling |
| UFH demand | UFH BDR91 output | Underfloor controller calling |
| Cylinder left demand | Left cylinder BDR91 | DHW reheat, left |
| Cylinder right demand | Right cylinder BDR91 | DHW reheat, right |

## Circuit
- **Module:** Hailege **8-channel AC 220 V optocoupler** (AC detect, selectable 3-5 V or 24 V logic level). **5 channels used, 3 spare.**
- Each 230 V input sits in parallel with the switched live it watches (L input, N common).
- ⚠️ **Power the module's logic side from 3.3 V, not 5 V.** Its outputs are pulled up to its own VCC, so at 5 V they would swing to 5 V into ESP32 pins that aren't 5 V-tolerant. The module supports 3-5 V logic, so 3.3 V keeps the outputs safe. (This supersedes the earlier "VCC on 5 V" note.)
- Outputs go to the ESP32 with internal pull-ups and 100 ms on/off debounce. These modules normally pull the output **low when AC is present**, so `inverted: true` is expected. Confirm on each channel.
- **Spare channels (3):** candidates are the cylinder high-limit thermostat states (to support the open safety check) and a boiler-lockout/fault signal if one is available.
- **Galvanic isolation** keeps mains off the ESP32 entirely.
- The output polarity (`inverted:`) is **unconfirmed**. Test each channel against a real demand event and flip it if needed.

## Safety
- Mains wiring in an enclosed, fused junction box, with the inputs taken from the existing BDR91 junction box. **Isolate before working.**
- Label the module's mains side, and keep low-voltage wiring segregated.

## What it enables
- **Demand vs. boiler state:** combined with the current clamp, it detects "firing without a call", short-cycling and overrun behaviour.
- **Per-zone demand history:** which controller and cylinder drives boiler run time (feeds the energy dashboard and optimum-start work).
- **Cross-check against RAMSES-II:** physical relay outputs compared with the radio-reported heat demand.
