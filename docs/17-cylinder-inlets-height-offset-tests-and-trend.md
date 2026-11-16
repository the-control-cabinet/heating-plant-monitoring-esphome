# 17 · Cylinder Inlets: Height Offset, Tests and an Overnight Trend

[← Back to README](../README.md)

**Status (16 Nov 2026): inlets behave as expected; the effective offset below the mains sensor is 0.37 bar, 0.15-0.24 bar less than the measured 6.2 m height predicts (open: meter and stopcock checks); an overnight floor-trend alert is live.**

## 1. Expected pressure at the cylinders

The mains sensor (ground-floor utility room, after the stopcock) and the cylinder inlet gauges (second-floor control room) differ by height. Measured with slow-close tests (14 Nov): the cylinders settle at **~2.55 bar** while the mains sensor reads **~2.92** → **effective offset 0.37 bar**; the overnight floor (Test 1) gives ~0.43-0.48 bar. The vertical distance, **tape-measured at 6.2 m** (16 Nov), predicts **0.61 bar** (0.0981 bar/m). So the sensors disagree with the height by **~0.15-0.24 bar**. The inlet gauges were span-checked against a tyre gauge and zeroed, while the mains sensor's span has never been checked, so the likeliest explanation is the **mains sensor reading ~0.15-0.25 bar low**. The offset helper therefore stays an *effective* value (height + calibration difference) until the meter check and Test 3 separate a zero error from a span error. Package: `config/homeassistant/packages/cylinder_inlet_head.yaml` ("expected at cylinders" and each side's "vs expected").

Open (the gap): multimeter at the mains sensor's output (rest and during a draw) and Test 3 (stopcock off and a tap opened to release the pressure: the mains sensor should read ~0). A zero error shows in Test 3; a span error shows as a gap that grows with pressure.

## 2. Why the inlets sit at ~3.7-3.8 bar after a reheat

Water expands as it heats; with the inlet check valve closed, the trapped volume pushes into the expansion vessel. The vessels are pre-charged at **3.5 bar** (the label maximum; factory 2.7) while the supply at the cylinders is only ~2.5 bar. A vessel does nothing until the water pressure exceeds its pre-charge, so the first part of the expansion is uncushioned and the swing is larger. Boyle's law (24 L vessel, gauge bar):

V(P) = 24 × (1 − (P₀ + 1) / (P + 1))

To absorb ~3.5 L of expansion: **~4.3 bar** at a 3.5 bar pre-charge vs **~3.1 bar** at 2.5 bar. Not a safety issue (expansion relief valves at 6 bar), but a pre-charge matched to the actual supply (~2.5 bar) gives more headroom. Question for the plumber.

## 3. Tests

| Test | Result |
|---|---|
| Kick tests (both inlets) | Inlets respond to draws as expected; no fault |
| Test 2 (right side) | No fault |
| **Test 1** (overnight floor, 15-16 Nov) | Left 2.35 / right 2.40 bar vs mains 2.83. **Valid only on a side drawn after its evening reheat**; an undrawn side stays held up by expansion all night |
| Boiler cold minimum | 1.05 bar two days running (no decay this week) |

## 4. Overnight floor trend (16 Nov)

`config/homeassistant/packages/cylinder_inlet_floor_trend.yaml`: each night the lowest "vs expected" value from 02:00-05:00 per side is that cylinder's floor. It is recorded at 05:00 **only if within ±0.5 bar** of expected (expansion-held nights skipped). At 05:02 an alert fires if a valid night differs by more than **0.15 bar** (helper) from the average of at least 3 previous valid nights. It watches drift (pressure reducing valve creep, a sensor drifting, leak-by) independent of the exact offset value.

## 5. Inlet group losses (12 Nov)

Like-for-like hot-only tap draws: both inlet groups lose ~0.55-0.6 bar at only 3-4 L/min (loss/flow²: left ~0.04, right ~0.07), high for a 22 mm group: consistent with partly blocked strainers. The left "settling below mains" seen earlier was a part-closed cold isolating valve, fixed by opening it fully. Plumber: clean both strainers, then repeat the test.
