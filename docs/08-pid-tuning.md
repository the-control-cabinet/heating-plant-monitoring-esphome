# 08 · PID Tuning (Template)

[← Back to README](../README.md) · Log: [data/tuning-log.csv](../data/tuning-log.csv)

## Method
1. **Baseline:** a week on the original on/off control, recording cycles per hour, flow and return temperatures, gas per degree-day.
2. **Weather compensation only** (PID off): tune the curve until most rooms reach setpoint with little Evohome TPI cycling.
3. **Open-loop step test:** with the setpoint stepped +5 °C, record the response of the process variable: dead time, time constant, gain.
4. **Initial parameters** from the step test (e.g. a SIMC- or Ziegler-Nichols-style rule), then **conservative detuning**: buildings punish aggressive control.
5. **Closed-loop tests:** setpoint change, a disturbance (a cold morning, DHW interruption); check for overshoot, oscillation and settling.
6. **Record every change** in the tuning log.

## Results (fill in)
| Parameter | Initial | Final |
|---|---|---|
| Kp | | |
| Ki | | |
| Kd | (likely 0) | |
| Sample time | 60 s | |
| Output limits | ±10 °C | |
