# 10 · Outcomes, Use Cases and Constraints (Template)

[← Back to README](../README.md)

## Metrics: before vs after (fill in)
| Metric | On/off baseline | OpenTherm + PID |
|---|---|---|
| Boiler cycles per hour (heating season) | | |
| Mean flow temperature | | |
| Mean return temperature (condensing < ~55 °C) | | |
| Gas per heating degree-day | | |
| Rooms within ±0.5 °C of setpoint | | |

## Use cases
| Scenario | Expected behaviour |
|---|---|
| Mild autumn day, one zone calling | Low flow temperature, long low burn |
| Cold morning, all zones calling | High weather-compensated setpoint; PID trims down as rooms recover |
| Hot-water call during heating | DHW priority, then a return to the CH setpoint |
| Night setback | Demand falls away; no short-cycling |
| HA down | Node runs with the last values and hard-wired demand |
| Node failure | Changeover to Evohome on/off |
| Boiler fault | Fault code alert in HA; changeover to Mode A doesn't fix the boiler, but it's visible |

## Constraints and limits
- One OpenTherm master: no Honeywell OpenTherm bridge can be added.
- Evohome's BDR91 TPI cycling becomes a demand **signal**, not control; it needs filtering.
- Boiler-reported data depends on the S30's supported OpenTherm IDs.
- The opto demand reaches the node via HA (a Wi-Fi dependency) unless a direct input is added (doc 06).
