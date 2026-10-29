# 08 · Commissioning Tracker (WIP)

[← Back to README](../README.md)

| # | Item | Physical | ESPHome | HA (dashboard / alerts) | Calibrated | Notes |
|---|---|---|---|---|---|---|
| 1 | Boiler pressure transducer | ✅ Installed | ✅ | ⏳ | ⏳ Offset vs mechanical gauge; span at next top-up | Noise fix + baseline stats + leak diagnosis next |
| 2 | Boiler flow/return NTCs | ✅ Installed | ✅ | ⏳ | ⏳ | **Noisy**: 100 nF, cable, filters (doc 02) |
| 3 | 10k/20k divider rework | ⏳ Resistors in hand | ⏳ Proposed YAML | - | - | Frees GPIO2 and GPIO42 |
| 4 | Boiler current clamp | ⏳ To fit (permanent live) | ✅ | ⏳ | ⏳ | Turns for resolution; band from real data |
| 5 | Opto board (Hailege 8-ch, 4 used) | ⏳ Materials in hand; own enclosure | ⏳ Rename entities to the new signals | ⏳ | - | **3.3 V logic**; test `inverted:` per channel ([doc 11](11-opto-board-installation.md)) |
| 6 | Cylinder hot-outlet NTCs (×2) | ⏳ To fit and lag | ⏳ Proposed YAML | ⏳ | ⏳ | Legionella and reheat monitoring |
| 7 | Cylinder inlet pressures (×2) | ⏳ With plumber | ⏳ Proposed YAML | ⏳ | ⏳ | Expansion-vessel health |
| 8 | Expansion vessels + valves | ⏳ Plumber | - | - | - | Same visit as #7 |
| 9 | Tundish sensors (×2) | ⏳ To fit | ✅ | ⏳ | - | Pulsed plates, event counter |
| 10 | High-limit cut-out wiring check | ✅ Verified 29 Oct 2026 | - | - | - | In series with both valve motors |
| 11 | Slow-leak diagnosis | ⏳ Baseline ≈0.035 bar/day | - | ⏳ Decay template | - | Doc 04 plan |
| 12 | Understairs board (UFH pump, cooker, UFH temps) | ⏳ Clamps to fit at CU; probes to place | ✅ Flashed | ⏳ | ⏳ | Floating readings seen with nothing connected; add guards (doc 10) |
| 14 | UFH manifold pressure (proposed) | ⏳ | ⏳ | ⏳ | ⏳ | Split-system leak isolation |
| 13 | OpenTherm node (D1 mini + DIYLESS) + PID | ⏳ D1 mini arrived, orientation proven, soldering pending; enclosure to adapt; changeover relays | ⏳ Skeleton | ⏳ | - | After the monitoring baseline |
