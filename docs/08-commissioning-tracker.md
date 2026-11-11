# 08 · Commissioning Tracker (WIP)

[← Back to README](../README.md)

| # | Item | Physical | ESPHome | HA (dashboard / alerts) | Calibrated | Notes |
|---|---|---|---|---|---|---|
| 1 | Boiler pressure transducer | ⏳ Gauge box (divider at the sensor) to build; moves to GPIO6 | ✅ Fast + 1-min main | ✅ | ✅ 3 points vs gauge · ⏳ re-check on GPIO6 · zero at drain-down | 470 µF + 100 nF on the 5 V bus to fit (doc 13) |
| 2 | Boiler flow/return NTCs | ✅ Installed; 3.3k bridged to 3V3 (doc 13) | ✅ Flow GPIO4 / return GPIO5 (swapped 10 Nov) | ✅ | ✅ Meter check 11 Nov (0.6 / 0.2 °C) · ⏳ standing offset | |
| 3 | Off-board rework | ✅ Gauge-box dividers, bus strip, IO10 post, clamp strip (10-11 Nov) | ✅ | - | - | [doc 12](12-control-room-wiring-schematic.md), [doc 13](13-off-board-wiring.md) |
| 4 | Boiler current clamp | ✅ Fitted (1 pass); standard bias topology; screen fault fixed | ✅ States retuned 7 Nov | ✅ Plant card + KPIs | ✅ ±3% vs meter · ⏳ 3 turns at the rewire | Overrun/Pre-Purge need IN1 |
| 5 | Opto board (Hailege 8-ch, 8 used) | ✅ Enclosure built, logic side at 3.3 V · ⏳ mains side at the rewire | ✅ IN1-IN8 | ⏳ | - | Test each input against a real demand |
| 6 | Cylinder hot-outlet NTCs (×2) | ✅ Both strapped, pasted, lagged | ✅ Left IO9 / right IO8 (swapped 11 Nov) | ✅ Hot water card v3 (own-draw capture) | ✅ Meter check · ✅ left/right verified by a draw · ⏳ thermometer comparison | Doc 14 |
| 7 | Cylinder inlet pressures (×2) | ✅ Both live; gauges fitted between PRV and vessel · ⏳ close both boxes after tug-tests | ✅ Left GPIO1 / right GPIO2 (swapped 11 Nov) | ✅ Alerts on | ✅ Zero · ✅ static vs mains (2.9 / 2.98 bar) · ⏳ tyre-gauge span at ~4 bar | A loose 20k gave a false 5 bar (doc 05) |
| 8 | Expansion vessels + valves | ✅ Flomasta 24 L at 3.5 bar (11 Nov); ERVs kept | - | ✅ Inlet alerts | - | PRVs settle ~2.5 bar (pre-set 3.5): strainers/cartridges at the next visit; then match the pre-charge |
| 9 | Tundish sensors (×2) | ✅ Re-terminated 10 Nov · ⏳ holder drainage | ✅ Wet + running | ✅ Wet alert | ✅ Dry gates 0.30 / 0.37 V · ✅ water test, naming confirmed (11 Nov) | No wet events with the new vessels |
| 10 | High-limit cut-out wiring check | ✅ Verified 29 Oct 2026 | - | - | - | In series with both valve motors |
| 11 | Slow-leak diagnosis | ⏳ Baseline ≈0.035 bar/day; starts when the boiler gauge is live | - | ✅ 24 h decay alert (gated) | - | Doc 04 plan; condensate pipe, PRV discharge, ceilings |
| 12 | Understairs board (UFH pump, cooker, UFH temps) | ⏳ Clamps to fit at CU; probes to place | ✅ Flashed | ⏳ | ⏳ | Floating readings seen with nothing connected; add guards (doc 10) |
| 14 | UFH manifold pressure (proposed) | ⏳ | ⏳ | ⏳ | ⏳ | Split-system leak isolation |
| 13 | OpenTherm node (D1 mini + DIYLESS) + PID | ⏳ D1 mini arrived, orientation proven, soldering pending; enclosure to adapt; changeover relays | ⏳ Skeleton | ⏳ | - | After the monitoring baseline |
| 15 | Alerts package (23 automations) | - | ✅ ESP32 chip temperature added | ✅ Live 11 Nov, notifications confirmed | - | [Doc 15](15-alerts.md); boiler pressure and opto gates off until commissioned |
