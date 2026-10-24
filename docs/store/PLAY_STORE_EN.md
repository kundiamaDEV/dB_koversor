# Google Play listing — English (en-US)

**App:** dB Konversor
**Package:** `ao.kundiama.dbkonversor`
**Date:** 2026-10-17

> Character limits (verified with [`verificar_limites.py`](verificar_limites.py)):
> app name 30, short description 80, full description 4000.

---

## 1. App name (max 30)

```
dB Konversor
```

**12 characters.** The name is kept identical across all markets: it is the
brand, and a single name makes the app findable by people who hear about it in
another language.

---

## 2. Short description (max 80)

```
dBm, dBW, W, dBV and dBu converter with formulas. Offline, no ads.
```

**66 characters.**

Alternatives considered:

| Text | Chars | Assessment |
|---|---|---|
| `dBm, dBW, W, dBV and dBu converter with formulas. Offline, no ads.` | 66 | **Recommended.** Unit symbols first — that is what people type |
| `Convert dBm to watts, dBW, dBV and dBu. Shows every formula step.` | 65 | Strong on the differentiator, weaker on symbol coverage |
| `Decibel calculator for RF, telecom and audio engineers. Works offline.` | 70 | Better for the audience, worse for search intent |

---

## 3. Full description (max 4000)

```
dB Konversor converts the power units and logarithmic levels used every day in
telecommunications, electronics, RF and audio.

Type a value, pick the input and output units, and the result appears
instantly. No ads, no account, no internet connection.


SUPPORTED UNITS

• dBm — power referenced to 1 mW
• dBW — power referenced to 1 W
• W — watt
• mW — milliwatt
• dBV — voltage level referenced to 1 V
• dBu — voltage level referenced to 0.775 V
• dB — logarithmic ratio, against a reference you supply


WHAT YOU CAN CALCULATE

• dBm to watts and watts to dBm
• dBm to dBW and dBW to dBm
• dBV to dBu and dBu to dBV
• Power to voltage level, given the impedance (50 Ω, 75 Ω, 600 Ω, 8 Ω or your
  own)
• Gains and losses in dB, against a reference of your choice


THE FORMULA IS ALWAYS VISIBLE

Every result comes with the formula that produced it, including every
intermediate step. Converting dBm to dBV shows the whole chain:

mW = 10^(dBm / 10)  |  V = √(P × R)  |  dBV = 20 × log10(V)

That is what makes this a study tool and not just a number generator. If you
are learning, you see the path. If you already know it, you can confirm the
calculation is the one you expect.


IMPEDANCE ASKED ONLY WHEN IT MATTERS

Converting power to a voltage level requires the impedance, because
V = √(P × R). Converting dBm to watts does not. The app asks for impedance
only in the conversions that genuinely need it, instead of demanding it every
time or silently assuming 50 Ω.


HISTORY KEPT ON YOUR PHONE

Your last 50 conversions are saved with their date so you can look them up
later. They stay on your device, you can delete them whenever you want, and
they are never sent anywhere.


WORKS WITHOUT INTERNET

The published version does not even request network permission. Every
calculation runs on your phone. It works at the top of a tower, in a basement,
in a lab or on a plane.


WHO IT IS FOR

• Telecommunications, electronics and electrical engineering students
• Teachers explaining the link between linear and logarithmic scales
• Network installation and maintenance technicians
• RF and telecommunications engineers
• Sound technicians and audio engineers
• Amateur radio operators


ABOUT THE ACCURACY

Conversions are covered by an automated test suite whose expected values are
derived independently of the implementation under test. Calculations use
double precision, and when a value falls outside the representable range the
app shows a clear message explaining what happened instead of returning a
questionable number.


LANGUAGES

English, Portuguese, French, Spanish and Simplified Chinese.


Developed by KUNDIAMA Tecnologia e Inovação.
```

**2 660 characters.**

---

## 4. Feature list

Only features verified in the source code:

1. Conversion across 7 units: W, mW, dBm, dBW, dBu, dBV and dB
2. Full formula shown for every conversion, including intermediate steps
3. Impedance field, requested only where required
4. Reference field for relative dB conversions
5. Unit swap button
6. Result updates as you type
7. History of the last 50 conversions, stored on the device
8. User-initiated history deletion, with confirmation
9. Reference menu describing every unit
10. Privacy Policy readable inside the app
11. Five languages
12. Works with no internet connection
13. No ads, no user account

---

## 5. Search terms

Google Play has no keyword field; indexing comes from the title, short
description and full description. These terms are woven into the text above.

**Priority terms:**

| Term | Where it appears |
|---|---|
| dBm to watts | short and full description |
| dBm converter | short description |
| watts to dBm | «What you can calculate» |
| dBW converter | unit list, conversions |
| dBV dBu | unit list, conversions |
| decibel converter | opening line |
| dB calculator | alternative short description |
| RF power converter | audience section |

**Secondary:** telecommunications · radio frequency · signal level · impedance ·
50 ohm · 600 ohm · audio engineering · link budget · gain · loss · ham radio

**Deliberately avoided:** instrument brand names, standards the app does not
implement, and artificial keyword repetition.

---

## 6. Value proposition

> The decibel converter that shows you the formula, asks for impedance only
> when it is actually needed, and works with no internet and no ads.

---

## 7. Screenshot captions

| # | Screen | Caption | Subcaption |
|---|---|---|---|
| 1 | Converter, dBm → W | **Convert decibels instantly** | 7 units, result as you type |
| 2 | Formula dialog open | **See the formula, not just the number** | Every step of the calculation |
| 3 | Conversion with impedance field | **Impedance only when it matters** | 50 Ω, 75 Ω, 600 Ω or your own |
| 4 | Side menu with unit list | **dBm, dBW, dBV, dBu, W, mW, dB** | With each reference explained |
| 5 | History with entries | **Your history, on your phone** | It never leaves the device |
| 6 | Tablet layout | **No ads. No internet.** | Works anywhere |

---

## 8. Differentiation message

Against a generic calculator:

> A calculator converts numbers. dB Konversor knows that dBm and dBV are
> **different kinds of quantity** — one is power, the other is voltage — and
> that moving between them requires an impedance. That is why it asks for
> impedance in those conversions, and only in those.

Against other decibel converters:

> It shows the complete formula for every conversion, requests no permissions
> at all, and keeps your history without sending it anywhere.

---

## 9. Terminology notes

| Term | Choice | Why |
|---|---|---|
| decibel / dB | lowercase «d», uppercase «B» | The «B» honours Alexander Graham Bell; `DB` or `db` are both incorrect |
| dBm, dBW, dBV, dBu | exact capitalisation | `dbm` or `DBM` read as sloppy to an engineer |
| ohm / Ω | symbol in UI, word in prose | `Ω` is universal and compact |
| milliwatt | double «l» | English spelling |
| «offline» | kept as one word | Standard in English |
| RF | abbreviation used freely | Understood by the target audience |

### en-GB variant

No changes needed: none of the spellings above differ between US and UK
English. A separate en-GB listing is therefore unnecessary.
