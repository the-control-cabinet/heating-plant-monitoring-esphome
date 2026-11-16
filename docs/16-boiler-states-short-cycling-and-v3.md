# 16 · Boiler States from the Current Clamp: What It Can and Can't Tell, Short Cycling, and v3

[← Back to README](../README.md)

**Status (16 Nov 2026): state v2 is flashed but wrong at the low end; the failed-ignition alert is off (false counts); v3 (burner detected from the flow temperature) is designed and waits for a 10-minute look at the boiler display as ground truth.**

## 1. v2 (flashed 15 Nov 09:40)

A 5 s median of the clamp current feeds a state machine: *firing* above 0.33 A (off below 0.29 A), *high fire* above 0.55 A, an "ignition attempt" while a rise is pending for 15-20 s, and 20 s confirm/drop timers. A **failed ignition** counted when no burn followed within 3 minutes of an attempt.

## 2. What the data showed (13-15 Nov, flow temperature as the reference)

A flow-temperature detector (a rise of ≥ 2 K within 30 s = lit, a fall of ≥ 2 K = out, ≥ 40 s on) finds the real burns independent of the clamp. Against it, the clamp bands are **inverted at the low end**:

| Condition | Clamp current |
|---|---|
| Burning at **low fire** | **0.13-0.18 A** |
| Pump overrun after a burn (~4 min) | 0.30-0.40 A |
| Fan pre-purge spike | 0.40-0.47 A |
| High fire | 0.50-0.58 A |

So v2 reads low-fire burning as "off", and the pump overrun as "firing". The two "failed ignitions" on 15 Nov (12:03, 13:09) were normal lights at low fire. A fan spike precedes only 47 of 152 detected burns, so **ignition attempts can't be counted from the clamp at all**. The failed-ignition alert was **disabled on 15 Nov** (the counter still runs, for comparison).

**Lesson:** a current clamp on a modulating condensing boiler separates fan, pump and high fire, but not low-fire burning from the pump alone. Validate a derived state against an independent physical signal before alerting on it.

## 3. Short cycling (radiators only)

15 Nov 04:15-04:37, flow-confirmed: **~50 s burns every ~2.6 minutes** with only the radiators calling. The boiler's minimum output exceeds the load, there is no automatic bypass, and every radiator has a TRV. Not a safety issue; fixed properly by the **automatic bypass** (plumber). Interim option: one radiator head (landing or towel rail) left unclipped as a guaranteed load. Lowering the flow temperature would make it worse. At the service: ask whether the heating output range (range rating) or anti-cycle time can be reduced.

## 4. v3 design

| Part | Source |
|---|---|
| Burning / not burning | Flow temperature (rise/fall detector, on the ESP32 with the flow NTC) |
| High vs low fire | Clamp current while burning |
| Pump overrun | Clamp current after the burner goes out |
| **Lockout check** (replaces the failed-ignition alert) | A relay calling for 15 min with no flow rise |

Before flashing: a 10-minute video of the boiler display during a radiators-only call (flame symbol, codes) as ground truth, and a replay of v3 against 13-16 Nov. Then the counters and the disabled alert are removed and replaced, not just deleted.
