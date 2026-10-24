# How to Convert Watts to dBm (With Worked Examples)

**Topic:** power unit conversion · **Level:** introductory to intermediate
**Last reviewed:** 2026-10-17

---

## The problem

You have an amplifier rated at **5 W**. The link budget spreadsheet you are
filling in works entirely in dBm, because that is the only way to add gains
and losses by simple arithmetic. How many dBm is 5 W?

This is the reverse of [dBm to watts](01_dBm_to_Watts.md), and it is the
direction you need far more often in system design — because once everything
is in dB, a cascade of amplifiers, cables, splitters and path losses becomes
addition instead of multiplication.

---

## The formula

```
P_dBm = 10 × log₁₀(P_mW)

P_dBm = 10 × log₁₀(P_W × 1000)
```

Equivalently, and often easier to reason about:

```
P_dBm = 10 × log₁₀(P_W) + 30
```

That `+30` is exactly the dBm-to-dBW offset, because
`10 × log₁₀(1000) = 30`. See [dBm vs dBW](03_dBm_vs_dBW.md).

### Validity condition that matters

`log₁₀(x)` is only defined for `x > 0`. Therefore:

- **0 W cannot be expressed in dBm.** As power tends to zero, the dBm value
  tends to minus infinity. There is no "0 dBm = 0 W" — in fact 0 dBm is 1 mW.
- **Negative power has no physical meaning** for dissipated power, so it is
  not convertible either.

A tool that returns `0`, `NaN` or `-Infinity` for these inputs is hiding a
problem. dB Konversor rejects them with an explicit message instead.

---

## Worked example: 5 W to dBm

**Step 1 — Convert watts to milliwatts.**

```
5 W × 1000 = 5000 mW
```

**Step 2 — Take the base-10 logarithm.**

```
log₁₀(5000) = 3.69897
```

**Step 3 — Multiply by 10.**

```
P_dBm = 10 × 3.69897 = 36.9897 dBm
```

**Answer: 5 W = 36.9897 dBm**, usually written as **37 dBm**.

### Interpretation

37 dBm is a common small-cell or indoor-coverage transmit power. Note that the
answer is *not* a round number: 5 W happens to sit at 36.9897 dBm because 5 is
not a power of ten. The convenient round values in dBm correspond to the
powers of ten in watts.

### The shortcut worth knowing

```
5 W = 10 W / 2
    → 40 dBm − 3.0103 dB
    = 36.9897 dBm
```

Because **halving power is −3.0103 dB** and 10 W is exactly 40 dBm.

---

## Reference table

Values produced by the dB Konversor engine, cross-checked against an
independent closed form
([`../evidence/exemplos_verificados.txt`](../evidence/exemplos_verificados.txt)).

| Watts | dBm | Note |
|---|---|---|
| 0.0001 W (0.1 mW) | −10 dBm | |
| 0.001 W (1 mW) | 0 dBm | The reference, by definition |
| 0.02 W (20 mW) | 13.0103 dBm | |
| 0.1 W (100 mW) | 20 dBm | Exact: 100 mW is 10² mW |
| 0.5 W | 26.9897 dBm | |
| 1 W | 30 dBm | Exact |
| 2 W | 33.0103 dBm | 1 W + 3.0103 dB |
| 5 W | 36.9897 dBm | The worked example |
| 20 W | 43.0103 dBm | |
| 100 W | 50 dBm | Exact: 10⁵ mW |

### Why the decimals are 0.0103 and 0.9897

They are not arbitrary. `log₁₀(2) = 0.30103`, so:

- doubling power adds `10 × 0.30103 = 3.0103 dB`
- halving power subtracts the same amount

Which is why **2 W = 33.0103 dBm** and **5 W = 36.9897 dBm** (since
`5 = 10/2`, so `40 − 3.0103`). The familiar "3 dB" is a rounding of 3.0103 dB.

---

## Why convert to dBm at all?

Because dB turns multiplication into addition. Consider a transmitter feeding
an antenna through a cable:

| Stage | In linear units | In dB |
|---|---|---|
| Transmitter: 20 W | 20 W | 43.0103 dBm |
| Cable: 20 m at 0.2 dB/m | × 0.398 | − 4 dB |
| **At the antenna** | **7.96214 W** | **39.0103 dBm** |

In linear units you must multiply by a loss factor. In dB you subtract 4.
With five or six stages, the dB approach is faster and far less error-prone.

Converting the final 39.0103 dBm back to watts gives **7.96214 W** — which you
can confirm with the reverse conversion.

---

## Common mistakes

| Mistake | Consequence | How to avoid it |
|---|---|---|
| Forgetting the ×1000 | 5 W computed as `10·log₁₀(5)` = 6.99 dBm, which is 30 dB too low | dBm is referenced to a **milli**watt, so convert to mW first — or use the `+30` form |
| Using `20 × log₁₀` | 5 W becomes "73.98 dBm" | Factor 20 is for voltage ratios |
| Expecting 0 W to give 0 dBm | 0 dBm is 1 mW, not zero power | Zero power is not representable in dB |
| Rounding 36.9897 to 37 and then subtracting again | Small errors accumulate | Keep full precision in intermediate steps; round only for presentation |
| Averaging dBm values | The arithmetic mean of dBm is not the dBm of the mean power | Convert to linear, average, convert back |

### The averaging trap, concretely

Two measurements, 0 dBm and 20 dBm:

- Wrong: `(0 + 20)/2 = 10 dBm` → 10 mW
- Right: `(1 mW + 100 mW)/2 = 50.5 mW` → **17.0329 dBm**

The difference is 7 dB — a factor of 5 in power. This matters whenever you
average received-signal measurements.

---

## Where this is used in practice

- **Link budgets**, as shown above: every element in dB, totals by addition.
- **Comparing datasheets** that mix units — one amplifier rated in watts,
  another in dBm.
- **Regulatory submissions**, where EIRP limits may be stated in dBm while the
  equipment is specified in watts.
- **Antenna and feeder calculations**, where losses are naturally in dB.

---

## Doing it in the app

In **dB Konversor**: set the input unit to `W` and the output to `dBm`. The
formula panel shows both steps:

```
mW = W × 1000  |  dBm = 10 × log10(mW)
```

Both directions are available, and the swap button reverses them in one tap —
useful for checking that a conversion round-trips back to where it started,
which is the simplest sanity check there is.

---

## References and further reading

- **Definition of dBm:** IEEE Std 100, *The Authoritative Dictionary of IEEE
  Standards Terms*.
- **ITU-R V-series** recommendations on units and terminology.
- [dBm to watts: the reverse conversion](01_dBm_to_Watts.md)
- [dBm vs dBW](03_dBm_vs_dBW.md)
- [Common conversion mistakes](07_common_conversion_mistakes.md)
- [Practical telecommunications examples](08_practical_telecommunications_examples.md)

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown. The cable loss figure of 0.2 dB/m is a plausible
> illustrative value used to demonstrate the arithmetic — real cable loss
> depends on cable type and frequency and must be taken from the
> manufacturer's datasheet. No field measurements or operator data are claimed.
