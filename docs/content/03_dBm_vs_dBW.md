# dBm vs dBW: Why They Differ by Exactly 30 dB

**Topic:** logarithmic power units · **Level:** introductory to intermediate
**Last reviewed:** 2026-10-17

---

## The problem

An ITU document gives a satellite EIRP as **50 dBW**. The terminal datasheet on
your desk gives receiver figures in **dBm**. A colleague writes "17 dBW" in one
column and "47 dBm" in another and says they are the same value — are they?

They are. And the reason is a single constant that is worth never having to
look up again.

---

## Both units are power levels; only the reference differs

| Unit | Definition | Reference | 0 of the scale means |
|---|---|---|---|
| **dBm** | `P_dBm = 10 × log₁₀(P_mW)` | 1 milliwatt | 0 dBm = 1 mW |
| **dBW** | `P_dBW = 10 × log₁₀(P_W)` | 1 watt | 0 dBW = 1 W |

Both are **absolute** power levels — unlike plain dB, which is a ratio and
means nothing without a stated reference. The only difference between them is
which power the scale calls "zero".

---

## Deriving the 30 dB offset

Since `1 W = 1000 mW`:

```
P_dBm = 10 × log₁₀(P_mW)
      = 10 × log₁₀(1000 × P_W)
      = 10 × log₁₀(1000) + 10 × log₁₀(P_W)
      = 30 + P_dBW
```

Because `log₁₀(1000) = 3` exactly, the offset is **exactly 30 dB** — not
29.9 or 30.1. It is an exact consequence of the metric prefix *milli*.

```
P_dBm = P_dBW + 30
P_dBW = P_dBm − 30
```

**This is the whole conversion.** No logarithms, no exponentials: add or
subtract 30.

---

## Worked example: 50 dBm expressed in dBW

```
P_dBW = 50 − 30 = 20 dBW
```

Check it by going through linear units:

```
50 dBm = 10^(50/10) mW = 100 000 mW = 100 W
20 dBW = 10^(20/10) W  = 100 W            ✓
```

Both routes give 100 W, as they must.

### Worked example: a 200 W satellite transponder

```
P_dBW = 10 × log₁₀(200) = 10 × 2.30103 = 23.0103 dBW
P_dBm = 23.0103 + 30    = 53.0103 dBm
```

**200 W = 23.0103 dBW = 53.0103 dBm.**

---

## Reference table

Values produced by the dB Konversor engine and cross-checked against an
independent closed form
([`../evidence/exemplos_verificados.txt`](../evidence/exemplos_verificados.txt)).

| Watts | dBW | dBm | Context |
|---|---|---|---|
| 0.001 W | −30 dBW | 0 dBm | The dBm reference point |
| 1 W | 0 dBW | 30 dBm | The dBW reference point |
| 10 W | 10 dBW | 40 dBm | |
| 20 W | 13.0103 dBW | 43.0103 dBm | Macro base station sector |
| 50.1187 W | 17 dBW | 47 dBm | The "same value, two columns" case |
| 100 W | 20 dBW | 50 dBm | |
| 200 W | 23.0103 dBW | 53.0103 dBm | Satellite transponder scale |
| 1000 W | 30 dBW | 60 dBm | |

Note the symmetry worth remembering: **0 dBW = 30 dBm** and
**−30 dBW = 0 dBm**.

---

## Which unit is used where

This is convention, not physics — but following the convention of your field
avoids confusion.

| Domain | Usual unit | Why |
|---|---|---|
| Mobile and Wi-Fi radio, RF test equipment | **dBm** | Signal levels are small; dBm keeps numbers in a convenient range (−120 to +50) |
| Satellite links, EIRP, broadcast transmitters | **dBW** | Powers are large; dBW avoids carrying "+30" everywhere |
| ITU-R and ITU-T documents | **dBW** commonly | Established in international radio regulation |
| Receiver sensitivity, noise floor | **dBm** | Values are strongly negative; dBm is the norm |
| Audio and professional sound | neither — **dBu/dBV** | Audio works in voltage levels, not power. See [dBV vs dBu](04_dBV_vs_dBu.md) |

**Practical rule:** if the numbers come out between −120 and +60, dBm reads
naturally. If they come out between −30 and +90, dBW does. Both are correct;
mixing them in one table without labels is what causes errors.

---

## Interpretation: what a 30 dB mistake costs

Getting this offset wrong is not a rounding error — it is a **factor of
1000**:

| Stated | If the unit is misread | Actual ratio |
|---|---|---|
| 20 dBW (= 100 W) | read as 20 dBm (= 0.1 W) | 1000× too small |
| 43 dBm (≈ 20 W) | read as 43 dBW (≈ 20 kW) | 1000× too large |

In a link budget, a 30 dB error is the difference between a working link and
one that either does not close at all or saturates the receiver front end. In
a regulatory filing, it is the difference between compliance and a transmitter
a thousand times over the limit.

---

## Common mistakes

| Mistake | Consequence | How to avoid it |
|---|---|---|
| Using 3 dB instead of 30 dB | Factor of 2 instead of 1000 | The offset comes from `10·log₁₀(1000)`, not `log₁₀(2)` |
| Subtracting when you should add | 1000× error in the wrong direction | dBm numbers are always **larger** by 30, because a milliwatt is a smaller reference |
| Writing "dBw" or "dBW" inconsistently | Ambiguity in documents | The `W` is capital: `dBW`. Likewise `dBm` has a lowercase `m` |
| Treating dBW as a ratio | "The gain is 10 dBW" is meaningless | Gain is in plain **dB**; dBW is an absolute power |
| Assuming dBW relates to dBV by 30 dB too | Wrong: dBV is a **voltage** level | Power-to-voltage conversion needs impedance. See [Power levels and impedance](06_power_levels_and_impedance.md) |

> **The last one is the subtle one.** The +30 shortcut works between dBm and
> dBW because both are power referenced to a power. It does **not** extend to
> dBV or dBu, which are voltage levels. There is no fixed offset between dBm
> and dBV — it depends on the impedance.

---

## Where this is used in practice

- **Satellite link budgets.** EIRP and G/T figures in ITU documents are
  usually in dBW, while modem specifications are in dBm.
- **Broadcast transmitter specifications**, typically in dBW or kW.
- **EIRP calculations.** A 43 dBm transmitter with a 17 dBi antenna gives
  60 dBm EIRP, which is 30 dBW — the form a regulator may expect.
- **Cross-checking documents** from different sources, which is exactly when
  the 30 dB slip happens.

---

## Doing it in the app

**dB Konversor** supports `dBW` directly, alongside `dBm`, `W`, `mW`, `dBV`,
`dBu` and `dB`. Select `dBW` as the input unit and `dBm` as the output — or any
other combination — and the formula panel shows the chain applied:

```
mW = 10^((dBW + 30) / 10)  |  dBm = 10 × log10(mW)
```

The swap button reverses the direction in one tap, which makes the ±30
symmetry visible rather than something to memorise.

> **Note on this unit's history in the app.** `dBW` was added during the
> October 2026 technical audit, after it was identified as a gap for
> broadcast and satellite users. It is covered by 24 dedicated automated
> tests, including a check that the dBm−dBW offset is exactly 30 dB across the
> full range from −90 to +90 dBW.

---

## References and further reading

- **ITU-R V.574** and the ITU-R V-series on the use of the decibel and of the
  neper in telecommunication.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms* —
  definitions of dBm and dBW.
- [dBm to watts](01_dBm_to_Watts.md)
- [Watts to dBm](02_Watts_to_dBm.md)
- [Decibels in telecommunications](05_decibels_in_telecommunications.md)
- [Practical telecommunications examples](08_practical_telecommunications_examples.md)

> **Note on the examples.** All values are *calculation examples* derived from
> the formulas shown. The "200 W transponder" and "50 dBW EIRP" figures are
> illustrative magnitudes chosen to be representative of the domain; they are
> not taken from any specific satellite, operator filing or product datasheet,
> and no measurement data is claimed.
