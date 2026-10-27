# 05 · Hot-Water Cylinders: Outlet Temperatures, Inlet Pressures, Expansion and Tundishes

[← Back to README](../README.md)

Two 250 L unvented indirect cylinders, each heated by the boiler through a BDR91-switched zone valve (see the [Evohome repo](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration)).

## Hot-outlet temperatures (to install)
- One 10k B3977 strap-on NTC on each cylinder's **hot outlet pipe**, near the cylinder, with paste, a strap and **lagging over the probe**.
- Uses: delivered hot-water temperature, reheat confirmation, a **Legionella check** (weekly peak ≥ 60 °C), and comparison with the Evohome cylinder probe.
- The same noise fixes and calibration as the boiler NTCs ([02](02-signal-conditioning-and-noise.md)).

## Cold-inlet pressure (to install with the plumber)
- **Ausla 0-150 psi** stainless transducers (G1/4, 5 V supply, 0.5-4.5 V out), one on each cylinder's cold inlet **after the pressure-reducing valve**, fitted while the plumber is on site.
- **What they show:**
  - **Static pressure** = the PRV set point (typically 3 bar).
  - **During reheat, the pressure rises** as the water expands. With a healthy expansion vessel the rise is small.
  - **A steep rise toward the expansion relief valve setting (6 bar here)** means a **failed or flat expansion vessel**, and the tundish will discharge.
  - **Alert thresholds:** warning at **5.0 bar**, critical at **5.5 bar**.
  - **A drop during draws** shows the supply and PRV performance.

## Plumber work (planned, one visit)

| Item | Why |
|---|---|
| Replace both cylinders' **expansion vessels** | Ageing vessels; prevents expansion discharge |
| Replace the **expansion relief / pressure-reducing valves** as needed | Same visit; restores the safety set |
| Fit the two **inlet pressure gauge points** (transducer tees) | Instrumentation at the same time |
| Verify the **high-limit cut-out wiring** (in series with each zone valve) | ⚠️ Open safety check from the Evohome install |

## Tundish drip sensors (to install)

**Design:**
- Gold-plated contact plates in each tundish's discharge path.
- **Plate power is pulsed:** GPIO21 switches 3V3 to both plates for **150 ms every 5 s**. Pulsing minimises electrolysis and plate corrosion.
- Water bridging a plate turns on its **2N7000 MOSFET**, which pulls the sense pin low (GPIO39, GPIO20; pull-up, inverted).
- **Debounce:** wet only after **2 consecutive** wet samples. Each dry → wet transition increments a **persistent event counter**.
- **In HA:** Tundish 1 Wet, Tundish 2 Wet, Tundish Any Wet, the event counts, and a reset button.

**Why it matters:** a tundish discharge is the visible symptom of an unvented-cylinder safety device operating: a failed expansion vessel, an overpressure, or an overheat. It should never be ignored.

## Alerts (examples in `config/homeassistant/`)
- Tundish wet → immediate phone alert.
- Cylinder inlet pressure above a threshold → expansion/relief check.
- Hot outlet never reaches 60 °C in 7 days → Legionella reminder.
