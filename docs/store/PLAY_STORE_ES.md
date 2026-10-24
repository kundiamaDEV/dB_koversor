# Ficha de Google Play — Español (es-ES)

**Aplicación:** dB Konversor
**Paquete:** `ao.kundiama.dbkonversor`
**Fecha:** 2026-10-17

> Límites de caracteres (verificados con [`verificar_limites.py`](verificar_limites.py)):
> nombre 30, descripción breve 80, descripción completa 4000.

---

## 1. Nombre de la aplicación (máx. 30)

```
dB Konversor
```

**12 caracteres.** Idéntico en todos los mercados: es la marca.

---

## 2. Descripción breve (máx. 80)

```
Conversor de dBm, dBW, W, dBV y dBu con fórmulas. Sin conexión, sin anuncios.
```

**77 caracteres.**

Variantes estudiadas:

| Texto | Car. | Valoración |
|---|---|---|
| `Conversor de dBm, dBW, W, dBV y dBu con fórmulas. Sin conexión, sin anuncios.` | 77 | **Recomendada.** Símbolos primero — es lo que se escribe al buscar |
| `Convierta dBm a vatios, dBW, dBV y dBu. Muestra cada paso del cálculo.` | 70 | Buena en el diferenciador, menor cobertura de símbolos |
| `Calculadora de decibelios para telecomunicaciones, RF y audio. Offline.` | 71 | Mejor para el público, peor para la intención de búsqueda |

---

## 3. Descripción completa (máx. 4000)

```
dB Konversor convierte las unidades de potencia y los niveles logarítmicos que
se utilizan a diario en telecomunicaciones, electrónica, radiofrecuencia y
audio.

Escriba un valor, elija la unidad de entrada y la de salida, y el resultado
aparece al instante. Sin anuncios, sin cuenta y sin conexión a Internet.


UNIDADES COMPATIBLES

• dBm — potencia referida a 1 mW
• dBW — potencia referida a 1 W
• W — vatio
• mW — milivatio
• dBV — nivel de tensión referido a 1 V
• dBu — nivel de tensión referido a 0,775 V
• dB — relación logarítmica, respecto a una referencia que usted indica


QUÉ PUEDE CALCULAR

• dBm a vatios y vatios a dBm
• dBm a dBW y dBW a dBm
• dBV a dBu y dBu a dBV
• Potencia a nivel de tensión, indicando la impedancia (50 Ω, 75 Ω, 600 Ω, 8 Ω
  u otra)
• Ganancias y pérdidas en dB, respecto a la referencia que elija


LA FÓRMULA ESTÁ SIEMPRE A LA VISTA

Cada resultado incluye la fórmula aplicada, con todos los pasos intermedios.
Una conversión de dBm a dBV muestra la cadena completa:

mW = 10^(dBm / 10)  |  V = √(P × R)  |  dBV = 20 × log10(V)

Eso es lo que convierte la aplicación en una herramienta de estudio y no solo
en un generador de números. Si está aprendiendo, ve el camino. Si ya lo
domina, comprueba que el cálculo es el que espera.


LA IMPEDANCIA SE PIDE SOLO CUANDO HACE FALTA

Convertir potencia en nivel de tensión exige conocer la impedancia, porque
V = √(P × R). Convertir dBm en vatios no la exige. La aplicación pide la
impedancia únicamente en las conversiones que realmente la necesitan, en lugar
de exigirla siempre o de suponer 50 Ω en silencio.


HISTORIAL GUARDADO EN SU TELÉFONO

Las últimas 50 conversiones quedan registradas con su fecha, para que pueda
consultarlas después. Permanecen en su dispositivo, puede borrarlas cuando
quiera y nunca se envían a ningún sitio.


FUNCIONA SIN INTERNET

La versión publicada no solicita ni siquiera el permiso de acceso a la red.
Todos los cálculos se realizan en el teléfono. Funciona en lo alto de una
torre, en un sótano, en un laboratorio o en un avión.


PARA QUIÉN ES

• Estudiantes de telecomunicaciones, electrónica e ingeniería eléctrica
• Profesores, para explicar la relación entre escalas lineales y logarítmicas
• Técnicos de instalación y mantenimiento de redes
• Ingenieros de radiofrecuencia y de telecomunicaciones
• Técnicos de sonido e ingenieros de audio
• Radioaficionados


SOBRE LA PRECISIÓN

Las conversiones están cubiertas por una batería de pruebas automatizadas cuyos
valores esperados se obtienen de forma independiente de la implementación que
se prueba. Los cálculos usan doble precisión y, cuando un valor queda fuera del
intervalo representable, la aplicación muestra un mensaje claro explicando qué
ha ocurrido en lugar de devolver un número dudoso.


IDIOMAS

Español, portugués, inglés, francés y chino simplificado.


Desarrollado por KUNDIAMA Tecnologia e Inovação.
```

**2 902 caracteres.**

---

## 4. Lista de funcionalidades

Solo funcionalidades **verificadas en el código**:

1. Conversión entre 7 unidades: W, mW, dBm, dBW, dBu, dBV y dB
2. Fórmula completa en cada conversión, con los pasos intermedios
3. Campo de impedancia, solicitado solo donde es necesario
4. Campo de referencia para conversiones relativas en dB
5. Botón de inversión de unidades
6. Resultado actualizado al escribir
7. Historial de las últimas 50 conversiones, guardado en el dispositivo
8. Borrado del historial por el usuario, con confirmación
9. Menú de consulta con la descripción de cada unidad
10. Política de Privacidad consultable dentro de la aplicación
11. Cinco idiomas
12. Funciona sin conexión a Internet
13. Sin anuncios y sin cuenta de usuario

---

## 5. Términos de búsqueda

**Prioritarios:**

| Término | Dónde aparece |
|---|---|
| conversor dBm | descripción breve y completa |
| dBm a vatios | sección «Qué puede calcular» |
| dBm a watts | variante escrita en inglés, muy buscada |
| vatios a dBm | idem |
| dBW | lista de unidades, conversiones |
| dBV dBu | lista de unidades, conversiones |
| conversor decibelios | primera línea |
| calculadora dB | descripción breve alternativa |

**Secundarios:** telecomunicaciones · radiofrecuencia · potencia RF · nivel de
tensión · impedancia · 50 ohmios · 600 ohmios · audio · ganancia · pérdida ·
electrónica · balance de enlace

> **Nota de cobertura:** en español coexisten «vatio» (forma de la RAE) y
> «watt» (símbolo y uso internacional). Ambas aparecen en el texto, porque las
> dos se buscan: los estudiantes suelen escribir «vatios» y los profesionales
> «watts».

---

## 6. Propuesta de valor

> El conversor de decibelios que muestra la fórmula, pide la impedancia solo
> cuando es necesaria y funciona sin Internet ni anuncios.

---

## 7. Textos para las capturas de pantalla

| # | Pantalla | Texto principal | Subtexto |
|---|---|---|---|
| 1 | Conversor, dBm → W | **Convierta decibelios al instante** | 7 unidades, resultado inmediato |
| 2 | Diálogo de la fórmula | **La fórmula, no solo el número** | Todos los pasos del cálculo |
| 3 | Conversión con impedancia | **Impedancia solo cuando hace falta** | 50 Ω, 75 Ω, 600 Ω o la suya |
| 4 | Menú lateral de unidades | **dBm, dBW, dBV, dBu, W, mW, dB** | Con su referencia |
| 5 | Historial | **Su historial, en su teléfono** | No sale del dispositivo |
| 6 | Diseño en tablet | **Sin anuncios. Sin Internet.** | Funciona en cualquier sitio |

---

## 8. Mensaje de diferenciación

Frente a una calculadora genérica:

> Una calculadora convierte números. dB Konversor sabe que dBm y dBV son
> magnitudes **distintas** —una es potencia, la otra tensión— y que pasar de
> una a otra exige conocer la impedancia. Por eso la pide en esas conversiones,
> y solo en esas.

---

## 9. Notas de terminología

| Término | Elección | Por qué |
|---|---|---|
| decibelio / decibelios | forma de la RAE | «decibel» es anglicismo; en el texto corrido se usa «decibelio» |
| vatio / milivatio | formas de la RAE en texto corrido | Pero el **símbolo** siempre es `W` / `mW` |
| tensión | preferido a «voltaje» | «Tensión» es el término normalizado en ingeniería; «voltaje» es más coloquial |
| impedancia | — | Término normalizado |
| ohmios | plural en texto corrido | `Ω` en la interfaz |
| tratamiento de «usted» | en toda la ficha | Más adecuado para una herramienta profesional y neutral entre España y América |
| coma decimal | `0,775 V` | Separador decimal en español |
| dBm, dBW, dBV, dBu, W, mW | **nunca traducidos** | Notación técnica internacional |

### Mercados hispanohablantes

España, México, Colombia, Argentina, Chile, Perú y Guinea Ecuatorial. El
tratamiento de «usted» y la terminología de la RAE funcionan en todos ellos sin
necesidad de fichas regionales separadas. Las únicas divergencias habituales
—«computadora/ordenador», «celular/móvil»— se evitaron: el texto usa
«teléfono», que es neutral.
