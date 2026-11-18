# 04 · Boiler Pressure and Slow-Leak Diagnosis

[← Back to README](../README.md)

## Sensor status
- 0-80 psi (0-5.5 bar) transducer (0.5-4.5 V, G1/4, 5 V ratiometric) **installed** on the primary circuit; 10k/20k divider (measured ratio 0.664) to GPIO1, 100 nF at the pin.
- **Calibrated to the boiler gauge** (3 points, 3-4 Nov 2026) and **filtered** (5 Nov). Next: the zero at the next drain-down, a test gauge, the 10 µF supply capacitor, then leak diagnosis.

## Calibration done (3-4 Nov 2026)

**ADC first:** a two-point calibration of the pin voltage against a meter (16 samples, 100 nF fitted). Rechecked hot: HA 0.972 V = meter 0.972 V.

**Then pressure against the boiler's gauge:**

| Gauge | HA (before) | Difference |
|---|---|---|
| 1.10 bar (cold) | 1.00 bar | 0.10 |
| 1.60 bar (cold, after a top-up) | 1.42 bar | 0.18 |
| 1.65 bar (hot) | 1.46 bar | 0.19 |

A **straight line**: the first two points predicted 1.648 bar for the third. Best fit: gauge = 1.193 × HA − 0.093, all points within 0.002 bar, applied as a least-squares `calibrate_linear`. **Valid range checked: 1.0-1.65 bar only** (the zero waits for a drain-down; the gauge itself is unverified).

## Zero and span calibration (no draining needed)

Venting the sensor to 0 bar would mean draining down again, so calibration uses readings in place.

**Why the zero matters less than it seems:** leak diagnosis uses **changes** in pressure (bar/day). A fixed zero offset cancels out of every difference, so the decay rate is unaffected by it.

**1. Single-point offset against the mechanical gauge**

The sensor's slope is fixed by its specification: 0.5-4.5 V over 0-5 bar = **0.8 V/bar** at the sensor (0.533 V/bar at the ADC after the 2/3 divider). One reference reading is enough to fix the zero:
1. Choose a **stable, cold** moment (heating off, e.g. early morning).
2. Note the boiler's **mechanical gauge** reading, *P_gauge*.
3. Take the **median sensor voltage** over that minute (ADC voltage ÷ 0.667), *V*.
4. `boiler_p_zero_v = V − 0.8 × P_gauge`. *Example:* V = 1.43 V at 1.2 bar → 1.43 − 0.96 = **0.47 V**.

**2. Span check at the next top-up**

Record both the sensor and the gauge **before and after** a filling-loop top-up. The sensor's change should match the gauge's (e.g. +0.5 bar ≈ +0.40 V at the sensor). If it doesn't, the two before/after pairs give a two-point calibration (`calibrate_linear`).

**3. Baseline statistics**

Log the filtered pressure (and raw voltage) with a statistics sensor ([example](../config/homeassistant/pressure-statistics.example.yaml)) over an hour at steady conditions. The **standard deviation** is the real noise floor. Use it to confirm the noise fixes, and to set alert margins above it.

**Accuracy statement:** absolute pressure is "good to the mechanical gauge" (about ±0.1 bar). The **decay rate** used to find the leak is much more precise, because it's a difference.

**Supply check:** these sensors are ratiometric to their **5 V supply**. Measure the 5 V at the sensor; if it's low or noisy, the reading shifts. Use a clean, decoupled 5 V.

## Noise (5-6 Nov 2026)

**Two kinds of variation, only one of them noise:** with the heating running, swings of 0.05-0.2 bar follow the heating cycles (real expansion). Overnight, with everything off, there was **±0.02 bar fuzz** and occasional single dips of 0.05-0.1 bar.

**Where it comes from:** the noise arrives in **bursts** (e.g. 02:00, 03:30, 05:00-05:35) while the flow/return NTCs, on the same ADC, stay smooth, and with all relays off and flow/return flat (no pump runs). So it isn't the ADC and it isn't real pressure: it enters through the sensor's own path, most likely **ripple on its 5 V supply** (the unregulated USB 5 V, passed straight through to a ratiometric sensor), from something switching elsewhere at night.

![Pressure noise in bursts while the NTCs stay smooth](images/pressure-noise-bursts-vs-ntc-2026-11-05.png)

**Filtering:** a fast path and a slow path, because noise that varies over seconds can only be averaged out over time:
- **Boiler System Pressure (fast)**, diagnostic: 1 s readings, 7-reading sliding median (removes single-sample glitches), 5-reading average: responds in ~5-8 s, for pump and valve events.
- **Boiler System Pressure**, main: a 1-minute average of the fast one, published every 10 s, for dashboards and alerts. (The `copy` platform inherits the source's diagnostic category; `entity_category: ""` keeps it in the main list.)

A first attempt with oversampling and short windows gave **no visible improvement**, which is what led to the two-path design. Result: the overnight line roughly **three times tighter**.

![Smoothing applied at 02:00](images/pressure-smoothing-applied-0200.png)

![24 hours after: slow overnight cooling drift visible, heating swings real](images/pressure-24h-after-smoothing.png)

**Still to do, one change at a time:** 10 µF (+100 nF) across the sensor's 5 V and GND at the sensor end; then, if needed, 1 µF instead of 100 nF at GPIO1; then a better USB supply for the ESP32.

## Slow-leak diagnosis plan

**What's known:** the system loses pressure slowly, **about 1.5 bar → 1.0 bar over roughly two weeks**, which is about **0.25 bar/week (≈0.035 bar/day)**. That's slow enough to point to a small weep rather than a burst, and fast enough to need finding. The **boiler's own expansion vessel was recharged and its diaphragm isn't leaking**, so the loss is elsewhere.

**Step 1: measure it properly**
- Pressure varies with water temperature (expansion), so compare readings **at the same condition**: e.g. **05:00 daily, heating off, system cold**.
- Record the **bar/day decay rate** over 5-7 days (the template example in `config/homeassistant/`).
- Plot pressure against flow temperature to separate thermal swings from real loss.

**Step 2: find it**

| Check | How | What it tells you |
|---|---|---|
| Boiler pressure relief valve discharge | Check the boiler pressure relief valve discharge pipe outlet (outside) for drips or staining | A passing pressure reducing valve loses water silently |
| Auto air vents | Pump/boiler AAV and any manifold vents: look for damp or crusting | Vents can weep |
| Visible joints, valves | Radiator valves, TRV bodies, manifold, cylinder primary connections, under floors where accessible | Tide marks or corrosion |
| **Circuit isolation** | Isolate one circuit at a time (radiator flow/return, UFH manifold, each cylinder primary) for 24-48 h, cold, and compare decay rates | The circuit whose isolation stops the decay holds the leak |
| Cylinder coil | A leaking coil normally **raises** primary pressure (mains pressure pushes in), so a falling pressure points away from the coils | Rules a fault in or out |

**Step 3: alarm**
- Low pressure (< 1.0 bar for 10 min) and abnormal 24 h decay go to phone alerts.
- **Baseline decay** ≈ 0.035 bar/day. After a fix, success means the cold-condition reading holding steady for 2+ weeks.

## Dashboard
Pressure with 7-day history, the daily 05:00 reading, decay rate, and the boiler flow temperature overlaid.

## Addendum (12-16 Nov 2026)

- **Boiler gauge commissioned on GPIO6** (12 Nov): 3-core + screen backhaul (red 5 V, black GND, yellow signal; screen grounded at the ESP32 end only); 0.83 V at ~1.15 bar; HA matches the boiler dial cold (~1.15-1.27 bar) and hot (1.49 vs ~1.48): no recalibration. 10 µF at the pin still to fit. Printed gauge boxes: [hardware/gauge-box](../hardware/gauge-box/).
- **Long-term statistics:** `state_class: measurement` added to the boiler and both inlet pressures (daily min/mean/max cards from 12 Nov ~23:00); two orphaned statistics (old plant-room and voltage versions) to delete.
- **Decay check changed to daily cold minimums:** a 05:00 snapshot was invalid whenever optimum start fired from ~02:00-03:00 (hot vs yesterday's cold). Now the daily cold minimum is taken at 06:00 and compared at 06:01: **1.05 bar on 15 and 16 Nov**: no loss this week. Earlier (on GPIO1, 4-9 Nov) daily swings were 0.3-0.4 bar with an inconclusive ~0.02-0.03 bar/day drift.
- **First evening baseline (12 Nov):** ~1.2 bar cold → 1.62 peak → 1.36 bar.
- **Boiler pressure relief valve:** its discharge runs internally, so it can't be watched for weeping; instead, watch for pressure ever exceeding ~2 bar (alert).

## Addendum (16-18 Nov 2026): peak alert and a robust cold minimum

- **Pressure peak:** new package [`boiler_pressure_peak.yaml`](../config/homeassistant/packages/boiler_pressure_peak.yaml): 24 h maximum, the day's peak recorded at 23:59:30 with 14 days of history, and one phone message a day if the pressure stays above a threshold helper (2.0 bar) for 2 minutes. Watches for the boiler pressure relief valve's lift point being approached (its discharge runs internally and can't be seen). First peaks: 1.47 bar.
- **Cold minimum, three fixes in three days.** The daily 06:00 cold minimum is the slow-leak watch, so it must reflect a cold, still system:
  1. *17 Nov:* the raw 24 h minimum picked up a single-sample dip (0.99 bar on 16 Nov at 15:31, during the GPIO6 capacitor work). Now taken from a **15-minute median**.
  2. *17 Nov evening:* a **pump start** on a cold system dips the reading by ~0.1 bar for ~14 minutes (0.98 bar at 12:05), which a 15-minute median doesn't remove. Now the median only counts **while boiler state v3 has been Off for 20 minutes** (new sensor "Boiler pressure pump off").
  3. *18 Nov:* that sensor went unavailable when the boiler started at 03:01, taking the 24 h minimum with it, so the 06:00 cold minimum read **0.0**. Now the pump-off sensor **holds** its last value while the boiler runs, the 24 h minimum keeps its last sample, and the cold minimum keeps the previous value if its source isn't a number.
- **Readings:** true cold static pressure 1.08-1.14 bar on 16-18 Nov (≥ the 1.05 recorded earlier, which noise had depressed): **no sign of the slow leak getting worse this week**. The leak itself stays on the plumber list.
