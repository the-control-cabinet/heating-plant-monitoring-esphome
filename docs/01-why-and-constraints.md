# 01 · Why OpenTherm, and the Constraints That Shape the Design

[← Back to README](../README.md)

## The problem with on/off
Today the boiler gets a 230 V switched live from any of four BDR91 relays, and fires towards **its own dial setpoint** whenever any zone calls.

| On/off (today) | Modulating over OpenTherm (planned) |
|---|---|
| Fixed, high flow temperature | Flow temperature set to need: lower in mild weather |
| Short cycles near setpoint (overshoot, then off) | Long, low burns |
| High return temperatures, so little condensing | Lower returns, so more condensing, better efficiency |
| No boiler data | Flow, return, modulation, flame, faults, pressure (where supported) |

## Constraint 1: two Evohome controllers, one boiler
Honeywell's OpenTherm bridge works with **one** Evohome controller. This house has **two** (upper floors and ground floor), each with its own BDR91s, both on the same boiler. Neither can be the boiler's OpenTherm master without blinding the boiler to the other.

## Constraint 2: OpenTherm can't simply be "listened to"
An OpenTherm gateway monitors traffic between a thermostat and a boiler. With BDR91 switching there's **no OpenTherm traffic** at all. A master device such as the DIYLESS shield **is** a thermostat: once connected, it controls the boiler.

## Constraint 3: OpenTherm and switched live together
Many boilers treat OpenTherm as the control path and may **ignore or conflict with** a switched-live call. The design therefore never relies on both at once: an **interlocked changeover** selects one or the other ([doc 06](06-bdr91-and-changeover.md)).

## Decision
- A **dedicated OpenTherm node** (D1 mini + DIYLESS shield) is the boiler's only controller.
- **Both** Evohome systems keep zone control. Their demand becomes an **input** ([doc 05](05-evohome-integration.md)).
- **Control runs on the node** (resilient to HA outages); HA provides inputs and tuning ([doc 07](07-control-strategy.md)).
- An **interlocked changeover** gives a one-switch fall-back to today's on/off control.

## Out of scope
Changing zone control, room setpoints or schedules (Evohome keeps those), and any gas-side work on the boiler.
