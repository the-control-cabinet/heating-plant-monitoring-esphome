# 19 Control-room ESP: Home Assistant connection drops (22-26 Nov 2026)

**Status: open, strong lead.**

## Symptom
Every entity on the control-room board went unavailable together for 1-2 s, then came back, many times a day (14 between 18:44 and 08:03 on 22-23 Nov; one of ~3 minutes when the router restarted). The board itself never restarted (uptime kept climbing) and its Wi-Fi signal was strong (−29 dBm). Missing samples matter here: alerts that read flow and return during a drop printed 0.0 °C.

## Evidence gathered
- **Home Assistant log (debug on the ESPHome integration):** the board closed the connection itself after a short silence; Home Assistant reconnected within ~0.2 s.
- **Router log:** no Wi-Fi disconnects or roams for the board; it stayed on the same access point throughout.
- **On-board counters (diagnostic firmware, 23 Nov 19:58):** Wi-Fi disconnects and API disconnects counted separately, plus loop time. Result over the first evening: 4 API drops, 0 Wi-Fi drops; loop time a normal 2-3 ms.
- **Wi-Fi power saving off (23 Nov 22:35):** no help: 22 API drops in 10.3 h, still 0 Wi-Fi drops.
- **Night-time tasks:** drops ran at the same rate all day (31 in 13.6 h on 24 Nov), so not Home Assistant backups or overnight jobs.
- **Other boards:** two Bluetooth proxies also showed connection resets, so it may not be this board alone.

## The lead
On 24 Nov at 22:08 the board was flashed with two extra diagnostic sensors that publish every 2 seconds ([doc 05](05-dhw-cylinders-expansion-and-tundish.md)). Nothing else changed. Drops fell from **~2.3 an hour to ~0.4 an hour**, and stayed there for two days (apart from a manual router restart). That points at the connection's quiet periods: with constant traffic the keep-alive path is rarely needed, and the drops mostly stop.

## Next
1. Catch the board's own log line at a drop to see which side's keep-alive fails.
2. Compare with the Bluetooth proxies' disconnect counts.
3. Decide between a permanent fix (shorter keep-alive, a small regular publish) and removing the cause.
4. Then remove the diagnostic sensors and counters, and turn power saving back to its default. All are flagged in the firmware header.

The firmware in [`config/esphome/esp32-control-room-heating.yaml`](../config/esphome/esp32-control-room-heating.yaml) is the diagnostic build that's running now.

## Test 2: traffic or sampling? (from 27 Nov 2026, 09:13)
The 24 Nov peak sensors changed two things at once: steady traffic to Home Assistant **and** 20 ms ADC sampling keeping the board's main loop busy. Baseline with them on: **0.43 drops an hour** (6 in 14 h, 26-27 Nov), 0 Wi-Fi drops.

One change: both peak sensors removed (their job was done: water hammer ruled out) and a **heartbeat** added, a diagnostic sensor that sends a changing value every second, the same message rate with no fast sampling.
- Drops stay near 0.4/h → **traffic** is the cure; a heartbeat (or a shorter keep-alive) becomes the permanent fix.
- Drops return to ~2/h → the **sampling/loop activity** was the cure; loop timing is the next lead.

Caveat, recorded honestly: the ESPHome dashboard had already updated itself, so this flash also took the board from 2026.11.0 to 2026.11.1. The 2026.11.1 notes touch nothing on this board. The rest of the fleet followed at ~10:35 the same day.

*Result: to be added after 24-36 h.*
