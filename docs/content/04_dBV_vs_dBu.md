# dBV vs dBu: The 2.2 dB That Catches Everyone

**Topic:** logarithmic voltage levels · **Level:** intermediate
**Last reviewed:** 2026-10-17

---

## The problem

A mixing console's nominal output is **+4 dBu**. The audio interface you are
feeding specifies its maximum input as **+6 dBV**. Do you have headroom, or are
you about to clip the input?

You cannot answer by comparing 4 with 6, because the two numbers are on
**different scales**. Converting correctly is what tells you whether you have
4.2 dB of headroom or are already over.

---

## Both are voltage levels; the reference differs

| Unit | Definition | Reference | 0 of the scale |
|---|---|---|---|
| **dBV** | `L_dBV = 20 × log₁₀(V)` | 1 volt | 0 dBV = 1 V |
| **dBu** | `L_dBu = 20 × log₁₀(V / 0.775)` | 0.775 volt | 0 dBu = 0.775 V |

### Why the factor is 20, not 10

Because these are **voltage** levels, and the decibel is fundamentally a power
ratio. Since `P = V²/R`, at constant impedance:

```
10 × log₁₀(P₂/P₁) = 10 × log₁₀(V₂²/V₁²) = 20 × log₁₀(V₂/V₁)
```

The 2 comes out of the square and multiplies the 10. This is the single most
important thing to keep straight: **10 for power, 20 for voltage**. See
[Common conversion mistakes](07_common_conversion_mistakes.md).

### Where 0.775 V comes from

Historically, 0 dBu is the voltage that dissipates 1 mW in a 600 Ω load — the
classic telephone and broadcast line impedance:

```
V = √(P × R) = √(0.001 × 600) = 0.774597 V
```

Rounded by convention to **0.775 V**. The `u` stands for *unloaded*: modern
audio equipment has high-impedance inputs, so the 600 Ω load that justified
the number is no longer there, but the voltage reference stuck.

> **A real and verifiable consequence.** Because 0.775 is a rounding of
> 0.774597, converting 1 mW in 600 Ω to dBu does **not** give exactly 0 dBu.
> dB Konversor returns **−0.004522 dBu**. That tiny offset is correct, not a
> bug — it is the difference between the rounded convention and the exact
> historical derivation.

---

## The conversion is a constant offset

Both scales are `20 × log₁₀` of a voltage. Only the reference differs, so the
difference between them does not depend on the signal level:

```
L_dBu − L_dBV = 20 × log₁₀(1 / 0.775) = 2.213966 dB
```

Therefore:

```
L_dBV = L_dBu − 2.213966
L_dBu = L_dBV + 2.213966
```

Usually quoted as **2.2 dB**. The exact value, to the precision dB Konversor
uses, is **2.213965949874 dB**.

**Memory aid:** a dBu number is always the **larger** of the two, because
0.775 V is a smaller reference than 1 V.

---

## Worked example: the headroom question

**Console output: +4 dBu. Interface maximum input: +6 dBV.**

Convert the console output to dBV:

```
L_dBV = 4 − 2.213966 = 1.786034 dBV
```

**+4 dBu = +1.786 dBV.**

Compare with the +6 dBV limit:

```
6 − 1.786034 = 4.213966 dB of headroom
```

**Answer: you have about 4.2 dB of headroom.** No clipping.

Had you compared the raw numbers (4 against 6) you would have concluded 2 dB
of headroom — understating your margin by more than half. In the opposite
direction, the same mistake would make you think you were safe when you were
clipping.

### Verify through volts

```
+4 dBu → V = 0.775 × 10^(4/20)  = 1.228292 V
+6 dBV → V = 10^(6/20)          = 1.995262 V
Ratio   = 1.995262 / 1.228292   = 1.6244
In dB   = 20 × log₁₀(1.6244)    = 4.2140 dB     ✓
```

Both routes agree, which is the check worth doing when a result matters.

---

## Reference table

Values produced by the dB Konversor engine
([`../evidence/exemplos_verificados.txt`](../evidence/exemplos_verificados.txt)).

| dBu | dBV | Volts | Context |
|---|---|---|---|
| +24 dBu | +21.786 dBV | 12.28 V | Clipping point of many pro consoles |
| +4 dBu | +1.786 dBV | 1.228 V | **Pro audio nominal level** |
| 0 dBu | −2.213966 dBV | 0.775 V | The dBu reference |
| +2.213966 dBu | 0 dBV | 1.000 V | The dBV reference |
| −7.786 dBu | −10 dBV | 0.3162 V | **Consumer line level** (−10 dBV) |
| −10 dBu | −12.214 dBV | 0.2451 V | |
| −60 dBu | −62.214 dBV | 0.775 mV | Microphone-level signal |

### The two nominal levels, side by side

| Standard | Nominal level | In dBu | In dBV | In volts |
|---|---|---|---|---|
| Professional | +4 dBu | +4 | +1.786 | 1.228 V |
| Consumer | −10 dBV | −7.786 | −10 | 0.3162 V |

The difference between professional and consumer line level is therefore
**11.786 dB**, not 14 dB as the "+4 versus −10" numbers suggest. That ~11.8 dB
is why connecting consumer gear to a professional input gives a quiet signal,
and the reverse risks overload.

---

## Interpretation: when the offset matters and when it does not

| Situation | Does the 2.2 dB matter? |
|---|---|
| Comparing two levels both in dBu | **No** — the offset cancels |
| Comparing a dBu figure with a dBV figure | **Yes, always** |
| Setting gain structure across pro and consumer equipment | **Yes** — plus the level difference above |
| Expressing a *gain* (a ratio) | No — gain is in plain dB; the reference is irrelevant |
| Converting either to power | The offset is not enough: you also need the **impedance** |

That last row is the one that trips people up. See
[Power levels and impedance](06_power_levels_and_impedance.md).

---

## Common mistakes

| Mistake | Consequence | How to avoid it |
|---|---|---|
| Comparing dBu and dBV numbers directly | 2.2 dB error, in the direction that hides a problem | Convert first; always |
| Using factor 10 instead of 20 | Voltage ratios halved in dB | 20 for voltage, 10 for power |
| Assuming 0 dBu = 0 dBV | They differ by 2.213966 dB | Different references |
| Thinking dBu means "dB unloaded, so no reference" | dBu has a precise reference: 0.775 V | The `u` refers to the absent 600 Ω load, not an absent reference |
| Converting dBu to dBm without an impedance | Mathematically impossible | Power needs `P = V²/R` |
| Assuming 0 dBu is exactly 1 mW in 600 Ω | It is 0.004522 dB away | 0.775 is a rounding of 0.774597 |
| Writing `dBV` as `dbv` or `DBV` | Looks careless in technical documents | `dBV`, `dBu`: lowercase `d`, uppercase `B` |

---

## Where this is used in practice

- **Gain structure** in recording and live sound: matching console outputs to
  interface or amplifier inputs.
- **Interfacing equipment classes:** consumer (−10 dBV) with professional
  (+4 dBu) gear, where the ~11.8 dB difference must be made up by gain.
- **Reading audio datasheets**, which may use either unit — sometimes both,
  in different sections of the same document.
- **Broadcast and installed audio**, where line levels are specified in dBu by
  convention.

---

## Doing it in the app

In **dB Konversor**, `dBu → dBV` and `dBV → dBu` need **no impedance**,
because both are voltage levels — only the reference changes. The app reflects
this: the impedance field does not appear for these conversions.

The formula panel shows the chain:

```
V = 0,775 × 10^(dBu / 20)  |  dBV = 20 × log10(V)
```

If you then convert either one to `W`, `mW`, `dBm` or `dBW`, the impedance
field appears — because at that point the conversion genuinely requires it.
That behaviour is not a nicety; it reflects the physics, and it is covered by
automated tests.

---

## References and further reading

- **IEC 60268** series, *Sound system equipment* — levels and reference
  voltages in audio equipment.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms*.
- **ITU-R BS-series** recommendations for broadcasting audio levels.
- [Power levels and impedance](06_power_levels_and_impedance.md)
- [Common conversion mistakes](07_common_conversion_mistakes.md)
- [Decibels in telecommunications](05_decibels_in_telecommunications.md)

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown. The "+4 dBu nominal" and "−10 dBV consumer" levels are
> widely used industry conventions, and the clipping figure of +24 dBu is an
> illustrative order of magnitude — not a specification of any particular
> console or interface. Always use the actual figures from your equipment's
> datasheet. No measurements are claimed.
