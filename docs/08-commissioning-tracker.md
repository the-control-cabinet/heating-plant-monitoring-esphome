# 08 · Commissioning Tracker (WIP)

[← Back to README](../README.md)

| # | Item | Physical | ESPHome | HA (dashboard / alerts) | Calibrated | Notes |
|---|---|---|---|---|---|---|
| 1 | Boiler pressure transducer | ✅ Installed | ✅ Fast + 1-min main | ✅ | ✅ 3 points vs gauge (1.0-1.65 bar) · ⏳ zero at drain-down | Noise in bursts from the 5 V supply: 10 µF at sensor next (doc 04) |
| 2 | Boiler flow/return NTCs | ✅ Installed (3.3 kΩ) | ✅ | ✅ | ⏳ Offset recheck after a longer standing period | Noise was a 330 kΩ resistor (fixed 3 Nov); 100 nF still to fit |
| 3 | 10k/20k divider rework | ✅ Done (GPIO42 freed) · ⏳ IO2 post to a Wago | ✅ | - | - | Frees GPIO2 for the left inlet sensor |
| 4 | Boiler current clamp | ⏳ To fit (permanent live) | ✅ | ⏳ | ⏳ | Turns for resolution; band from real data |
| 5 | Opto board (Hailege 8-ch, 4 used) | ⏳ Materials in hand; own enclosure | ⏳ Rename entities to the new signals | ⏳ | - | **3.3 V logic**; test `inverted:` per channel ([doc 11](11-opto-board-installation.md)) |
| 6 | Cylinder hot-outlet NTCs (×2) | ✅ Left · ⏳ right probe to strap on | ✅ | ✅ | ⏳ | First reheat recorded (doc 05) |
| 7 | Cylinder inlet pressures (×2) | ⏳ With plumber | ⏳ Proposed YAML | ⏳ | ⏳ | Expansion-vessel health |
| 8 | Expansion vessels + valves | ⏳ Plumber | - | - | - | Same visit as #7 |
| 9 | Tundish sensors (×2) | ✅ Commissioned 5 Nov | ✅ Wet + running, test switches | ⏳ Alerts | ⏳ Gate-voltage test (left first) | Clean plates, mount steeper, cables in from below |
| 10 | High-limit cut-out wiring check | ✅ Verified 29 Oct 2026 | - | - | - | In series with both valve motors |
| 11 | Slow-leak diagnosis | ⏳ Baseline ≈0.035 bar/day | - | ⏳ Decay template | - | Doc 04 plan |
| 12 | Understairs board (UFH pump, cooker, UFH temps) | ⏳ Clamps to fit at CU; probes to place | ✅ Flashed | ⏳ | ⏳ | Floating readings seen with nothing connected; add guards (doc 10) |
| 14 | UFH manifold pressure (proposed) | ⏳ | ⏳ | ⏳ | ⏳ | Split-system leak isolation |
| 13 | OpenTherm node (D1 mini + DIYLESS) + PID | ⏳ D1 mini arrived, orientation proven, soldering pending; enclosure to adapt; changeover relays | ⏳ Skeleton | ⏳ | - | After the monitoring baseline |
