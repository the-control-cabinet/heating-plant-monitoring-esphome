# Changelog

## [0.7.0] - 2026-11-06
- Doc 02: flow/return noise traced to 330 kΩ top resistors (should be 3.3 kΩ), found by a powered voltage test; before/after graphs; NTC circuit corrected to 3.3 kΩ; standing-offset check (no offset applied yet).
- Doc 04: ADC calibrated against a meter; pressure calibrated to the boiler gauge (3 points, linear fit); noise diagnosed as bursts on the sensor's 5 V supply; fast (diagnostic) and 1-minute main pressure sensors; graphs.
- Doc 05: left outlet NTC installed and the first reheat (~12 kW, ~1 h); tundish sensors as built, commissioning faults (missing GND, swapped cables), droplet issue, two-sensitivity wet/running sensing with test switches; in-service detection of the weeping relief valve; photos.
- Doc 01: as-built allocation, posts, ADC1 budget with the two inlet pressure sensors, board health.
- Control-room YAML updated to the flashed version (3.3k NTCs, outlet NTCs, pressure calibration and filtering, tundish wet/running and test switches); I/O schedule, tracker and README status updated.

## [0.6.0] - 2026-11-02
- Doc 11: opto board re-scoped to all eight inputs at the planned Wagos (W1-W8); IN8 (radiator relay) waits for the TF/MF re-wire after the bypass; radiator demand inferred as IN1 on with IN5-IN7 off until then; interposing relay considered and rejected.
- Printed tray v2 (STL + OpenSCAD) in hardware/opto-tray, with the v1 lessons; enclosure neutrals now three linked 221-415s in a 4-slot mount.
- Control-room YAML: median + moving-average filters on the flow and return NTCs (100 nF capacitors still to fit).
- I/O schedule: IN1-IN8 rows.

## [0.5.1] - 2026-10-31
- Doc 11: enclosure internals (neutral distribution and earth Wagos in a printed mount).

## [0.5.0] - 2026-10-29
- Doc 11: opto board installation from the junction box survey (four tap points, own clear-lid ABS enclosure, 3095Y tails, Wago taps, segregation, commissioning tests).
- Opto inputs re-scoped: boiler call, timer output, cylinder L/R stat passing (relay states from RAMSES-II); I/O schedule, README points list and doc 06 updated. YAML entity names to follow at install.
- Safety: cylinder high-limit cut-outs verified in series; isolation points (B6 boiler, B16 water heater) and induced-voltage note added.

## [0.4.2] - 2026-10-28
- Published YAMLs brought in line with the live boards (unused MQTT removed, INFO logging, debug sensors); OpenTherm node status corrected (orientation proven, soldering pending).

## [0.4.1] - 2026-10-28
- Doc 07: delivery sequence A-F with links to the supervisory layer, optimum start/stop, PID rig and OpenTherm repos.

## [0.4.0] - 2026-10-27
- OpenTherm/PID design moved to its own repo (opentherm-boiler-control-esphome); doc 07 now a summary, roadmap and link; README status updated.

## [0.3.2] - 2026-10-27
- OpenTherm host moved to a dedicated diymore ESP8266 D1 mini (control-room ESP32-S3 is full; control kept separate from monitoring); D2/D1 shield pins; 3D-printed enclosure; config skeleton updated.

## [0.3.1] - 2026-10-27
- OpenTherm decision history (vacant OT terminals; no traffic to listen to with BDR91s; a master shield is a thermostat; risk of fighting the switched live; single-controller bridge limit; chosen design), hardware/wiring, ESPHome config skeleton and verification points.

## [0.3.0] - 2026-10-27
- Understairs board fully documented (doc 10): status corrected to flashed with sensors to connect; UFH pump and cooker clamps; mixed-side probe placement; HCC80R data via RAMSES-II; proposed manifold pressure for split-system leak isolation; floating-input lesson and guards. Points list now 26.

## [0.2.1] - 2026-10-27
- Pressure calibration in place: single-point offset against the mechanical gauge (known 0.8 V/bar slope), span check at top-up, baseline statistics; no draining. Statistics sensor example added.

## [0.2.0] - 2026-10-27
- Clamp on the boiler permanent live (decision); Hailege 8-ch opto on 3.3 V logic; pressure-zero procedure using the filling loop and boiler/filter isolation; Ausla 0-150 psi cylinder sensors with 5.0/5.5 bar alerts (6 bar relief); leak baseline ≈0.035 bar/day; OpenTherm design rationale (single-controller bridge limit, switched lives disconnected, interlocked changeover); R9H removed (researched, not bought).

## [0.1.0] - 2026-10-27 (draft, work in progress)
- Points list (24), I/O schedule (current and proposed), signal conditioning and noise fixes, boiler current state banding, pressure and leak-diagnosis plan, cylinders/expansion/tundish, opto demand monitoring, OpenTherm + PID plan, commissioning tracker, safety.
- Current and proposed ESPHome YAML (secrets as !secret); HA alert examples.
