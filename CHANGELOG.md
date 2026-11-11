# Changelog

## [0.9.0] - 2026-11-11 (evening)
- New doc 15 and config/homeassistant/packages/heating_plant_alerts.yaml: 23 alerts with commissioning gates, FDD mapping and lessons (heat demand, not relay demand, for hot water; notify action name; RAMSES lag); replaces plant-alerts.example.yaml. ESP32 chip temperature sensor added.
- Doc 05: plumber visit (24 L vessels at 3.5 bar, gauges between PRV and vessel), a false 5 bar from a loose divider leg, PRVs settling at ~2.5 bar, the vessels' knee and 3.8 bar peak, tundish water test and lingering water.
- Left/right corrections: inlet gauges (IO1 left, IO2 right) and outlet NTCs (IO9 left, IO8 right), verified by a draw; YAML, I/O schedule, pin table and schematic updated.
- Doc 14 and the hot water package v3: cold feed helper (14 °C), per-cylinder draw capture from each outlet's own cooling, stratification from the top used, the low probe pocket assessed, limits and next steps. New hot water and boiler plant cards.
- Tracker and README status updated.
- Alert "reheat finished below 55 °C" replaced by "reheat cut short (window closed)": bottom probe vs the hub's setpoint, 30 min after the reheat ends (the outlet NTC lags at rest).
- Graphs: PRV settle (flow meter at 18:31), the vessel's knee during the reheat, the inlet dip that identified the left draw, hot water cards v3; PRV photo.
- Photos: new vessels and their label (factory 2.7 bar, maximum 3.5 bar gas charge), inlet gauges and gauge box, tundish plates in place, the opto enclosure installed.

## [0.8.0] - 2026-11-11
- Off-board rework of the control-room board: pressure dividers and filters moved into a junction box at each gauge; bus strip (5 V / GND); NTC resistors bridged between neighbouring terminals with IO10 as a 3V3 post; clamp bias on its own strip in the standard topology (doc 13).
- New doc 12: full as-built schematic (SVG), pin table and power-up checks; new opto enclosure schematic (doc 11 §5).
- Faults found: clamp cable screen joined to the white conductor (shorted the new bias node; screen insulated); flow/return swapped in re-wiring (YAML corrected); a meter-probe slip onto the neighbouring 1.65 V terminal.
- Pins: boiler pressure → GPIO6, right inlet → GPIO1, left inlet GPIO2; tundish sense pins swapped to match the re-terminated plates; both inlet gauges zeroed (0.487 / 0.482 V).
- New doc 14: cylinder stratification, a "hot water available" estimate (HA package and card), CS92 paste, Centre Store settings (3.5 bar PRV and pre-charge, 6 bar ERV).
- NTC meter checks (IO4/5/8/9 within 0.6 °C of HA); YAML, I/O schedule, tracker and README updated; photos.

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
