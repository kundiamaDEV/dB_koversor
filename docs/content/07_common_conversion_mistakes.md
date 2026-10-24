# The Seven Most Common Decibel Conversion Mistakes

**Topic:** error prevention · **Level:** all levels
**Last reviewed:** 2026-10-17

---

## The problem

Decibel arithmetic looks simple — add, subtract, done. That simplicity hides a
set of errors that are easy to make, hard to notice, and expensive when they
reach a report or a design. Most of them are not arithmetic slips: they are
conceptual, which is why checking the calculation twice does not catch them.

Each mistake below is shown with the wrong result, the right result, and the
size of the error.

---

## 1. Using the factor 20 for power (or 10 for voltage)

**The mistake**

```
100 mW → "20 × log₁₀(100)" = 40 dBm       ✗
```

**The correction**

```
100 mW → 10 × log₁₀(100)   = 20 dBm       ✓
```

**Error: 20 dB — a factor of 100 in power.**

**Why it happens.** Both factors are in circulation and the choice looks
arbitrary. It is not:

| Quantity | Factor | Reason |
|---|---|---|
| Power (W, mW) | **10** | The decibel is defined on a power ratio |
| Voltage (V) | **20** | `P = V²/R`, and `log(V²) = 2 log(V)` |
| Current (A) | **20** | `P = I²R`, same reasoning |

**How to remember it:** the 20 exists only because of a square. If your
quantity is already a power, there is no square, so the factor is 10.

---

## 2. Adding two absolute levels

**The mistake**

```
20 dBm + 20 dBm = "40 dBm"                ✗
```

**The correction.** Convert to linear, add the powers, convert back:

```
20 dBm = 100 mW
100 mW + 100 mW = 200 mW
200 mW → 10 × log₁₀(200) = 23.0103 dBm    ✓
```

**Error: 17 dB — a factor of 50.**

**Why it happens.** Because subtracting dBm values *is* valid and gives a dB
ratio, and because adding a dB gain to a dBm level *is* valid. The invalid
operation is adding two **absolute** levels.

| Operation | Valid? | Result |
|---|---|---|
| `dBm − dBm` | **Yes** | A ratio in dB |
| `dBm + dB` | **Yes** | A new absolute level in dBm |
| `dBm − dB` | **Yes** | A new absolute level in dBm |
| `dBm + dBm` | **No** | Meaningless |

**The useful shortcut:** two **equal** powers combine to exactly **+3.0103 dB**.
So `20 dBm + 20 dBm = 23.0103 dBm`, which matches the full calculation above.

> **A caveat engineers should keep in mind:** this power addition assumes the
> two signals are *uncorrelated* (noise-like). Two coherent signals in phase
> add as voltages, giving +6 dB, not +3 dB. Power addition is the right default
> for independent sources; phase matters for coherent ones.

---

## 3. Confusing dBm with dBW

**The mistake**

```
"20 dBW is about 20 dBm"                  ✗
```

**The correction**

```
P_dBm = P_dBW + 30
20 dBW = 50 dBm                           ✓
```

**Error: 30 dB — a factor of 1000.**

**Why it happens.** The units look similar and both are absolute power levels.
The difference is only which power the scale calls zero: 1 mW for dBm, 1 W for
dBW. See [dBm vs dBW](03_dBm_vs_dBW.md).

**Sanity check:** dBm numbers are always **larger** by 30, because a milliwatt
is a smaller reference than a watt.

---

## 4. Comparing dBu and dBV directly

**The mistake**

```
"+4 dBu is below +6 dBV by 2 dB"          ✗
```

**The correction**

```
+4 dBu = 4 − 2.213966 = 1.786034 dBV
Headroom = 6 − 1.786034 = 4.213966 dB     ✓
```

**Error: 2.21 dB** — and, crucially, in the direction that *understates* your
margin here, and would *overstate* it in the opposite comparison.

**Why it happens.** Both are voltage levels with the factor 20, so they feel
interchangeable. They differ only in reference: 1 V for dBV, 0.775 V for dBu,
giving a constant offset of `20 × log₁₀(1/0.775) = 2.213966 dB`. See
[dBV vs dBu](04_dBV_vs_dBu.md).

---

## 5. Converting between power and voltage without the impedance

**The mistake**

```
"0 dBm is −13 dBV"                        ✗ (incomplete)
```

That is only true **in 50 Ω**. The complete picture:

| Impedance | 0 dBm in dBV |
|---|---|
| 8 Ω | −20.9691 dBV |
| 50 Ω | −13.0103 dBV |
| 75 Ω | −11.2494 dBV |
| 600 Ω | −2.2185 dBV |

**Error: up to 18.75 dB**, depending on how wrong the assumed impedance is.

**Why it happens.** Many tools silently assume 50 Ω. In RF that is usually
right; in audio it is usually wrong.

**The underlying reason:** power and voltage are different physical quantities,
linked by `P = V²/R`. The impedance cannot be eliminated. See
[Power levels and impedance](06_power_levels_and_impedance.md).

---

## 6. Averaging decibel values

**The mistake.** Two measurements, 0 dBm and 20 dBm:

```
(0 + 20) / 2 = "10 dBm"                   ✗
```

**The correction**

```
0 dBm  = 1 mW
20 dBm = 100 mW
Mean power = (1 + 100) / 2 = 50.5 mW
50.5 mW → 10 × log₁₀(50.5) = 17.0329 dBm  ✓
```

**Error: 7.03 dB — a factor of 5 in power.**

**Why it happens.** The arithmetic mean of logarithms is the logarithm of the
*geometric* mean, not of the arithmetic mean. The logarithmic average
systematically **underestimates** the true mean power, and the error grows
with the spread of the values.

**Rule:** to average powers, convert to linear, average, convert back. The
only case where averaging dB values is correct is when you genuinely want a
geometric mean — which is rare, and should be stated explicitly.

---

## 7. Expecting zero power to be 0 dB

**The mistake**

```
"0 W = 0 dBm"                             ✗
```

**The correction.** 0 dBm **is 1 mW**, by definition. Zero power is not
representable:

```
P_dBm = 10 × log₁₀(0) → −∞
```

**Why it happens.** In most scales, zero means nothing. In a logarithmic scale,
zero means "equal to the reference".

**What a correct tool does.** It rejects the input with an explanation. A tool
that returns `0`, `NaN` or `-Infinity` is propagating an invalid value into
your next calculation. dB Konversor refuses the conversion and says why —
`log₁₀(0)` is undefined — as does it for negative power, which has no physical
meaning for dissipated power.

---

## Bonus: the 3 dB rounding trap

`3 dB` is a *rounding* of `3.0103 dB`, and `2×` is a rounding of the factor
`1.9953`.

| Context | Is 3 dB good enough? |
|---|---|
| Mental estimate | Yes, excellent |
| A single calculation step | Usually yes |
| A 20-stage cascade | **No** — the error accumulates to 0.2 dB |
| A compliance report | **No** — use the exact value |

The same applies to `−3 dB ≈ half`: the exact factor is 0.5012.

---

## Summary table

| # | Mistake | Typical error | Correct approach |
|---|---|---|---|
| 1 | Factor 20 for power | 20 dB (×100) | 10 for power, 20 for voltage |
| 2 | Adding dBm values | up to 17 dB | Convert to linear, add, convert back; or +3.0103 dB for equal powers |
| 3 | dBm/dBW confusion | 30 dB (×1000) | `dBm = dBW + 30` |
| 4 | dBu/dBV compared directly | 2.21 dB | Apply the 2.213966 dB offset |
| 5 | Power↔voltage without impedance | up to 18.75 dB | `V = √(P·R)`; always state R |
| 6 | Averaging dB values | 7 dB in the example | Average in linear units |
| 7 | 0 W = 0 dBm | nonsensical | 0 dBm = 1 mW; zero power is not representable |

---

## How to catch these before they matter

Four habits, in order of usefulness:

1. **Round-trip the conversion.** Convert there and back. If you do not land on
   the value you started with, one direction is wrong. This single check would
   have caught a real 18.7 dB defect found in this very application during its
   October 2026 audit — the conversion `−110 dBm → dBV → dBm` returned
   −101 dBm instead of −110 dBm. See
   [`../AUDITORIA_INICIAL.md`](../AUDITORIA_INICIAL.md).

2. **Check against an anchor you know by heart.** 0 dBm = 1 mW. 30 dBm = 1 W.
   0 dBW = 30 dBm. 0 dBV = 1 V. If a result contradicts an anchor, stop.

3. **Check the order of magnitude independently.** Estimate with the +10 dB =
   ×10 and +3 dB ≈ ×2 rules. If the exact answer is not near the estimate,
   something is wrong by a factor of ten or more — which is the kind of error
   that matters.

4. **Always write the unit.** `43` is ambiguous; `43 dBm` is not. Most of the
   mistakes above begin as a missing unit label in a spreadsheet column.

---

## Doing it in the app

**dB Konversor** was built around these failure modes:

| Mistake | How the app addresses it |
|---|---|
| 1 — wrong factor | The formula panel shows which factor was applied |
| 3 — dBm/dBW | Both units are supported explicitly, so you convert instead of guessing |
| 4 — dBu/dBV | Both supported; the conversion is one tap |
| 5 — missing impedance | **Required** in exactly the conversions that need it, never silently defaulted |
| 7 — zero and negatives | Rejected with an explicit explanation, never `NaN` or `0` |

The app cannot prevent mistake 2 or 6 — adding or averaging levels is
something you do outside the tool — but knowing they exist is most of the
defence.

---

## References and further reading

- **ITU-R V.574**, *Use of the decibel and the neper in telecommunications*.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms*.
- [Decibels in telecommunications](05_decibels_in_telecommunications.md)
- [Power levels and impedance](06_power_levels_and_impedance.md)
- [Practical telecommunications examples](08_practical_telecommunications_examples.md)

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown. The error magnitudes are computed from the examples
> given, not observed in any particular organisation's work. The 18.7 dB
> defect referred to in the "round-trip" habit was found in this application's
> own source code and is documented, with reproducible evidence, in
> [`../AUDITORIA_INICIAL.md`](../AUDITORIA_INICIAL.md) and
> [`../evidence/`](../evidence/).
