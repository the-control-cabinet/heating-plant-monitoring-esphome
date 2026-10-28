# Changelog

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
