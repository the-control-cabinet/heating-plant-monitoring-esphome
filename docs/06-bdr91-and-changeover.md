# 06 · BDR91s and the Changeover: One Boiler, Never Two Masters

[← Back to README](../README.md)

## What happens to the BDR91 switched lives
Today the four BDR91 outputs are commoned onto the boiler's **switched live**. In OpenTherm mode they must **not** reach the boiler. They do need to stay **visible**, which the opto inputs already do.

## Changeover design
An interlocked changeover selects **one** control path at a time:

| Mode | Boiler switched live | OpenTherm pair | Who controls |
|---|---|---|---|
| **A: Evohome (today)** | Fed by the commoned BDR91 outputs | **Disconnected** from the boiler | BDR91 on/off |
| **B: OpenTherm** | Disconnected from the BDR91s; linked or held as the manual requires ([doc 03](03-boiler-connection.md)) | Connected to the node | Node: modulation |

**Implementation options:**
1. **A manual changeover switch** (a DPDT rotary or 2-pole changeover, mains rated): simplest, very clear, and fails to whatever position it's left in.
2. **A relay changeover** (DIN-rail 2-pole changeover relay) driven by HA/node, with the **de-energised state = Mode A**. Any loss of control power reverts to Evohome on/off, giving a **fail-safe**.

**Interlock rule:** a single changeover element switches **both** the switched-live path and the OpenTherm pair, so the two modes can never be active at once (mechanical or same-relay interlock, not software).

## Fail-safe behaviour
| Failure | Result |
|---|---|
| Node offline (in Mode B) | Boiler OpenTherm timeout: falls back per the boiler's behaviour. Plan: an HA watchdog flips the changeover to Mode A (relay option) |
| HA offline | Node keeps controlling with the last parameters and hard-wired demand |
| Wi-Fi offline | Node keeps controlling locally (opto demand would need a local path; see the note below) |
| Changeover power lost (relay option) | De-energises to **Mode A**: Evohome on/off |

**Note on hard-wired demand:** the opto inputs live on the plant monitoring board, not on the OpenTherm node, so the node receives them **via HA**. For full Wi-Fi independence, either duplicate one "any demand" signal to the node directly (a spare D1 mini input through an opto), or rely on the Mode A fall-back. Decision: ⟨to decide⟩.

## Reversal
Set Mode A and the system behaves exactly as today. Removing the changeover restores the original wiring (see the as-built/Evohome reversal document).
