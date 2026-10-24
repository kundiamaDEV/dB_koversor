# Practical Decibel Calculations: Six Worked Telecommunications Problems

**Topic:** applied calculation · **Level:** intermediate
**Last reviewed:** 2026-10-17

---

## How to read this article

Six problems of the kind that come up in real work, each solved step by step.
Every number is a **calculation example** derived from the stated inputs — not
a field measurement, not operator data, and not a specification of any
product. The inputs are plausible illustrative values chosen to demonstrate
the method; in real work you take them from datasheets and measurements.

All results were cross-checked against independent closed-form calculations.

---

## Problem 1 — Transmitter power at the antenna port

> A base station sector radio is rated **43 dBm**. It feeds the antenna through
> **20 m of coaxial cable** with a loss of **0.2 dB/m**, plus **2 connectors**
> at 0.1 dB each. What power actually reaches the antenna, in watts?

**Step 1 — Total the losses, in dB.**

```
Cable      : 20 m × 0.2 dB/m = 4.0 dB
Connectors : 2 × 0.1 dB      = 0.2 dB
Total loss                   = 4.2 dB
```

**Step 2 — Subtract from the absolute level.**

```
P_antenna = 43 − 4.2 = 38.8 dBm
```

Subtracting a dB value from a dBm level is valid: a loss is a ratio.

**Step 3 — Convert to watts.**

```
P_mW = 10^(38.8/10) = 7585.78 mW
P_W  = 7.58578 W
```

**Answer: 7.586 W reaches the antenna**, down from 19.95 W at the radio.

**Interpretation.** 4.2 dB of loss throws away **62 %** of the transmitted
power. That is why feeder runs are kept short and why low-loss cable is worth
its cost on tall towers.

---

## Problem 2 — Will the link close?

> A point-to-point link at **1800 MHz** over **5 km**. Transmitter **43 dBm**,
> transmit antenna **17 dBi**, receive antenna **2 dBi**, feeder losses
> **2 dB on each side**. The receiver needs **−90 dBm** minimum. Does it work,
> and with what margin?

**Step 1 — Free-space path loss.**

```
FSPL = 32.44 + 20 log₁₀(d_km) + 20 log₁₀(f_MHz)
     = 32.44 + 20 log₁₀(5) + 20 log₁₀(1800)
     = 32.44 + 13.98 + 65.11
     = 111.52 dB
```

**Step 2 — Add up the budget. Everything in dB; the level stays in dBm.**

| Element | Value | Running level |
|---|---|---|
| Transmitter power | 43 dBm | 43.00 dBm |
| Transmit feeder loss | − 2 dB | 41.00 dBm |
| Transmit antenna gain | + 17 dBi | 58.00 dBm |
| Free-space path loss | − 111.52 dB | −53.52 dBm |
| Receive antenna gain | + 2 dBi | −51.52 dBm |
| Receive feeder loss | − 2 dB | **−53.52 dBm** |

**Step 3 — Compare with the requirement.**

```
Margin = −53.52 − (−90) = 36.48 dB
```

**Answer: the link closes with about 36.5 dB of margin.**

**Interpretation.** 36 dB is a comfortable margin for a fixed link, leaving
room for rain fade, vegetation growth, antenna misalignment and ageing. Note
that the whole calculation was addition and subtraction — the reason
telecommunications works in decibels.

**Caveat worth stating:** FSPL assumes free space. Real paths add diffraction,
reflection and obstruction losses, which is why a real design applies a
propagation model and a fade margin rather than FSPL alone.

---

## Problem 3 — Noise floor and signal-to-noise ratio

> A receiver has a **20 MHz** channel bandwidth and a noise figure of
> **5 dB**. The received signal is **−85 dBm**. What is the signal-to-noise
> ratio?

**Step 1 — Thermal noise floor.** At approximately 290 K, the thermal noise
power spectral density is **−174 dBm/Hz**.

```
N_thermal = −174 + 10 log₁₀(20 000 000)
          = −174 + 73.01
          = −100.99 dBm
```

**Step 2 — Add the receiver's noise figure.**

```
N_receiver = −100.99 + 5 = −95.99 dBm
```

**Step 3 — Signal-to-noise ratio.**

```
SNR = −85 − (−95.99) = 10.99 dB
```

**Answer: about 11 dB of SNR.**

**Interpretation.** Roughly 11 dB is enough for a moderate modulation scheme
such as 16-QAM with coding, and not enough for 256-QAM, which needs
substantially more. This is the calculation that connects received power to
achievable data rate.

Note the role of bandwidth: widening the channel to 40 MHz would raise the
noise floor by `10 log₁₀(2) = 3.01 dB` and cost 3 dB of SNR for the same
received power. More bandwidth is not free.

---

## Problem 4 — Splitting a signal

> A distribution amplifier outputs **20 dBm** into a **1:4 splitter**. What
> does each output port deliver, ignoring the splitter's own insertion loss?

**Step 1 — Ideal split loss.**

```
Loss = 10 × log₁₀(1/4) = −6.0206 dB
```

**Step 2 — Apply it.**

```
P_port = 20 − 6.0206 = 13.9794 dBm
```

**Step 3 — In linear units, as a check.**

```
20 dBm = 100 mW
100 mW / 4 = 25 mW
25 mW → 10 log₁₀(25) = 13.9794 dBm       ✓
```

**Answer: 13.98 dBm (25 mW) per port.**

**Interpretation.** Splitting into `n` ways costs `10 log₁₀(n)` dB:

| Split | Ideal loss |
|---|---|
| 1:2 | 3.0103 dB |
| 1:4 | 6.0206 dB |
| 1:8 | 9.0309 dB |
| 1:16 | 12.0412 dB |

A real splitter adds insertion loss on top — typically a fraction of a dB to
a couple of dB, from the manufacturer's datasheet.

---

## Problem 5 — Converting a dBm reading to a voltage

> A spectrum analyser reads **−30 dBm** on a **50 Ω** input. What voltage would
> an oscilloscope show at the same point?

**Step 1 — Convert to power in watts.**

```
P_mW = 10^(−30/10) = 0.001 mW
P_W  = 1 × 10⁻⁶ W  (1 µW)
```

**Step 2 — Apply `V = √(P × R)`.**

```
V = √(1 × 10⁻⁶ × 50) = √(5 × 10⁻⁵) = 7.0711 × 10⁻³ V
  = 7.0711 mV (RMS)
```

**Step 3 — In dBV, if the report needs it.**

```
L_dBV = 20 log₁₀(0.0070711) = −43.0103 dBV
```

**Answer: 7.07 mV RMS, or −43.0103 dBV.**

**Two cautions that matter here:**

1. **This result depends entirely on the 50 Ω.** In 75 Ω the same −30 dBm would
   be 8.66 mV. The impedance is not optional. See
   [Power levels and impedance](06_power_levels_and_impedance.md).
2. **This is an RMS value.** An oscilloscope showing peak-to-peak for a sine
   wave would read `7.0711 × 2√2 = 20 mV` peak-to-peak.

---

## Problem 6 — Interfacing a console to an audio interface

> A mixing console outputs **+4 dBu** nominal. The interface accepts a maximum
> of **+6 dBV**. How much headroom is there, and what happens if you instead
> connect consumer gear at **−10 dBV**?

**Step 1 — Put both on the same scale.**

```
+4 dBu = 4 − 2.213966 = 1.786034 dBV
```

**Step 2 — Headroom.**

```
6 − 1.786034 = 4.213966 dB
```

**Answer to the first part: about 4.21 dB of headroom.** No clipping.

**Step 3 — The consumer case.**

```
Professional nominal : +4 dBu  = +1.786034 dBV
Consumer nominal     : −10 dBV
Difference           = 11.786034 dB
```

**Answer to the second part: consumer equipment runs 11.79 dB lower.** Feeding
a consumer output into an input expecting professional level gives a signal
about 12 dB too quiet, which you must make up with gain — adding that much
noise along the way. The reverse connection risks overloading the input.

**Interpretation.** The intuitive "difference of 14" from comparing +4 with
−10 is wrong, because the two numbers are on different scales. The true figure
is 11.79 dB. See [dBV vs dBu](04_dBV_vs_dBu.md).

---

## Summary of the techniques used

| Technique | Problems | Rule |
|---|---|---|
| Subtracting losses from an absolute level | 1, 2, 4 | `dBm − dB = dBm` |
| Converting dBm to watts | 1, 4, 5 | `P_mW = 10^(dBm/10)` |
| Totalling a link budget | 2 | Add all gains and losses in dB |
| Bandwidth scaling of noise | 3 | `10 log₁₀(B)` |
| Split loss | 4 | `10 log₁₀(1/n)` |
| Power to voltage | 5 | `V = √(P·R)` — impedance required |
| Changing voltage reference | 6 | `dBV = dBu − 2.213966` |

---

## Doing these in the app

**dB Konversor** handles the unit conversions in each problem: `dBm → W`
(problems 1, 4, 5), `dBm → dBV` with impedance (problem 5), and
`dBu → dBV` (problem 6). The formula panel shows each step applied, which is
useful when you want to record the method in a report and not just the number.

The dB **arithmetic** itself — totalling a link budget, scaling by bandwidth —
is addition and subtraction you do yourself; and for a relative ratio against
a reference you choose, the `dB` unit with its reference field does exactly
that.

---

## References and further reading

- **Friis transmission equation** — the physical basis of free-space path loss.
- **ITU-R P-series** recommendations on radiowave propagation, for models
  beyond free space.
- **ITU-R V.574**, *Use of the decibel and the neper in telecommunications*.
- Thermal noise: `N = kTB`, giving −174 dBm/Hz at approximately 290 K.
- [dBm to watts](01_dBm_to_Watts.md) · [Watts to dBm](02_Watts_to_dBm.md)
- [dBm vs dBW](03_dBm_vs_dBW.md) · [dBV vs dBu](04_dBV_vs_dBu.md)
- [Decibels in telecommunications](05_decibels_in_telecommunications.md)
- [Power levels and impedance](06_power_levels_and_impedance.md)
- [Common conversion mistakes](07_common_conversion_mistakes.md)

> **Note on the examples.** Every figure is a *calculation example* derived
> from the inputs stated in each problem. The inputs — 43 dBm transmitters,
> 0.2 dB/m cable, 17 dBi antennas, 5 dB noise figures, +4 dBu console levels —
> are plausible illustrative values representative of their domains, chosen to
> demonstrate the method. They are **not** measurements, not taken from any
> operator's network, and not specifications of any product. For real work,
> use the figures from your own equipment datasheets and measurements. The
> modulation-scheme remark in Problem 3 is a general order-of-magnitude
> orientation, not a figure from any specific standard's requirements table.
