# 14 · Cylinder Stratification and "Hot Water Available"

[← Back to README](../README.md)

With a strap-on NTC on each cylinder's **hot outlet** (top) and the Evohome **CS92** probe in the **lower** pocket (about a quarter of the way up), each Centre Store 250 L cylinder now has a top and a bottom temperature.

## What the two readings show

- **Between reheats, after a draw-off, the gap is large:** e.g. top 44.7 °C, bottom 13.8 °C (31 K) the morning after showers. Hot water floats; cold mains enters at the bottom, right at the CS92's pocket.
- **During a reheat** the coil (near the bottom) heats the lower water, which rises and mixes, and the gap closes.
- **Evohome's probe position** means it calls for heat once enough cold has come in, even with plenty of hot water still at the top: reheats are triggered by **volume used**.
- **Overnight standing loss** visible at the bottom probe: about 5 K over ~10 h.
- **A difference between cylinders** (the left's bottom peaked ~51 °C against ~56 °C on the right) is under investigation: either probe contact (heat-transfer paste added 11 Nov) or the cylinder's own stat cutting off before Evohome's 58 °C. The test: during a reheat, a relay still on while that cylinder stops warming means the cylinder stat has opened (dial range 1-5 = 30-70 °C, position 4 ≈ 60 °C).

## Estimating hot water available

Average temperature ≈ 0.25 × bottom (the quarter below the probe) + 0.75 × (bottom + top) / 2 (a linear gradient above it, the expected value when the hot/cold boundary could be anywhere) = **0.4 × top + 0.6 × bottom**.

Litres at 40 °C = 250 × (average − 12) / (40 − 12); a full cylinder at 58 °C ≈ 410 L at 40 °C (100%).

| Example (11 Nov, after showers) | Left | Right |
|---|---|---|
| Top / bottom | 44.7 / 13.8 °C | 49.3 / 15.2 °C |
| Average | 26.2 °C | 28.9 °C |
| Available | 127 L (31%) | 151 L (37%) |

**Limits:** after a draw-off the true boundary may be anywhere above the probe (±25% or so); the estimate is best after a reheat and near empty. Cold inlet fixed at 12 °C until the utility mains-water NTC can replace it. Tune `top_weight` if showers run lukewarm while it still shows 20-25%.

Package: [config/homeassistant/packages/dhw_hot_water_available.yaml](../config/homeassistant/packages/dhw_hot_water_available.yaml) · card: [dashboards/hot-water-available-card.yaml](../config/homeassistant/dashboards/hot-water-available-card.yaml)

![Hot water available card](images/hot-water-available-card-2026-11-11.png)

## CS92 heat-transfer paste

The pockets are larger than the probes, so the gap is air. A thin coat of paste on the probe (not packed into the pocket), pushed fully home and nudged against the wall, makes the probe follow the water more closely and quickly. The effect shows during a reheat, not at steady temperature: compare the rise against an earlier reheat.

## Centre Store settings (from the installation manual)

PRV / operating pressure **3.5 bar** · expansion vessel pre-charge **3.5 bar** (checked with the water side de-pressurised; 24 L for the 250 L) · expansion relief valve **6 bar** · T&P **90 °C / 10 bar**. Intermittent discharge from the expansion valve during reheats = vessel charge below 3.5 bar (the fault behind the tundish drips).
