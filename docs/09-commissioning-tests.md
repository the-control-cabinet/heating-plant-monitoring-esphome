# 09 · Commissioning and Tests (Template)

[← Back to README](../README.md) · Record: [data/commissioning-tests.csv](../data/commissioning-tests.csv)

| # | Test | Pass when |
|---|---|---|
| 1 | Node bench test (no boiler) | Online in HA; OpenTherm component running; no crashes for 24 h |
| 2 | Changeover in Mode A | Boiler behaves exactly as today on every BDR91 call |
| 3 | Mode B, read-only (CH enable off) | Valid flow, return and status data; no boiler firing |
| 4 | Mode B, CH enable with a fixed setpoint | Boiler fires and modulates towards the setpoint; flow reading ≈ NTC |
| 5 | Each demand path | Each BDR91 call produces CH enable within the debounce time |
| 6 | DHW priority | Either cylinder call raises the setpoint; normal setpoint returns when satisfied |
| 7 | Anti-cycling | Minimum on/off times respected |
| 8 | HA offline | Node continues with the last parameters |
| 9 | Node offline | Fall-back as designed (doc 06) |
| 10 | Changeover power loss (relay option) | Reverts to Mode A |
| 11 | Boiler fault simulation | Fault is reported in HA and alerted |
| 12 | 7-day soak | No faults; metrics recorded |
