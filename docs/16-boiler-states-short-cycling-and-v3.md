# 16 · Boiler States from the Current Clamp: What It Can and Can't Tell, Short Cycling, and v3

[← Back to README](../README.md)

**Status (18 Nov 2026): v3 is live (flashed 17 Nov 14:12, tuned 18 Nov). It was built against two videos of the boiler display and replayed over 15-18 Nov. v2 turned out to be reading the boiler back to front. Sections 1-4 are the history; sections 5-9 are the current design.**

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

## 5. Ground truth: two videos of the boiler display (17 Nov)

The boiler display shows its own flow temperature and a flame symbol. Two phone videos, aligned with Home Assistant's history to within 1-2 s (the video files are not published: they carry location data; findings only):

| Video | Load | What it showed |
|---|---|---|
| 12:23-12:36 | Radiators only (one room) | Four short burns. The burner stops when its flow reaches **72-73 °C**, then waits a fixed **~120 s** (anti-cycle timer) with the pump running, then relights. No fault codes. |
| 13:48-13:56 | Every zone in the house calling | One continuous burn at full fire, boiler flow 46-52 °C. |

What the clamp did at the same moments:

| Boiler doing | Clamp (1 turn) |
|---|---|
| Light-off (fan pre-purge) | 0.42-0.53 A jump for ~10 s, at the same second as the flame symbol |
| Burning, low fire | 0.14-0.24 A (the pump slows) |
| Burning, mid fire / fan ramp | 0.28-0.40 A |
| Burning, full fire | 0.57-0.60 A |
| Burner out, pump running (anti-cycle wait) | 0.30-0.36 A, steps up within ~8-10 s of flame-out |
| Pump overrun after the call (~4 min) | 0.30-0.34 A |
| Standby | ~0 A (0.08-0.12 A at times) |

**v2 was inverted.** Its "Firing - Low" was the pump-only anti-cycle wait or overrun; its "Fan and/or Pump Active" was the burner actually burning; and every "Ignition Attempt" was the burner going **out**. Starts, firing time and failed ignitions before 17 Nov are not meaningful. At light load the pump-only current is **higher** than the burning current, so current alone can never tell burning from not burning.

## 6. v3 rules (on the ESP32, 1 s loop)

Inputs: 5 s median of the clamp current; the 2 s flow reading and its 20 s slope; flow minus return; opto IN1 (boiler switched live).

| Event | Rule |
|---|---|
| **Lights** | Current jumps to **≥ 0.42 A** from not lit (fan pre-purge), or sits at 0.13-0.28 A while the flow rises faster than 0.08 °C/s |
| **Goes out** | Current < 0.13 A for 10 s (pump stopped); or current in **0.28-0.42 A** with the flow falling faster than 0.12 °C/s (after a 45 s grace), dated back to when the current entered that band; or that band with flow minus return < 4 °C for 30 s |
| **Failed ignition** | Lit by a jump but no flow rise (> 0.05 °C/s) within 120 s |
| Pump running, burner out | **Anti-Cycle Wait** if IN1 is on, **Pump Overrun** if IN1 is off |

States published: Off · Burner Lighting · Burning - Low Fire / Modulating / High Fire · Pump Only - Anti-Cycle Wait · Pump Overrun. Also: **Boiler Burner On** (binary), **Last Burn Duration**, **Last Off Gap**, **Failed Ignitions** (counted on the board, kept through reboots). Home Assistant counts starts and firing time from Boiler Burner On ([`boiler_kpis.yaml`](../config/homeassistant/packages/boiler_kpis.yaml)).

Flow, return and ΔT now go to Home Assistant on a 0.5 °C change or every 30 s (they were sent every 2 s: ~1,700 rows an hour each, now ~160 at rest); the logic still uses the 2 s readings on the board.

## 7. Validation

- **Against the videos:** starts within 1-2 s, ends within 3-15 s, anti-cycle gaps 118-120 s.
- **Full replay, 15-17 Nov:** 16 Nov 74 burns (45 under 3 minutes, 9.5 h firing); 17 Nov 80 burns (61 under 3 minutes, 6.6 h), **0 failed ignitions**. The most common gap between burns is 90-140 s: the anti-cycle relight.
- **Clamp turns (17 Nov evening):** the boiler live now passes through the clamp **twice** (three didn't fit) and the multiply is 7.5. Pump-only then read **0.375-0.384 A** instead of 0.34-0.36 (the single-turn reading had been near the ADC's floor), which sat on the old 0.38 A light-off threshold and produced 3 false "Burner Lighting" events overnight. Threshold raised to **0.42 A** on 18 Nov; replay of 18 Nov 00:00-08:38: 26 burns, none without a flow rise.
- **New detail at 2 turns:** a burn ends with a short post-purge fan spike (0.41-0.48 A) before the pump-only level.

## 8. What the clean data shows

- **Radiators only = short cycling:** 18 Nov 03:00-04:00, the upstairs radiators' optimum start ran alone: **19 burns in the hour**, 45-60 s each, ~2-minute waits. The same pattern as the radiators-only video and 15 Nov. Once the underfloor joined at 04:03 the boiler settled into long burns.
- **One room's radiator alone** (17 Nov 22:00): 34 s burns every couple of minutes.
- Fix: the **automatic bypass** (plumber) and a range-rating / anti-cycle discussion at the service. The data now gives the plumber exact figures: cut-off at 72-73 °C, 120 s anti-cycle.

## 9. Lessons

1. A derived state needs an **independent physical reference** before anything alerts on it. Here: a video of the appliance's own display.
2. On a modulating boiler, **current doesn't rank by "how much is happening"**: the pump alone can draw more than burning at low fire.
3. **Changing the sensor changes the bands.** Adding clamp turns shifted pump-only from 0.35 to 0.38 A and onto a threshold. Re-check the bands after any change to the measurement chain.

