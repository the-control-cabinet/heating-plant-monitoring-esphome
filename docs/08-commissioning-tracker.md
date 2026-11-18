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
| 7 | Cylinder inlet pressures (×2) | ✅ Both live; gauges fitted between pressure reducing valve and vessel · ⏳ close both boxes after tug-tests | ✅ Left GPIO1 / right GPIO2 (swapped 11 Nov) | ✅ Alerts on | ✅ Zero · ✅ static vs mains (2.9 / 2.98 bar) · ⏳ tyre-gauge span at ~4 bar | A loose 20k gave a false 5 bar (doc 05) |
| 8 | Expansion vessels + valves | ✅ Flomasta 24 L at 3.5 bar (11 Nov); expansion relief valves kept | - | ✅ Inlet alerts | - | pressure reducing valves settle ~2.5 bar (pre-set 3.5): strainers/cartridges at the next visit; then match the pre-charge |
| 9 | Tundish sensors (×2) | ✅ Re-terminated 10 Nov · ⏳ holder drainage | ✅ Wet + running | ✅ Wet alert | ✅ Dry gates 0.30 / 0.37 V · ✅ water test, naming confirmed (11 Nov) | No wet events with the new vessels |
| 10 | High-limit cut-out wiring check | ✅ Verified 29 Oct 2026 | - | - | - | In series with both valve motors |
| 11 | Slow-leak diagnosis | ⏳ Baseline ≈0.035 bar/day; starts when the boiler gauge is live | - | ✅ 24 h decay alert (gated) | - | Doc 04 plan; condensate pipe, boiler pressure relief valve discharge, ceilings |
| 12 | Understairs board (UFH pump, cooker, UFH temps) | ⏳ Clamps to fit at CU; probes to place | ✅ Flashed | ⏳ | ⏳ | Floating readings seen with nothing connected; add guards (doc 10) |
| 14 | UFH manifold pressure (proposed) | ⏳ | ⏳ | ⏳ | ⏳ | Split-system leak isolation |
| 13 | OpenTherm node (D1 mini + DIYLESS) + PID | ⏳ D1 mini arrived, orientation proven, soldering pending; enclosure to adapt; changeover relays | ⏳ Skeleton | ⏳ | - | After the monitoring baseline |
| 15 | Alerts package (23 automations) | - | ✅ ESP32 chip temperature added | ✅ Live 11 Nov, notifications confirmed | - | [Doc 15](15-alerts.md); boiler pressure and opto gates off until commissioned |

## Update (16 Nov 2026)

| Item | Status |
|---|---|
| Boiler gauge on GPIO6 | ✅ Commissioned 12 Nov, checked cold and hot · ⏳ 10 µF at the pin |
| Inlet gauge spans | ✅ Tyre-gauge checked (left gain 1.028) · left noise fixed (10 µF at IO1) · ⏳ 10 µF at IO2 |
| 5 V bus decoupling | ✅ 470 µF + 100 nF |
| NTC standing offset | ✅ Checked, no correction |
| Clamp | ✅ AC check ~5 % high, no change · ⚠️ states wrong at low fire → v3 ([doc 16](16-boiler-states-short-cycling-and-v3.md)) |
| GPIO21 (test mode) | ✅ 3.269 V, tundish item closed |
| Height offset | ✅ 6.2 m measured · ⏳ mains sensor meter check + Test 3 ([doc 17](17-cylinder-inlets-height-offset-tests-and-trend.md)) |
| Hot water estimate | ✅ v4 |
| Alerts | ✅ Relay-based hot water alerts, weekly 60 °C on CS92s, inlet floor trend · failed-ignition alert off until v3 |
| Housekeeping | ✅ Old MQTT device "ESP32 Control Room (Heating)" deleted (its retained discovery kept old entities alive) · ⏳ two orphaned statistics |

## Update (18 Nov 2026)

| Item | Status |
|---|---|
| Boiler gauge on GPIO6 | ✅ 10 µF fitted (GPIO7 held low as its ground), noise 3× lower · ✅ hot check: dial ~1.37 vs HA 1.34 |
| Inlet gauges | ✅ 10 µF at IO2 (noise 3-4× lower) · ✅ left gain 1.028 confirmed overnight · right inconclusive (stays 1.000) |
| Height offset | ✅ **Closed:** 5.87 m (0.576 bar), mains sensor calibrated, gap = check-valve ratchet; tolerance correction 0 ([doc 17](17-cylinder-inlets-height-offset-tests-and-trend.md)) |
| Clamp | ✅ 2 turns, multiply 7.5 (17 Nov) |
| Boiler states | ✅ **v3 live** (17 Nov), validated against two videos of the boiler display; light-off threshold 0.42 A at 2 turns ([doc 16](16-boiler-states-short-cycling-and-v3.md)) |
| Opto board | ✅ **Installed and commissioned** (17 Nov): all 8 inputs proven on and off ([doc 11](11-opto-board-installation.md#6-installed-and-commissioned-17-nov-2026)) |
| Alerts | ✅ Opto alerts on · ✅ "boiler called, flow cold" on IN1 · ✅ pressure peak · ✅ robust cold minimum ([doc 15](15-alerts.md)) |
| Junction box | ✅ Stage 1a (functional Wago rewire) · ⏳ earth bar: two earths to re-terminate, one earth to trace · ⏳ Stage 1b tidy |
| Housekeeping | ⏳ Orphaned statistics (old v2 state binaries, heap/loop sensors) at the end of the project |
