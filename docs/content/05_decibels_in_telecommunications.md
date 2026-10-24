# Decibels in Telecommunications: What They Are and Why Everything Uses Them

**Topic:** fundamentals · **Level:** introductory
**Last reviewed:** 2026-10-17

---

## The problem

A radio link involves a transmitter at 20 W, a cable that loses 60 % of the
power, an antenna that concentrates it 50-fold, a path that attenuates it by a
factor of 10¹¹, and a receiver that needs at least 10⁻¹³ W to work.

Doing that arithmetic in watts means multiplying and dividing numbers spanning
fifteen orders of magnitude. One misplaced decimal point and the answer is
meaningless — and you will not notice, because all the numbers look equally
implausible.

Decibels exist to make this tractable.

---

## The core idea: logarithms turn multiplication into addition

The decibel expresses a **ratio of powers** on a logarithmic scale:

```
Ratio in dB = 10 × log₁₀(P₂ / P₁)
```

Because `log(a × b) = log(a) + log(b)`, every multiplication in the chain
becomes an addition:

| In linear units | In decibels |
|---|---|
| × 2 | + 3.0103 dB |
| × 10 | + 10 dB |
| × 100 | + 20 dB |
| × 1000 | + 30 dB |
| ÷ 2 | − 3.0103 dB |
| ÷ 10 | − 10 dB |
| × 1 (no change) | 0 dB |

So the entire link above becomes a column of numbers you can add in your head.

### The values worth memorising

| dB | Power ratio | Mnemonic |
|---|---|---|
| 0 dB | 1.0 | no change |
| 1 dB | 1.2589 | ≈ +26 % |
| **3 dB** | **1.9953 ≈ 2** | **double** |
| 6 dB | 3.9811 ≈ 4 | quadruple |
| **10 dB** | **10** | exactly ten |
| 20 dB | 100 | |
| 30 dB | 1000 | |
| −3 dB | 0.5012 ≈ 0.5 | half |
| −10 dB | 0.1 | one tenth |

Note that **3 dB is not exactly a factor of 2**: the exact factor is 1.9953,
and the exact dB value for doubling is 3.0103 dB. The approximation is
excellent for estimates and inadequate for a 20-stage cascade.

---

## Relative dB versus absolute levels

This is the distinction that causes the most confusion, and it is simple once
stated:

| Kind | Example | Meaning |
|---|---|---|
| **Relative (dB)** | "The amplifier has 20 dB of gain" | A *ratio*. Says nothing about actual power |
| **Absolute (dBm, dBW)** | "The output is 43 dBm" | A *specific power*, because the reference is fixed |

A plain **dB** value is meaningless on its own: 20 dB of what, compared with
what? An **absolute** unit carries its reference in its name:

| Unit | Reference | Quantity |
|---|---|---|
| dBm | 1 mW | Power |
| dBW | 1 W | Power |
| dBV | 1 V | Voltage |
| dBu | 0.775 V | Voltage |
| dBi | isotropic radiator | Antenna gain |
| dBc | the carrier | Power relative to a carrier |

> **The rule that follows:** you may add and subtract dB freely from an
> absolute level — `43 dBm − 4 dB = 39 dBm` — but **adding two absolute levels
> is meaningless**. `43 dBm + 39 dBm` is not a power. See
> [Common conversion mistakes](07_common_conversion_mistakes.md).

---

## The 10-versus-20 rule

| Quantity | Factor | Why |
|---|---|---|
| **Power** (W, mW) | `10 × log₁₀` | The decibel is defined on power |
| **Voltage** (V) | `20 × log₁₀` | `P = V²/R`, and `log(V²) = 2·log(V)` |
| **Current** (A) | `20 × log₁₀` | `P = I²R`, same reasoning |

The factor 20 is not a different definition — it is the same definition applied
to a quantity that enters power as a square. Both assume the impedance is the
same at both points being compared. When it is not, the derivation needs the
impedances explicitly.

---

## Worked example: a complete link, in both systems

A radio link at 1800 MHz over 5 km.

### In linear units

| Stage | Factor | Running power |
|---|---|---|
| Transmitter | — | 20 W |
| Feeder cable | × 0.3981 | 7.9621 W |
| Transmit antenna | × 50.12 | 399.05 W (effective) |
| Free-space path | × 7.039 × 10⁻¹² | 2.809 × 10⁻⁹ W |
| Receive antenna | × 1.585 | 4.452 × 10⁻⁹ W |
| **Received power** | | **4.452 nW** |

### In decibels

| Stage | dB | Running level |
|---|---|---|
| Transmitter: 20 W | — | **43.0103 dBm** |
| Feeder cable | − 4 dB | 39.0103 dBm |
| Transmit antenna gain | + 17 dBi | 56.0103 dBm |
| Free-space path loss | − 111.52 dB | −55.51 dBm |
| Receive antenna gain | + 2 dBi | **−53.51 dBm** |

Both give the same answer: −53.51 dBm is 4.452 × 10⁻⁹ W. But the second column
is addition and subtraction of numbers between 2 and 112, which you can check
by eye. The first column is a chain of multiplications across twelve orders of
magnitude, where an error is invisible.

**That is the whole reason telecommunications uses decibels.**

The free-space path loss came from the standard formula:

```
FSPL(dB) = 32.44 + 20 × log₁₀(d_km) + 20 × log₁₀(f_MHz)
         = 32.44 + 20 × log₁₀(5) + 20 × log₁₀(1800)
         = 111.52 dB
```

---

## Interpretation: reading dB values fluently

| Level | What it tells you |
|---|---|
| −30 dBm | Very strong received signal; possibly too strong for a sensitive receiver |
| −70 dBm | Comfortable Wi-Fi or mobile signal |
| −90 dBm | Usable but marginal |
| −110 dBm | At or below the sensitivity of many receivers |
| −174 dBm/Hz | Thermal noise floor at room temperature — a physical limit, not an equipment limitation |

That last figure is worth knowing: it sets the absolute best any receiver can
do. In a 20 MHz channel, the thermal noise power is:

```
N = −174 + 10 × log₁₀(20 000 000) = −174 + 73.01 = −100.99 dBm
```

So a −85 dBm signal in a 20 MHz channel has a signal-to-noise ratio of about
16 dB before any receiver noise is added.

---

## Common mistakes

| Mistake | Consequence |
|---|---|
| Adding two absolute levels (dBm + dBm) | Meaningless result |
| Using factor 20 for power, or 10 for voltage | dB value doubled or halved |
| Treating 3 dB as exactly 2× in a long cascade | Accumulating error |
| Averaging dB values to average powers | Systematic underestimate |
| Comparing dBu with dBV directly | 2.2 dB error |
| Converting a voltage level to power without impedance | Not possible — needs `P = V²/R` |

---

## Where this is used in practice

- **Link budgets** for radio, satellite and microwave links.
- **Receiver sensitivity and noise figure** specifications.
- **Antenna gain** (dBi, dBd) and radiation patterns.
- **Cable and connector losses**, specified in dB per metre.
- **Filter responses**, where the −3 dB points define the bandwidth.
- **Signal-to-noise ratio**, carrier-to-noise ratio, and every quality metric
  in digital transmission.
- **Audio levels**, in dBu and dBV.

---

## Doing it in the app

**dB Konversor** handles both families:

- **Absolute conversions:** `dBm`, `dBW`, `W`, `mW` for power; `dBV`, `dBu`
  for voltage levels.
- **Relative dB:** choose `dB` as the input or output unit and the app asks for
  the reference, in the right unit, because a ratio without a reference has no
  absolute meaning. This is exactly the distinction this article is about, and
  the app enforces it rather than letting you skip it.

Each result shows the formula applied, so the 10-versus-20 factor is visible
in every conversion rather than hidden.

---

## References and further reading

- **ITU-R V.574**, *Use of the decibel and the neper in telecommunications*.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms*.
- **Friis transmission equation** — the physical basis of the free-space path
  loss formula used above.
- [dBm to watts](01_dBm_to_Watts.md) · [Watts to dBm](02_Watts_to_dBm.md)
- [dBm vs dBW](03_dBm_vs_dBW.md) · [dBV vs dBu](04_dBV_vs_dBu.md)
- [Power levels and impedance](06_power_levels_and_impedance.md)
- [Practical telecommunications examples](08_practical_telecommunications_examples.md)

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown. The link budget uses plausible illustrative figures
> (20 W transmitter, 17 dBi antenna, 4 dB feeder loss) chosen to demonstrate
> the method; they are not measurements from any real installation, and no
> operator or vendor data is claimed. The −174 dBm/Hz thermal noise figure is
> the standard value for approximately 290 K, from `10·log₁₀(kTB)`.
