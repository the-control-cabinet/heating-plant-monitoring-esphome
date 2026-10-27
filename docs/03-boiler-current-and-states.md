# 03 · Boiler Current and Operating States

[← Back to README](../README.md)

## Where the clamp goes

> ✅ **Decision: on the boiler's permanent live supply (the feed from its fused spur), not the switched live.** In an S-plan the switched live is only a demand *signal* into the boiler and carries almost no current. The boiler's actual load (controls, fan, pump, ignition) flows through its **permanent live**. The demand signal itself is captured separately by the opto board ([06](06-demand-monitoring-opto.md)).

Clamp **one conductor only** (live, not the whole cable): L and N together cancel out.

## Resolution: use turns

An SCT013-015 gives 1 V RMS at 15 A, so 0.2 A gives only about 13 mV, close to the ESP32's ADC noise. **Pass the live conductor through the clamp 3-5 times.** The signal multiplies by the number of turns, and you divide the `multiply` factor by the same number (e.g. 3 turns → `multiply: 5.0`). An SCT013-005 (5 A = 1 V) is the alternative.

## State banding (current design, to be tuned on real data)

| Current (A RMS) | State | Logic |
|---|---|---|
| < 0.15 | **Off** | No supply / boiler off |
| 0.15-0.25 | **Idle**, or **Pre-Purge** at the start of a call, or **Overrun** (60 s after a call ends) | Uses the boiler-demand opto input and timers |
| 0.25-0.40 | **Fan and/or Pump Active**; **24 h pump self-test (likely)** if 23-25 h since the last real cycle and no call | Self-test heuristic |
| ≥ 0.40, first 10 s | **Ignition Attempt** | Timer from the first elevated reading |
| 0.40-0.80 | **Firing - Low** | |
| ≥ 0.80 | **Firing - High** | |
| Firing with no demand | **Firing Without Call** (alarm) | Current shows firing while the boiler-demand input is off |

Each state is also published as a binary sensor for history and automations.

## Commissioning steps
1. Fit the clamp around the **live conductor of the boiler's supply** between the fused spur and the boiler (in an enclosure or the spur back-box), with 3 turns if space allows.
2. **Zero check:** boiler off at the spur, so the reading should be near 0.
3. **Calibrate:** compare against a clamp meter at idle and when firing; apply `calibrate_linear`.
4. **Record real bands:** log a week of current against the opto demand. Set the thresholds from the actual idle, pump and firing levels.
5. Verify each state against what the boiler display shows.
