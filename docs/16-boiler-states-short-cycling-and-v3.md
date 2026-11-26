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

15 Nov 04:15-04:37, flow-confirmed: **~50 s burns every ~2.6 minutes** with only the radiators calling. The boiler's minimum output exceeds the load, there is no automatic bypass, and every radiator has a TRV. Not a safety issue; fixed properly by the **automatic bypass** (plumber). Interim option: one radiator head (landing or towel rail) left unclipped as a guaranteed load (running from 19 Nov: [doc 18](18-bypass-trials-open-loads.md)). Lowering the flow temperature would make it worse. At the service: ask whether the heating output range (range rating) or anti-cycle time can be reduced.

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

## 10. Fixes after go-live (18-19 Nov)

Two false alerts in the first two days, each traced to one rule and fixed with one change.

| When | Alert | What really happened | Fix |
|---|---|---|---|
| 18 Nov 21:22 | **Firing Without Call** | The burner went out when the UFH and radiator relays dropped (21:22:14). The pump ran on for its 4-minute overrun at 0.38 A with the valves shut, so the flow fell only slowly (70.3 → 63.8 °C). No rule saw a fast fall, and v3 kept "Burning" until the pump stopped at 21:26:30. | **The boiler call (IN1) dropping now ends a burn at once.** It's an on→off edge, so a call wire that never comes on still trips the alarm. Firing Without Call also needs 5 s (`delayed_on`), because IN1 is read every loop and the state once a second. |
| 19 Nov 06:45 | **Boiler lockout suspected** | No lockout. At 06:30 a zone sent cold water back (return 52.9 → 46.9 °C); the boiler modulated up to 0.37-0.41 A while the flow dipped. The mid-band "flow falling" rule read that as flame-out, but the burner ran on low fire until a real cut-out at 06:49:30 (72.2 °C). | **The flow-falling rule now also needs flow − return < 12 °C** (`DT_OUT`). At the decision point, real outs had 5.7-9.1 °C and shrinking; the false ones 15.1-16.9 °C and rising. If the return sensor is missing, the old rule applies. |

Both flashed (18 Nov ~22:00, 19 Nov 10:24). The 18 Nov fix was confirmed the next morning (07:04:34: call dropped mid-burn → straight to Pump Overrun), and **19 Nov was the first day with no false alerts**: 78 starts, 7.5 h firing, 0 failed ignitions, 0 calls without heat.

**Off-gap check, closed:** the cut-out-to-relight wait measured **86-97 s** on every cycle on 19 Nov (the ~120 s on the 17 Nov video was a different situation). The logic is fine.

**Lesson 4:** a rule that infers an event from a *rate* (flow falling) needs a second, independent condition that separates the real event from a look-alike. Here, the direction of flow − return did it.

## 11. Fix and findings, 20-22 Nov

**False starts after a call ends (fixed 20 Nov).** When the boiler call (IN1) dropped, the pump's overrun current sometimes jumped across the light-off threshold, and v3 logged a burn with no call. **Fix:** for 120 s after IN1 drops, a current jump doesn't count as a light-off unless the call comes back (`just_dropped` gate on the board). Flashed 20 Nov ~20:25; checked over the next 11+ call drops: no starts without a call.

**Signal truth table (21 Nov).** An analysis mistake (IN8 read as "radiators calling") made it worth writing down what each signal physically measures:

| Signal | What it really is | Until when |
|---|---|---|
| IN1 | Boiler call (switched live at the boiler) | Permanent |
| IN5 / IN6 | Left / right cylinder valve drive | Permanent |
| IN7 | UFH relay (downstairs hub) | Permanent |
| **IN8** | **Boiler switched live from any circuit**: terminal W8 is linked to W7 | Junction box Stage 2 (radiator zone valve heads re-powered, W8-W7 link removed) |
| Radiators calling | RAMSES state of the upstairs hub's heat-demand relay (`binary_sensor.bdr_13_258561_active`) | Use this until Stage 2 |
| Radiator flow | The two radiator zone valves are **latched open** (heads unpowered until Stage 2), so any radiator without a working TRV heats whenever the boiler pump runs, for **any** call | Stage 2 |

**What the boiler can and can't be set to do (manual checked 22 Nov).** The Ideal Logic+ System installer menu (function + RESTART for more than 5 s) shows the last 3 faults, then SL / SH (run at minimum / maximum rate), VF (5-minute venting) and P1 / P7 (pump minimum speed 100 % / 70 %, default). **There is no anti-cycle setting and no range rating**: the 86-97 s wait is fixed in firmware, and the gas input follows the fan. Minimum heating output is **6.1 kW** (6.1-30.3 kW at 70 °C mean). A warm screed behind a mixing valve takes far less, so UFH-only cycling is built into this boiler; the fixes are on the control side ([doc 18](18-bypass-trials-open-loads.md), [OpenTherm](07-opentherm-and-pid-plan.md)). The pump minimum speed (P1) is the only free setting; a one-change trial is queued.

## 12. Short cycling, 23-26 Nov: where the short burns come from

**Radiators-only, one room.** On weekday afternoons the only radiator calling is often one small room (the office). One radiator takes far less than the boiler's 6.1 kW minimum output. The pattern repeats: a 12-15 minute burn until flow reaches ~71 °C, the fixed 90 s anti-cycle wait, a relight of under a minute (the water is still hot), another 90 s, then the next long burn. So many of the "short burns" are relights inside one long call, not new calls.

**The radiator relay is already on the gentlest setting.** Its calls repeat every 20 minutes (3 cycles an hour, Evohome's slowest) and never run shorter than 5 minutes (the minimum on time set on 14 Nov).

**UFH: 48-second pulses.** Near setpoint in the evening, the UFH relay (IN7) switched on for **48 s every 20 minutes** (25 Nov 21:04, 21:24, 21:44, 22:04), and each pulse fired the boiler for 23-46 s. The 5-minute minimum doesn't reach it: on the downstairs controller the UFH relay is bound as a heating zone valve, and Evohome applies the minimum on time only to a relay bound as the boiler relay. A pulse that short delivers almost nothing to a screed floor (the thermal actuators take minutes to open), so each one is a wasted boiler start. The fix is the planned control stage, where Home Assistant decides the UFH relay with its own minimum on time.

**Which relay is the boiler relay (proved 26 Nov).** On the upstairs controller the radiator relay is wired straight to the boiler switched live (the radiator valve heads are latched open) and is bound as the controller's boiler relay. A boiler relay switches on for anything that needs the boiler, so it also comes on for the left cylinder. Test: with no radiator zone calling, the left hot water was boosted (14:37); the radiator relay came on with it, and when the boost was cancelled it dropped exactly 5 minutes before the left valve closed (the controller's hot water overrun). The same pattern appears in every left reheat in the history since 17 Nov. Consequence for this repo: the short-cycling alert's "Calling: radiators" can be a left reheat; the next alerts revision checks IN5 ([doc 15](15-alerts.md)).

**The overrun doesn't stop the boiler here.** In the test the burner kept firing until the left valve closed, not when the boiler relay dropped: the valve's end switch still calls the boiler. On this wiring the 5-minute hot water overrun adds 5 minutes of firing to every left reheat. It will behave as intended once firing moves to Home Assistant.

**Pump minimum speed trial (from 25 Nov 21:03).** The installer setting was changed from P7 (70 %, the default) to P1 (100 %). There's no read-back of the old value, but the first morning answers it: the flow-return gap during long burns fell from 15-17 °C to 12-15 °C, so the pump is now moving more water and the setting was on 70 % before. Starts per hour and short burns are being compared over the following days at similar outside temperatures. Revert: select P7.

**Next:** the flow temperature test (the CH knob also sets the cylinder reheat flow on this system boiler, so the cylinders must still reach 60 °C), then the automatic bypass (plumber), then Home Assistant control.
