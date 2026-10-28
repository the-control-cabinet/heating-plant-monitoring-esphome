# 03 · Boiler Side: Ideal Logic+ System S30

[← Back to README](../README.md)

> ⚠️ **Verify everything in this doc against the S30 installation manual before work.** Electrical work at the boiler's control terminals is low-voltage and mains control wiring, not gas work, but it needs a competent person, isolation and a dead test. If in doubt, have a Gas Safe engineer present.

## What to establish from the manual
| Question | Why it matters |
|---|---|
| Where the **OpenTherm terminals** are, and their labels | Connection point for the shield's two-wire pair |
| Whether a **factory link (bridge)** sits on the control terminals, and which: the 230 V "thermostat" link (permanent live to switched live) or a low-voltage link | Removing or fitting the wrong link either stops the boiler or leaves it firing uncontrolled |
| Whether the boiler needs the **230 V switched-live input enabled** for OpenTherm to command heat | Determines what the changeover does with the switched live in OpenTherm mode ([doc 06](06-bdr91-and-changeover.md)) |
| Which OpenTherm **data IDs** it supports (CH pressure, DHW, modulation) | Sets which sensors are worth configuring ([doc 04](04-firmware-and-ha.md)) |

## Facts that apply regardless
- **The OpenTherm pair is polarity-free, two wires, low voltage.** Never connect 230 V to the OpenTherm terminals.
- **One OpenTherm master only.** The shield replaces any other OpenTherm device.
- **Cable:** a twisted pair, kept apart from mains runs where possible.

## Connection steps (planned)
1. Isolate the boiler and controls; prove dead.
2. Identify the OpenTherm terminals and any link, from the manual.
3. Run the pair from the boiler to the **changeover** ([doc 06](06-bdr91-and-changeover.md)), and from there to the shield's **B1/B2** terminal.
4. Fit or remove the link **as the manual requires for OpenTherm control**, and record what was done (photo plus note) so it can be reversed.
5. Restore power with the changeover set to **Evohome (on/off)** first, then switch to OpenTherm for the first read-only session ([doc 09](09-commissioning-tests.md)).

## Record (fill in)
| Item | Value |
|---|---|
| OpenTherm terminal labels | ⟨record⟩ |
| Link fitted/removed | ⟨record⟩ |
| Switched-live requirement in OpenTherm mode | ⟨record⟩ |
| Supported data IDs (from the first session) | ⟨record⟩ |
