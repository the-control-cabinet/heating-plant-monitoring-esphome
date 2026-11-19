# Changelog

## [0.12.0] - 2026-11-19
- **Boiler states v3, go-live fixes** (doc 16 §10): the boiler call (IN1) dropping now ends a burn at once (18 Nov 21:22 false Firing Without Call during a 4-minute overrun with the valves shut) and Firing Without Call needs 5 s; the mid-band flow-falling rule also needs flow − return < 12 °C (19 Nov 06:45 false lockout: a cold return made the boiler modulate up). Off gap checked: 86-97 s. 19 Nov: first day with no false alerts.
- **Alerts** (doc 15): short-cycling message built from the data (flow − return at the triggering start, what's calling from IN5-IN8, a verdict); new **Evohome hub faults** sensor and alert (every hub-reported fault from the cloud integration, one message per change), after a hot water relay left off its backplate went unreported for 4 hours.
- **New doc 18:** short cycling: automatic bypass (flow) vs open loads (heat), the TPI floor on starts, flow temperature not a cure, two open-load trials (Lounge UFH loop from 14:41, Landing radiator from ~19:15) with method, excluded windows and the first evening's result (an open UFH loop doesn't stop UFH-only cycling).
- Firmware and alerts package updated to the live versions (flashed 19 Nov 10:24; alerts applied 22:15).
- Tracker and README: latest, status, findings, documents.

## [0.11.0] - 2026-11-18
- **Boiler states v3 live** (doc 16 sections 5-9): two videos of the boiler display as ground truth (radiators only: cut-out at 72-73 °C, fixed ~120 s anti-cycle wait; all zones: one full-fire burn); v2 found inverted; v3 rules (light-off jump, flow slope and flow-return to decide burning, IN1 to split anti-cycle wait from pump overrun), validation and replays 15-18 Nov; Burner On, Last Burn, Last Gap, Failed Ignitions on the board; flow/return/ΔT to HA on 0.5 °C or 30 s. Clamp 2 turns, multiply 7.5; light-off threshold 0.38 → 0.42 A after the turns moved pump-only to 0.38 A. Debug component and heap/loop sensors removed.
- **Opto board installed and commissioned** (doc 11 section 6): cable cores as wired, all 8 inputs proven on and off; IN8 live via W8 built early; opto alerts on.
- **Cylinder inlet gap closed** (doc 17 section 6): height 5.87 m (0.576 bar); mains sensor calibrated (+0.025 bar) and span confirmed overnight; the daytime gap = inlet check valves holding peaks; height and tolerance slider helpers, tolerance 0; left gain 1.028 confirmed.
- **10 µF on every pressure input** (doc 02 addendum), including GPIO6 with GPIO7 held low as the filter ground.
- **Pressure** (doc 04 addendum): new boiler_pressure_peak.yaml; the cold minimum made robust in three steps (15-min median; only while v3 is Off for 20 min; held value so it never reads 0).
- **Alerts** (doc 15): starts/firing time from v3 (new boiler_kpis.yaml), failed ignitions from the board, "boiler called, flow cold" on IN1 with relay fallback, morning UFH shortfall and calls-without-heat digest lines, shortfall sensors empty outside their window.
- Docs 03, 08, 10 (UFH pump mode III, mixing valve 50 °C, manifold gauge, HCC80R broadcast, Lounge loop), 13 (clamp turns, boiler flex earth), 14 (low probe after two showers) updated.
- New card: boiler-and-demand-card.yaml (v3 + relays vs optos). cylinder-inlet-head card updated.
- README: short version, latest, status and findings.

## [0.10.0] - 2026-11-16
- 12-13 Nov detail: docs 02/03/04/05/08/13 addenda (NTC offset, clamp AC check, GPIO6 boiler gauge and gauge boxes, long-term statistics and the daily cold-minimum decay check, inlet span checks with a tyre gauge, ADC-pin filtering lesson, 5 V decoupling, outlet NTC position, mains and inlet-group losses, tundish counter history, GPIO21); hardware/gauge-box; hot water card v4.
- New doc 16: boiler states from the clamp: v2 (15 Nov) and why it fails at low fire (low-fire burning 0.13-0.18 A vs pump overrun 0.30-0.40 A, flow-temperature burn detector as reference, fan spike before only 47 of 152 burns); failed-ignition alert disabled; short cycling with radiators only (~50 s every ~2.6 min); v3 design (flow-temperature burning, clamp for high/low fire, lockout check).
- New doc 17: cylinder inlets: effective height offset 0.37 bar (0.15 bar gap open), why inlets sit at 3.7-3.8 bar after reheats (3.5 bar pre-charge on a ~2.5 bar supply; Boyle's law), kick tests, Test 1 (valid only on a drawn side), inlet group losses and the part-closed isolating valve, the overnight floor-trend alert.
- Doc 14 addendum: hot water estimate v4; card wording; 60 °C on both hubs. Doc 15 addendum: alerts changes 12-16 Nov.
- Packages: heating_plant_alerts.yaml (hot water alerts on BDR91 relay states; failed ignition = no burn within 3 min; weekly 60 °C on the CS92 probes), dhw_hot_water_available.yaml (v4), cylinder_inlet_head.yaml, cylinder_inlet_floor_trend.yaml (new); cylinder inlet card; control-room firmware v2 (boiler gauge GPIO6, left span gain, state v2).
- Valve names written in full throughout (pressure reducing valve, expansion relief valve, boiler pressure relief valve).
- README: status, findings, files and documents.

## [0.9.0] - 2026-11-11 (evening)
- New doc 15 and config/homeassistant/packages/heating_plant_alerts.yaml: 23 alerts with commissioning gates, FDD mapping and lessons (heat demand, not relay demand, for hot water; notify action name; RAMSES lag); replaces plant-alerts.example.yaml. ESP32 chip temperature sensor added.
- Doc 05: plumber visit (24 L vessels at 3.5 bar, gauges between pressure reducing valve and vessel), a false 5 bar from a loose divider leg, pressure reducing valves settling at ~2.5 bar, the vessels' knee and 3.8 bar peak, tundish water test and lingering water.
- Left/right corrections: inlet gauges (IO1 left, IO2 right) and outlet NTCs (IO9 left, IO8 right), verified by a draw; YAML, I/O schedule, pin table and schematic updated.
- Doc 14 and the hot water package v3: cold feed helper (14 °C), per-cylinder draw capture from each outlet's own cooling, stratification from the top used, the low probe pocket assessed, limits and next steps. New hot water and boiler plant cards.
- Tracker and README status updated.
- Alert "reheat finished below 55 °C" replaced by "reheat cut short (window closed)": bottom probe vs the hub's setpoint, 30 min after the reheat ends (the outlet NTC lags at rest).
- Graphs: pressure reducing valve settle (flow meter at 18:31), the vessel's knee during the reheat, the inlet dip that identified the left draw, hot water cards v3; pressure reducing valve photo.
- Photos: new vessels and their label (factory 2.7 bar, maximum 3.5 bar gas charge), inlet gauges and gauge box, tundish plates in place, the opto enclosure installed.

## [0.8.0] - 2026-11-11
- Off-board rework of the control-room board: pressure dividers and filters moved into a junction box at each gauge; bus strip (5 V / GND); NTC resistors bridged between neighbouring terminals with IO10 as a 3V3 post; clamp bias on its own strip in the standard topology (doc 13).
- New doc 12: full as-built schematic (SVG), pin table and power-up checks; new opto enclosure schematic (doc 11 §5).
- Faults found: clamp cable screen joined to the white conductor (shorted the new bias node; screen insulated); flow/return swapped in re-wiring (YAML corrected); a meter-probe slip onto the neighbouring 1.65 V terminal.
- Pins: boiler pressure → GPIO6, right inlet → GPIO1, left inlet GPIO2; tundish sense pins swapped to match the re-terminated plates; both inlet gauges zeroed (0.487 / 0.482 V).
- New doc 14: cylinder stratification, a "hot water available" estimate (HA package and card), CS92 paste, Centre Store settings (3.5 bar pressure reducing valve and pre-charge, 6 bar expansion relief valve).
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
