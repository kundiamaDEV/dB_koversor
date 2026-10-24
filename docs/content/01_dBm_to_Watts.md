# How to Convert dBm to Watts (With Worked Examples)

**Topic:** power unit conversion · **Level:** introductory to intermediate
**Last reviewed:** 2026-10-17

---

## The problem

A datasheet says the transmitter output is **43 dBm**. The power supply
specification you are checking is in watts. Your site survey form asks for
watts. So: how many watts is 43 dBm?

This comes up constantly — radio datasheets, amplifier specifications,
regulatory limits and test reports mix the two units freely, and getting the
conversion wrong by a factor of ten is easy.

---

## The formula

dBm is a **power level referenced to 1 milliwatt**. The definition is:

```
P_dBm = 10 × log₁₀(P_mW)
```

Inverting it gives the conversion you need:

```
P_mW = 10^(P_dBm / 10)

P_W  = 10^(P_dBm / 10) / 1000
```

Two things to note before using it:

1. **The factor is 10, not 20.** The factor 20 belongs to voltage and current
   ratios, because power is proportional to the square of voltage. Using 20
   here doubles your answer in dB. See
   [Common conversion mistakes](07_common_conversion_mistakes.md).
2. **dBm is absolute, not relative.** Unlike plain dB, dBm names a specific
   power, because its reference (1 mW) is fixed by definition.

---

## Worked example: 43 dBm to watts

**Step 1 — Divide by 10.**

```
43 / 10 = 4.3
```

**Step 2 — Raise 10 to that power. This gives milliwatts.**

```
P_mW = 10^4.3 = 19 952.6 mW
```

**Step 3 — Divide by 1000 to get watts.**

```
P_W = 19 952.6 / 1000 = 19.9526 W
```

**Answer: 43 dBm ≈ 19.95 W**, or about 20 watts.

### Interpretation

43 dBm is a typical power level for a macro cell base station power amplifier
port. The "about 20 W" figure is the useful mental anchor: if someone tells
you a sector radio runs at 43 dBm, you should picture a 20 W device, not a 2 W
or 200 W one.

---

## Reference table

Every value below was produced by the dB Konversor conversion engine and
cross-checked against an independently derived closed form. The verification
output is in
[`../evidence/exemplos_verificados.txt`](../evidence/exemplos_verificados.txt).

| dBm | Milliwatts | Watts | Typical context |
|---|---|---|---|
| −100 dBm | 1 × 10⁻¹⁰ mW | 1 × 10⁻¹³ W | Near the sensitivity limit of a mobile receiver |
| −70 dBm | 1 × 10⁻⁷ mW | 1 × 10⁻¹⁰ W | Usable Wi-Fi signal |
| −30 dBm | 0.001 mW | 1 µW | Strong received signal |
| 0 dBm | 1 mW | 0.001 W | The reference point, by definition |
| 13 dBm | 19.9526 mW | 0.02 W | Bluetooth Class 1 |
| 20 dBm | 100 mW | 0.1 W | Wi-Fi client transmitter |
| 23 dBm | 199.526 mW | 0.2 W | Mobile handset uplink |
| 30 dBm | 1000 mW | 1 W | Exactly 1 watt |
| 37 dBm | 5011.87 mW | 5.01187 W | Small cell transmitter |
| 43 dBm | 19 952.6 mW | 19.9526 W | Macro base station sector |
| 50 dBm | 100 000 mW | 100 W | High-power transmitter |

### The two anchors worth memorising

| Anchor | Why it helps |
|---|---|
| **0 dBm = 1 mW** | The definition. Everything else follows from it |
| **30 dBm = 1 W** | Because 10·log₁₀(1000) = 30 exactly |

With those two, plus the rule that **+10 dB is ×10** and **+3 dB is roughly
×2**, you can estimate most conversions mentally:

```
43 dBm = 30 dBm + 10 dB + 3 dB
       ≈ 1 W × 10 × 2
       ≈ 20 W        (exact value: 19.95 W)
```

That mental estimate lands within 0.25 % of the exact answer.

---

## Common mistakes

| Mistake | Consequence | How to avoid it |
|---|---|---|
| Using `20 × log₁₀` instead of `10 × log₁₀` | The dB value doubles. 100 mW becomes "40 dBm" instead of 20 dBm | The factor 20 is for **voltage**, never for power |
| Forgetting the ÷1000 from mW to W | Answer is 1000× too large | Remember dBm is referenced to a **milli**watt |
| Treating dBm as a ratio | "The gain is 20 dBm" is meaningless | Gain is in **dB**; absolute power is in dBm |
| Adding dBm values to sum powers | 20 dBm + 20 dBm ≠ 40 dBm | Two equal powers combine to **+3 dB**, so 23.0103 dBm |
| Rounding 3.0103 dB to 3 dB in a long chain | Error accumulates across many stages | Fine for mental estimates; use the exact value for reports |

---

## Where this is used in practice

- **Link budgets.** Received power is calculated in dBm, then converted to
  watts only if a device specification demands it.
- **Regulatory compliance.** Transmit power limits are often published in
  watts or in dBm EIRP, and you need to compare them like for like.
- **Power supply sizing.** An amplifier's RF output in dBm, converted to
  watts, tells you the output power; combined with efficiency it tells you the
  DC power draw.
- **Lab measurements.** Spectrum analysers read in dBm; power meters often
  read in watts.

---

## Doing it without arithmetic errors

In the **dB Konversor** app: type the value, set the input unit to `dBm` and
the output unit to `W`. The result appears as you type, and the formula panel
shows the complete chain that was applied:

```
mW = 10^(dBm / 10)  |  W = mW / 1000
```

Seeing both steps matters when you are learning: it is the difference between
getting a number and understanding where it came from. The app works offline
and does not require an account.

---

## Verify it yourself

Every figure in this article is reproducible:

```powershell
dart run docs/evidence/gerar_exemplos.dart
```

That script runs the production conversion code and compares each result with
an independently derived closed form, so the numbers here are not transcribed
by hand.

---

## References and further reading

- **Definition of dBm:** IEEE Std 100, *The Authoritative Dictionary of IEEE
  Standards Terms* — dBm as power referenced to 1 mW.
- **ITU-R recommendations** use dBm and dBW extensively for transmitter power
  and field strength; see the ITU-R V-series on terminology and units.
- [dBm vs dBW: what the 30 dB difference means](03_dBm_vs_dBW.md)
- [Watts to dBm: the reverse conversion](02_Watts_to_dBm.md)
- [Power levels and impedance](06_power_levels_and_impedance.md)
- [`../MATRIZ_CONVERSOES.md`](../MATRIZ_CONVERSOES.md) — every conversion the
  app supports, with validity conditions

> **Note on the examples.** All numeric values here are *calculation examples*,
> computed from the formulas shown. They are not field measurements, and no
> operator data, test-house results or network statistics are claimed. The
> contexts in the table ("typical for a macro base station") are
> order-of-magnitude orientation, not specifications of any particular product.
