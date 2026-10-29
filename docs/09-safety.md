# 09 · Safety

[← Back to README](../README.md)

- **Mains:** opto inputs and current clamps are on 230 V circuits. Isolate at the consumer unit or spur, prove dead, and keep the enclosures closed. Current clamps are non-invasive but still sit inside mains enclosures.
- **No gas work.** Nothing here touches the gas train. OpenTherm connects to low-voltage terminals only. The boiler's own safety limits stay in force.
- **Unvented cylinders:** expansion vessels, relief valves and pressure-reducing valves are **safety devices**. Their replacement is plumber work by a competent (G3-qualified) installer. The high-limit cut-out must be wired in series with each cylinder's zone valve: **verified on both cylinders (29 Oct 2026)**.
- **Pressure fittings:** transducers go on the right side of the reducing valve and are rated for the pressure (150 psi on the mains side, 5 bar on the primary).
- **Monitoring only:** apart from the planned OpenTherm stage (with a fail-safe interlock), nothing in this repo commands the plant.
- **Isolation points:** the junction box, timer and BDR91s are all on the **Boiler B6 30 mA RCBO**. Each cylinder's wiring panel also carries the **immersion supply** from the **Water heater B16 30 mA RCBO**: isolate both before opening a cylinder panel.
- **Induced voltage:** long parallel runs can show tens of volts on dead conductors with a high-impedance meter. Cross-check (timer and relays dark) rather than relying on one reading.
- **Shared enclosures:** where 230 V and logic wiring share the opto enclosure, the logic cable is mains-rated and segregated by a barrier.
