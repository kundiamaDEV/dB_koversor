# Power Levels and Impedance: Why dBm Cannot Become dBV Without It

**Topic:** power and voltage relationship · **Level:** intermediate
**Last reviewed:** 2026-10-17

---

## The problem

Your spectrum analyser reads **0 dBm**. The oscilloscope beside it, measuring
the same point, reads a voltage. Your report needs the level in **dBV**. So:
what is 0 dBm in dBV?

The honest answer is: **the question is incomplete.** Without knowing the
impedance, it has no single answer. In 50 Ω it is −13.0103 dBV. In 600 Ω it is
−2.2185 dBV. In 8 Ω it is −20.9691 dBV. All three are correct.

This is not a limitation of any tool. It is physics.

---

## Why the impedance is indispensable

dBm measures **power**. dBV measures **voltage**. These are different physical
quantities, related through the load:

```
P = V² / R        (Joule's law for a resistive load)
```

Rearranged for voltage:

```
V = √(P × R)
```

The impedance `R` appears explicitly. There is no way to eliminate it: the
same power produces different voltages across different loads, and the same
voltage delivers different powers into different loads.

### An analogy that holds

Asking "how many volts is 1 milliwatt?" is like asking "how fast is 100
joules?" — you need the mass before kinetic energy gives you a speed. Power
alone does not determine voltage any more than energy alone determines
velocity.

---

## The formulas

### From power to voltage level

```
V      = √(P_W × R)
L_dBV  = 20 × log₁₀(V)
L_dBu  = 20 × log₁₀(V / 0.775)
```

These can be combined into single-step forms, which are algebraically
equivalent and avoid the square root entirely:

```
L_dBV = 10 × log₁₀(P_W × R)
L_dBu = 10 × log₁₀(P_W × R / 0.775²)
```

> **Why this matters beyond elegance.** These single-step forms are exactly
> what the dB Konversor test suite uses to verify the app's two-step
> calculation. Because the reference path contains no square root, an error in
> the app's square root cannot hide. During the October 2026 audit this caught
> a real defect: a hand-written iterative square root that was wrong by
> 18.7 dB at −120 dBm. See
> [`../AUDITORIA_INICIAL.md`](../AUDITORIA_INICIAL.md).

### From voltage level to power

```
V     = 10^(L_dBV / 20)           or   0.775 × 10^(L_dBu / 20)
P_W   = V² / R
```

Equivalently, again without a square root:

```
P_W = 10^(L_dBV / 10) / R
```

---

## Worked example: 0 dBm in three different impedances

0 dBm = 1 mW = 0.001 W, by definition.

### In 50 Ω — radio frequency

```
V     = √(0.001 × 50) = √0.05 = 0.2236068 V
L_dBV = 20 × log₁₀(0.2236068) = −13.0103 dBV
```

Or in one step: `10 × log₁₀(0.001 × 50) = 10 × log₁₀(0.05) = −13.0103 dBV`.

### In 600 Ω — classic audio line

```
V     = √(0.001 × 600) = 0.7745967 V
L_dBV = −2.2184874 dBV
```

### In 8 Ω — loudspeaker

```
V     = √(0.001 × 8) = 0.0894427 V
L_dBV = −20.9691 dBV
```

### The three answers, side by side

| Impedance | Voltage for 1 mW | Level in dBV | Context |
|---|---|---|---|
| 8 Ω | 0.0894427 V | −20.9691 dBV | Loudspeaker |
| 50 Ω | 0.2236068 V | −13.0103 dBV | RF systems, test equipment |
| 75 Ω | 0.2738613 V | −11.2494 dBV | Video, cable TV, antenna feeds |
| 600 Ω | 0.7745967 V | −2.2185 dBV | Classic audio and telephony lines |

**Spread: 18.75 dB** for the same power. Which is why no tool can convert
between these families without being told the impedance.

---

## The cost of assuming the wrong impedance

Many calculators silently assume 50 Ω. If the real system is 75 Ω:

```
Error = 10 × log₁₀(75 / 50) = 1.7609 dB
```

A 1.76 dB error. Small enough to go unnoticed in a report; large enough to
matter in a compliance measurement or a 40 % power discrepancy.

Between 50 Ω and 600 Ω the error would be `10 × log₁₀(600/50) = 10.79 dB` — a
factor of twelve in power.

> **This is why dB Konversor asks rather than assumes.** The impedance field
> appears only in conversions that genuinely need it — and in those, it is
> required rather than silently defaulted.

---

## The common impedances and where they come from

| Impedance | Used in | Why this value |
|---|---|---|
| **50 Ω** | RF, test equipment, antennas | Compromise between minimum loss (~77 Ω) and maximum power handling (~30 Ω) in coaxial cable |
| **75 Ω** | Video, cable TV, satellite IF | Close to the minimum-attenuation value for coaxial cable |
| **600 Ω** | Legacy telephony and audio lines | Historical twisted-pair telephone line impedance; origin of the dBu reference |
| **8 Ω, 4 Ω, 16 Ω** | Loudspeakers | Practical voice-coil impedance |
| **High-Z (10 kΩ+)** | Modern audio inputs | Voltage-transfer interfacing, not power transfer |

### A caveat about modern audio

In modern audio, signals are transferred as **voltage** into high-impedance
inputs, and almost no power flows. Converting a dBu level to dBm is then
largely an academic exercise: the 600 Ω figure is a historical convention,
not the actual load. Asking "how many dBm is +4 dBu?" is meaningful in a
600 Ω line, and misleading for a modern console feeding a 10 kΩ input.

This is worth knowing precisely because the conversion is available: a tool
can compute it, but only you can judge whether it means anything in your
system.

---

## Worked example: amplifier power to speaker voltage

An amplifier delivers **100 W into 8 Ω**. What is the voltage?

```
V = √(100 × 8) = √800 = 28.2843 V
```

And in dBV: `20 × log₁₀(28.2843) = 29.0309 dBV`.

For **1 W into 8 Ω** (a common sensitivity reference):

```
V = √(1 × 8) = 2.8284 V  →  9.0309 dBV
```

The 20 dB difference between 1 W and 100 W is exactly as expected:
`10 × log₁₀(100) = 20 dB`.

---

## Interpretation: when impedance matters and when it does not

| Conversion | Impedance needed? | Why |
|---|---|---|
| dBm ↔ W, mW, dBW | **No** | All are power; the load is irrelevant |
| dBV ↔ dBu | **No** | Both are voltage; only the reference differs |
| dB (ratio) between two points | **No**, if the impedance is the same at both | The impedance cancels in the ratio |
| dBm ↔ dBV or dBu | **Yes, always** | Crossing between power and voltage |
| W, mW, dBW ↔ dBV or dBu | **Yes, always** | Same crossing |

The third row carries a hidden assumption worth stating: a voltage gain in dB
equals the power gain in dB **only if** the input and output impedances are
equal. In an impedance-transforming stage they differ, and the full derivation
needs both impedances:

```
Gain_dB = 10 × log₁₀(P_out/P_in) = 20 × log₁₀(V_out/V_in) + 10 × log₁₀(R_in/R_out)
```

---

## Common mistakes

| Mistake | Consequence | How to avoid it |
|---|---|---|
| Assuming 50 Ω everywhere | Up to 18.75 dB error in audio systems | Check the actual system impedance |
| Using a calculator that assumes silently | Error you never see | Use a tool that asks |
| Using `R = 0` or a negative value | Division by zero; meaningless | Impedance must be positive and finite |
| Applying `P = V²/R` to a reactive load | Overstates real power | The formula assumes a **resistive** load |
| Mixing peak and RMS voltage | 3 dB error for a sine wave | `P = V²/R` requires **RMS** voltage |
| Treating speaker impedance as exact | Nominal 8 Ω varies with frequency | Nominal values are for calculation, not measurement |

### The RMS point, concretely

For a sine wave, `V_peak = √2 × V_RMS`. Using peak voltage in `P = V²/R`
overstates power by a factor of 2 — exactly 3.0103 dB. Every conversion in
this article, and in the app, assumes **RMS** values.

### The reactive load point

`P = V²/R` gives the power dissipated in a **resistance**. In a load with
reactance (a real loudspeaker, a mismatched antenna), the apparent power
`V²/|Z|` is larger than the real power, by the power factor. The app assumes a
purely resistive load; for reactive loads, these results are an upper bound on
real power, not the real power itself.

---

## Where this is used in practice

- **Bridging test equipment**: converting a spectrum analyser's dBm reading to
  the voltage an oscilloscope would show at the same point.
- **Antenna and feeder measurements**, in 50 Ω or 75 Ω.
- **Audio system design**, where legacy 600 Ω figures meet modern
  high-impedance inputs.
- **Amplifier and loudspeaker matching**, where voltage swing and power rating
  must both be checked.
- **Compliance measurement**, where the reference impedance is specified by
  the standard and using another invalidates the result.

---

## Doing it in the app

In **dB Konversor**, the impedance field appears **only** for conversions that
cross between power and voltage — and in those, it is required. A default of
50 Ω is pre-filled for convenience, and you can change it to 75, 600, 8 or any
positive value.

The formula panel shows the complete chain, so the role of the impedance is
visible:

```
mW = 10^(dBm / 10)  |  V = √(P × R)  |  dBV = 20 × log10(V)
```

Conversions that do **not** need the impedance — `dBm → W`, `dBu → dBV` — do
not show the field at all. That behaviour is enforced by automated tests,
because the distinction is the technical heart of the tool.

---

## References and further reading

- **Joule's law** / Ohm's law for resistive loads: `P = V²/R = I²R = VI`.
- **IEC 60268** series, *Sound system equipment*, on audio levels and
  impedances.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms*.
- [dBV vs dBu](04_dBV_vs_dBu.md)
- [Common conversion mistakes](07_common_conversion_mistakes.md)
- [`../MATRIZ_CONVERSOES.md`](../MATRIZ_CONVERSOES.md) — the exact rule the app
  uses to decide when impedance is required

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown, assuming purely resistive loads and RMS values. The
> impedance values (50, 75, 600, 8 Ω) are standard nominal figures used for
> calculation; real components deviate from nominal, and reactive loads require
> the power factor. No measurements are claimed.
