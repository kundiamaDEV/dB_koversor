# Cómo convertir dBm a vatios (con ejemplos resueltos)

**Tema:** conversión de unidades de potencia · **Nivel:** inicial a intermedio
**Última revisión:** 2026-10-17
**Versión original:** [`../01_dBm_to_Watts.md`](../01_dBm_to_Watts.md)

---

## El problema

La hoja de características indica que la potencia de salida del transmisor es
de **43 dBm**. La especificación de la fuente de alimentación que está
comprobando viene en vatios. El formulario del estudio de emplazamiento pide
vatios. Entonces: ¿cuántos vatios son 43 dBm?

Esto aparece continuamente — hojas de características de radios, manuales de
amplificadores, límites reglamentarios e informes de ensayo mezclan ambas
unidades con naturalidad, y equivocarse por un factor de diez es fácil.

---

## La fórmula

El dBm es un **nivel de potencia referido a 1 milivatio**. Por definición:

```
P_dBm = 10 × log₁₀(P_mW)
```

Invirtiéndola se obtiene la conversión que necesita:

```
P_mW = 10^(P_dBm / 10)

P_W  = 10^(P_dBm / 10) / 1000
```

Dos advertencias antes de aplicarla:

1. **El factor es 10, no 20.** El factor 20 corresponde a las relaciones de
   tensión y de corriente, porque la potencia es proporcional al cuadrado de
   la tensión. Usar 20 aquí duplica el resultado en dB.
2. **El dBm es absoluto, no relativo.** A diferencia del dB simple, el dBm
   designa una potencia concreta, porque su referencia (1 mW) está fijada por
   definición.

---

## Ejemplo resuelto: 43 dBm en vatios

**Paso 1 — Dividir entre 10.**

```
43 / 10 = 4,3
```

**Paso 2 — Elevar 10 a esa potencia. El resultado sale en milivatios.**

```
P_mW = 10^4,3 = 19 952,6 mW
```

**Paso 3 — Dividir entre 1000 para obtener vatios.**

```
P_W = 19 952,6 / 1000 = 19,9526 W
```

**Respuesta: 43 dBm ≈ 19,95 W**, es decir unos 20 vatios.

### Interpretación

43 dBm es un nivel de potencia habitual en el puerto de un amplificador de
potencia de una estación base macro. El valor «unos 20 W» es la referencia
mental útil: si le dicen que una radio de sector funciona a 43 dBm, debe
imaginar un equipo de 20 W, y no de 2 W ni de 200 W.

---

## Tabla de referencia

Todos los valores siguientes fueron producidos por el motor de conversión de
dB Konversor y comprobados contra una forma cerrada deducida de manera
independiente. La salida de la verificación está en
[`../../evidence/exemplos_verificados.txt`](../../evidence/exemplos_verificados.txt).

| dBm | Milivatios | Vatios | Contexto típico |
|---|---|---|---|
| −100 dBm | 1 × 10⁻¹⁰ mW | 1 × 10⁻¹³ W | Cerca del límite de sensibilidad de un receptor móvil |
| −70 dBm | 1 × 10⁻⁷ mW | 1 × 10⁻¹⁰ W | Señal Wi-Fi utilizable |
| −30 dBm | 0,001 mW | 1 µW | Señal recibida fuerte |
| 0 dBm | 1 mW | 0,001 W | El punto de referencia, por definición |
| 13 dBm | 19,9526 mW | 0,02 W | Bluetooth Clase 1 |
| 20 dBm | 100 mW | 0,1 W | Transmisor de un cliente Wi-Fi |
| 23 dBm | 199,526 mW | 0,2 W | Enlace ascendente de un teléfono móvil |
| 30 dBm | 1000 mW | 1 W | Exactamente 1 vatio |
| 37 dBm | 5011,87 mW | 5,01187 W | Transmisor de célula pequeña |
| 43 dBm | 19 952,6 mW | 19,9526 W | Sector de estación base macro |
| 50 dBm | 100 000 mW | 100 W | Transmisor de alta potencia |

### Las dos referencias que conviene memorizar

| Referencia | Por qué ayuda |
|---|---|
| **0 dBm = 1 mW** | Es la definición. Todo lo demás se deduce de ella |
| **30 dBm = 1 W** | Porque 10·log₁₀(1000) = 30 exactamente |

Con esas dos, más la regla de que **+10 dB es ×10** y **+3 dB es unas ×2**,
puede estimar la mayoría de las conversiones mentalmente:

```
43 dBm = 30 dBm + 10 dB + 3 dB
       ≈ 1 W × 10 × 2
       ≈ 20 W        (valor exacto: 19,95 W)
```

Esa estimación mental queda a menos del 0,25 % del valor exacto.

---

## Errores frecuentes

| Error | Consecuencia | Cómo evitarlo |
|---|---|---|
| Usar `20 × log₁₀` en lugar de `10 × log₁₀` | El valor en dB se duplica. 100 mW pasa a «40 dBm» en lugar de 20 dBm | El factor 20 es para la **tensión**, nunca para la potencia |
| Olvidar la división entre 1000 de mW a W | Resultado 1000 veces mayor | El dBm se refiere a un **mili**vatio |
| Tratar el dBm como una relación | «La ganancia es de 20 dBm» no significa nada | La ganancia se expresa en **dB**; la potencia absoluta en dBm |
| Sumar valores en dBm para sumar potencias | 20 dBm + 20 dBm ≠ 40 dBm | Dos potencias iguales se combinan en **+3 dB**, dando 23,0103 dBm |
| Redondear 3,0103 dB a 3 dB en una cadena larga | El error se acumula a lo largo de muchas etapas | Vale para estimaciones mentales; use el valor exacto en informes |

---

## Dónde se aplica en la práctica

- **Balances de enlace.** La potencia recibida se calcula en dBm, y solo se
  convierte a vatios si alguna especificación de equipo lo exige.
- **Conformidad reglamentaria.** Los límites de potencia de transmisión se
  publican en vatios o en dBm de PIRE, y hay que comparar lo equivalente.
- **Dimensionamiento de la alimentación.** La salida de radiofrecuencia de un
  amplificador en dBm, convertida a vatios, da la potencia de salida;
  combinada con el rendimiento, da el consumo en corriente continua.
- **Mediciones de laboratorio.** Los analizadores de espectro leen en dBm;
  muchos medidores de potencia leen en vatios.

---

## Hacerlo sin errores de aritmética

En la aplicación **dB Konversor**: escriba el valor, ponga la unidad de
entrada en `dBm` y la de salida en `W`. El resultado aparece a medida que
escribe, y el panel de la fórmula muestra la cadena completa aplicada:

```
mW = 10^(dBm / 10)  |  W = mW / 1000
```

Ver los dos pasos importa cuando se está aprendiendo: es la diferencia entre
obtener un número y entender de dónde viene. La aplicación funciona sin
conexión a Internet y no requiere cuenta.

---

## Compruébelo usted mismo

Todos los valores de este artículo son reproducibles:

```powershell
dart run docs/evidence/gerar_exemplos.dart
```

Ese script ejecuta el código de conversión de producción y compara cada
resultado con una forma cerrada deducida de forma independiente, de modo que
las cifras aquí no se transcribieron a mano.

---

## Referencias y lecturas complementarias

- **Definición de dBm:** IEEE Std 100, *The Authoritative Dictionary of IEEE
  Standards Terms* — el dBm como potencia referida a 1 mW.
- Las **recomendaciones de la UIT-R** usan dBm y dBW ampliamente para la
  potencia de transmisión y la intensidad de campo; véase la serie V de la
  UIT-R sobre terminología y unidades.
- [`../03_dBm_vs_dBW.md`](../03_dBm_vs_dBW.md) — dBm y dBW (inglés)
- [`../02_Watts_to_dBm.md`](../02_Watts_to_dBm.md) — la conversión inversa (inglés)
- [`../06_power_levels_and_impedance.md`](../06_power_levels_and_impedance.md) — potencia e impedancia (inglés)
- [`../../MATRIZ_CONVERSOES.md`](../../MATRIZ_CONVERSOES.md) — todas las conversiones
  compatibles, con sus condiciones de validez

> **Nota sobre los ejemplos.** Todos los valores numéricos son *ejemplos de
> cálculo*, obtenidos de las fórmulas mostradas. No son mediciones de campo, y
> no se reivindican datos de operadoras, resultados de laboratorios de ensayo
> ni estadísticas de red. Los contextos indicados en la tabla («típico de una
> estación base macro») sirven de orientación de orden de magnitud y no son la
> especificación de ningún producto concreto.
