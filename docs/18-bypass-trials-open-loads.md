# 18. Short cycling: automatic bypass vs open loads, and the two bypass trials (19 Nov 2026)

The boiler short-cycles whenever the heat being taken is below its minimum output. Doc 16 measured it with radiators only (45-60 s burns, about 19 an hour). On 19 Nov the new alert wording ([doc 15](15-alerts.md#changes-19-nov-2026)) showed the same with **only the underfloor calling**. This doc sets out what an automatic bypass does and doesn't do, and the two open-load trials started on 19 Nov.

## 1. Two different jobs

| Job | Automatic bypass valve | Always-open radiator or loop |
|---|---|---|
| **Flow path** when TRVs and zone valves shut (pump, pump overrun, zone valves) | **Yes** | Yes, while it's guaranteed open |
| **Heat sink**: takes heat away, so a burn lasts longer before the boiler overshoots | **No**: bypassed water comes straight back hot | **Yes** |

- **The automatic bypass is required** before the two radiator zone valve heads are re-powered (S-plan control restored, [Evohome A6](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration/blob/main/docs/A6-pump-overrun-and-bypass.md)). It also stretches the most extreme, **flow-starved** burns (most TRVs throttled, almost no flow through the boiler). It adds no load, so it **doesn't remove load-limited cycling**.
- **An open radiator or loop is the classic "bypass radiator"**: a real heat load. In an ordinary system it sits in the room with the only thermostat, so it switches off with everything else. Here the boiler fires for any zone, so an open radiator heats **whenever its circuit runs**, needed or not.

## 2. What sets a floor on starts

- **Evohome's relay control (TPI):** both hubs at **3 cycles an hour, 5 minutes minimum on**, the gentlest settings. At partial demand every "on" window is a boiler start, so up to about 3 starts an hour per relay are built in. Evohome's steep zone-to-relay demand curve makes partial demand common ([Evohome B8 §8](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration/blob/main/docs/B8-ufh-demand-decoding.md)).
- **The boiler's own anti-cycle wait:** 86-97 s from cut-out to relight on 19 Nov ([doc 16 §10](16-boiler-states-short-cycling-and-v3.md#10-fixes-after-go-live-18-19-nov)).
- **No bypass of any kind changes the TPI windows.** Removing them needs modulating control (the OpenTherm plan). Open loads can only lengthen the burns **inside** each window.

**Flow temperature is not a cure for this.** The cycling is set by the energy balance (load below minimum output). A lower flow temperature lowers what the radiators give off, so on radiators alone it tends to make cycling worse ([doc 16 §3](16-boiler-states-short-cycling-and-v3.md#3-short-cycling-radiators-only)). The flow temperature test stays on the list for condensing efficiency, not as a short-cycling fix.

## 3. The two trials

| Trial | Side | Open since | Ends |
|---|---|---|---|
| **Lounge door-end UFH loop** open, uncontrolled | Underfloor (behind the mixing valve) | **19 Nov 14:41** (its actuator failed internally and was removed: [Evohome B9](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration/blob/main/docs/B9-ufh-and-radiator-behaviour.md)) | Ended 21 Nov ~15:37 (replacement actuator fitted, proven ~16:55) |
| **Far-end Landing radiator** open (ended 22 Nov ~17:50, swapped to the master en-suite towel rail) | Radiators | **19 Nov ~19:15 ± 30 min** (HR92 and its adapter removed; the HR92 stays powered nearby so the hub sees no fault; the zone is controlled by its T87RF through the other HR92) | Swapped to a towel rail, or ended after the bypass |

**Method.** Burns are split by what is calling: IN7 (UFH relay) and IN5/IN6 (cylinder valve drives) from the opto board; **radiators from the RAMSES state of the upstairs heat-demand relay**. *Corrected 21 Nov: IN8 was first used for the radiators, but W8 is linked to W7 until Stage 2, so IN8 is the boiler switched live from any circuit ([doc 16 §11](16-boiler-states-short-cycling-and-v3.md#11-fix-and-findings-20-22-nov)).*

| Period | Judges |
|---|---|
| Radiators only | The Landing radiator, against radiators-only burns before 19 Nov |
| UFH only | The Lounge loop, against UFH-only burns before 14:41 |
| Both calling | Reported, not used to judge either |

Measured: starts per hour, burn length, off gap, flow and return. **Success:** radiators-only burns from ~50 s towards several minutes; starts falling towards the TPI floor (~3 an hour per active relay) but not below it.

**Excluded windows on 19 Nov:** Lounge override 13:35-15:27; HCC80R power-offs ~13:52 and 14:50-15:05; left hot water relay unpowered ~15:40-22:13 (off its backplate).

## 4. First evening (19 Nov)

| Alert | Calling | Flow / return | Reading |
|---|---|---|---|
| 15:49 | (UFH recovering) | 62.1 / 35.0 °C | Plenty of heat taken: the floor recovering after the HCC80R work. Excluded window. |
| 19:35 | UFH | 57.0 / **56.7 °C** | 7 starts in the hour; almost no heat taken |
| 21:09 | UFH | 56.4 / 53.8 °C | 7 starts in the hour; the same |

**The open Lounge loop doesn't stop UFH-only cycling.** Once the screed is warm, the mixing valve (about 50 °C) recirculates floor water and injects only a trickle from the boiler, so the boiler sees almost no load. An open loop on the floor side doesn't change how much the valve injects. The Landing radiator can't help in those periods, because the radiators aren't calling.

**Cost seen:** the Landing overshot its setpoint by 20:20, as expected for an uncontrolled radiator.

## 5. Next (as planned 19 Nov)

1. **Towel rail comparison:** refit the Landing HR92 and open the master en-suite towel rail instead (warmth more welcome there, smaller load). Compare burn lengths.
2. **After the automatic bypass is fitted:** one week with every TRV back on, against the open-load data, to decide whether a permanent open load is still wanted.
3. **UFH-only cycling** needs a control-side answer: a longer boiler anti-cycle time (service question), or the relay decided by HA from real zone demand ([Evohome D1](https://github.com/the-control-cabinet/evohome-heating-controls-ramses-integration/blob/main/docs/D1-roadmap.md)), then OpenTherm.

**For the plumber:** automatic bypass (for S-plan zone valve control); the boiler's heating range and anti-cycle time; his view on flow temperature; a permanent bypass radiator after the trials; the cylinder expansion vessel pre-charge (3.5 bar on ~2.5 bar supply); the slow pressure loss.

## 6. Corrected figures (21 Nov)

Re-run with the radiators from the RAMSES relay (see the method note above):

| Calling | Period | Burns | Median | Under 3 min |
|---|---|---|---|---|
| Radiators only | Before the Landing radiator opened | 83 | 1.8 min | 76 % |
| Radiators only | Landing radiator open | 84 | 2.8 min | 63 % |
| UFH only | 19-21 Nov | 55 | — | — |

- **The open Landing radiator lengthened radiators-only burns** (median 1.8 → 2.8 min) but most are still under 3 minutes. The radiator zone valves are latched open, so it also heats on every UFH and cylinder call, wanted or not.
- **UFH-only before/after couldn't be split on 19 Nov**: the Lounge loop and the Landing radiator both changed that day. Hence the A/B test below.

## 7. Lounge loop A/B test (21-22 Nov)

| | Test A, 21 Nov 14:42-15:42 | Test B, 22 Nov 14:46-15:46 |
|---|---|---|
| Set-up | Upstairs off, Hall 22 °C, door-end loop open | Upstairs off, meant Hall 22 °C with the loop closed; **the override went on the Lounge by mistake**, so its loops were open and calling |
| Burns | **1 continuous, 53.7 min** | **1 continuous, 56.2 min** |
| Flow / return settled | 68 / 50-52 °C | 68 / 47-50 °C |

**Neither hour could answer the question.** On a frosty afternoon the cooled screed took everything the boiler gave, so there was no cycling for a loop to change. The cycling problem is a **warm-screed** problem.

## 8. Data check instead of a third test (22 Nov)

UFH-only burns with the Landing radiator open throughout both periods (test hours, the actuator fitting and the HA update excluded):

| | Loop open (19 Nov 19:15 → 21 Nov 14:40) | Loop closed (21 Nov 17:00 → 22 Nov 17:50) |
|---|---|---|
| UFH-only burns | 30 | 16 |
| Median | 3.7 min | 4.1 min |
| Under 3 min | 37 % | 12 % |
| Return already ≥ 50 °C | median 1.7 min, 83 % under 3 min | median 6.5 min, 0 % under 3 min |

No sign that the open loop helped; the closed period also had colder weather, so it isn't evidence the other way either. **Conclusion: an open UFH loop is not a cure for UFH-only cycling** (with 19 Nov evening's 0.3 °C flow − return at 7 starts an hour). The mixing valve lets in only a trickle of boiler water once the screed is warm, whatever the loops do, and the boiler's 6.1 kW minimum is far above that load ([doc 16 §11](16-boiler-states-short-cycling-and-v3.md#11-fix-and-findings-20-22-nov)).

## 9. Next (22 Nov)

1. **Towel rail trial** from 22 Nov ~17:50: Landing HR92 refitted, master en-suite towel rail fully open. Compare radiators-only burns with the Landing period (§6).
2. **Pump minimum speed** P1 (100 %) vs P7 (70 %): one change, after the towel rail's first results.
3. **UFH-only cycling:** control side only: HA deciding the UFH relay from real zone demand, then OpenTherm modulation. The boiler has no anti-cycle setting to lengthen.
