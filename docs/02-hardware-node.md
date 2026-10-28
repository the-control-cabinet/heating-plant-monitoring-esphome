# 02 · Hardware: The OpenTherm Node

[← Back to README](../README.md)

## Parts
| Item | Detail |
|---|---|
| Controller | diymore **ESP8266 D1 mini** |
| OpenTherm interface | **DIYLESS Master OpenTherm Shield** (pins pre-fitted to the shield) |
| Power | 5 V USB supply (the shield takes **3V3** from the D1 mini) |
| Enclosure | 3D-printed (a found design didn't fit this board combination; see below) |
| Changeover | Relays per [doc 06](06-bdr91-and-changeover.md) (separate enclosure, mains rated) |

## Pin use (proven from the shield's PCB tracks)
| D1 mini pin | GPIO | Shield use |
|---|---|---|
| D1 | GPIO5 | OpenTherm **out** |
| D2 | GPIO4 | OpenTherm **in** |
| D4 | GPIO2 | Track present (likely a status LED) |
| D5 | GPIO14 | Optional DS18B20 footprint (left empty) |
| 3V3 / G | | Shield power and ground |

## Orientation: how it was proven
The shield has **no pin labels**, and a 3D-printed case suggested the opposite orientation. It was settled from the PCB:
1. One header row carries tracks at positions 3, 4 and 6, counting from one end. On the D1 mini's **TX, RX, D1, D2, D3, D4, G, 5V** row, that's **D1, D2, D4**, which match DIYLESS's documented OpenTherm pins (out = D1, in = D2).
2. The other row has one track at the end, **3V3**, at the same end as G.
3. The shield's sensor footprint (−, DQ, +) ties back to ground, D5 and 3V3.
4. **The flipped orientation implied by the case** would put OpenTherm on D0/D5, ground on D8, and **5 V into the shield's 3.3 V supply**: rejected.

Result: the D1 mini's **chip faces outwards**, its **USB side faces the shield**, and the USB socket and screw terminal leave at the **same end**. Check the USB socket's clearance (its metal shell is ground) and tape the shield's underside if close.

## Assembly
1. Flash and test the D1 mini on its own over USB first.
2. Push the shield's pre-fitted pins through the D1 mini in the proven orientation, then solder on the D1 mini's outer face (one pin at each end first, check square, then the rest).
3. Before powering, check continuity: shield power track ↔ 3V3, OpenTherm tracks ↔ D1/D2, ground ↔ G.

## Enclosure
The found case assumed a different board layout (chip facing the shield). Options: modify its mounting holes, or print a simple two-part box with one opening for both the USB and the screw terminal.
