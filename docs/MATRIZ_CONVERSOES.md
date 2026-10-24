# Matriz de Conversões — dB Konversor

**Versão da aplicação:** 1.0.0+1
**Data:** 2026-10-17
**Fonte:** `lib/core/power_unit.dart`, `lib/features/converter/power_converter_service.dart`

Este documento descreve **apenas** as conversões que o código suporta. Todos os
exemplos numéricos foram produzidos pelo script
[`evidence/gerar_exemplos.dart`](evidence/gerar_exemplos.dart), que executa o
serviço de conversão real e compara cada resultado com uma forma fechada
independente. A saída completa está em
[`evidence/exemplos_verificados.txt`](evidence/exemplos_verificados.txt).

---

## 1. Unidades suportadas

| Símbolo | Grandeza física | Categoria interna | Referência | Valores negativos |
|---|---|---|---|---|
| `W` | Potência | `powerLinear` | — (unidade SI absoluta) | Não (rejeitados) |
| `mW` | Potência | `powerLinear` | — | Não (rejeitados) |
| `dBm` | Potência | `powerLogAbsolute` | 1 mW | Sim (comuns) |
| `dBW` | Potência | `powerLogAbsolute` | 1 W | Sim (comuns) |
| `dBu` | Nível de tensão | `voltageLog` | 0,775 V | Sim (comuns) |
| `dBV` | Nível de tensão | `voltageLog` | 1 V | Sim (comuns) |
| `dB` | Razão adimensional | `ratioLog` | Fornecida pelo utilizador | Sim (comuns) |

`dBW` foi acrescentado nesta auditoria (defeito M2 de
[`AUDITORIA_INICIAL.md`](AUDITORIA_INICIAL.md)), por decisão do proprietário.

### Nota sobre a referência do dBu

0 dBu = **0,775 V** é a convenção da indústria de áudio. Historicamente o valor
vem da tensão que dissipa 1 mW em 600 Ω, que é `√(0,001 × 600) = 0,774597 V`,
arredondada para 0,775 V. Os dois valores **não são idênticos**, e a aplicação
usa 0,775 V, que é o valor normativo. Consequência verificável na aplicação:

```
0 dBu → mW (em 600 Ω) = 1.001 mW     (e não exactamente 1,000 mW)
```

Esta diferença de 0,0045 dB é real e está correcta; não é um erro de cálculo.
Ver o artigo [`content/04_dBV_vs_dBu.md`](content/04_dBV_vs_dBu.md).

---

## 2. Matriz de suporte

`✔` = suportada directamente · `R` = exige valor de **referência** ·
`Z` = exige **impedância** · `=` = mesma unidade (devolve o valor intacto)

| de \ para | W | mW | dBm | dBW | dBu | dBV | dB |
|---|---|---|---|---|---|---|---|
| **W**   | = | ✔ | ✔ | ✔ | Z | Z | R |
| **mW**  | ✔ | = | ✔ | ✔ | Z | Z | R |
| **dBm** | ✔ | ✔ | = | ✔ | Z | Z | R |
| **dBW** | ✔ | ✔ | ✔ | = | Z | Z | R |
| **dBu** | Z | Z | Z | Z | = | ✔ | R |
| **dBV** | Z | Z | Z | Z | ✔ | = | R |
| **dB**  | R | R | R | R | R | R | = |

São 49 combinações: 7 identidades, 30 conversões directas ou com impedância e
12 conversões relativas com referência.

### Quando a impedância é exigida

A impedância é pedida **se e só se** a conversão relaciona uma grandeza de
potência com um nível de tensão. É a regra implementada em
`PowerConverterService.requiresImpedance`:

```
involvesVoltage = from é dBu/dBV  OU  to é dBu/dBV
involvesPower   = from é W/mW/dBm/dBW  OU  to é W/mW/dBm/dBW
exigeImpedância = involvesVoltage E involvesPower
```

Por isso `dBu → dBV` **não** pede impedância (é apenas uma mudança de
referência de tensão) e `W → dBm` também não (é potência para potência). Esta
regra está coberta pelo teste *«a impedância NÃO é exigida quando não é
necessária»*.

---

## 3. Fórmulas por família de conversão

A aplicação converte através de dois pivôs internos: **mW** para as grandezas
de potência e **volts** para os níveis de tensão. Cada conversão é a composição
dos passos abaixo, e a fórmula apresentada ao utilizador mostra todos os passos
aplicados (correcção M4).

### 3.1 Potência ↔ potência

| Passo | Fórmula | Condição de validade |
|---|---|---|
| W → mW | `mW = W × 1000` | `W ≥ 0` |
| mW → W | `W = mW / 1000` | — |
| dBm → mW | `mW = 10^(dBm / 10)` | resultado finito e > 0 |
| mW → dBm | `dBm = 10 × log10(mW)` | `mW > 0` |
| dBW → mW | `mW = 10^((dBW + 30) / 10)` | resultado finito e > 0 |
| mW → dBW | `dBW = 10 × log10(W)` | `mW > 0` |

**Factor 10, não 20:** estas grandezas são potências. O factor 20 aplica-se a
tensões, porque `P ∝ V²` e `log(V²) = 2·log(V)`. Usar 20 aqui duplicaria o
resultado em dB — é o erro descrito no artigo
[`content/07_common_conversion_mistakes.md`](content/07_common_conversion_mistakes.md).

**Verificado:**

| Conversão | Resultado apresentado | Valor interno |
|---|---|---|
| 0 dBm → mW | `1` | 1,00000000000 |
| 30 dBm → W | `1` | 1,00000000000 |
| 1 W → dBm | `30` | 30,0000000000 |
| 0,5 W → dBm | `26.9897` | 26,9897000434 |
| 2 mW → dBm | `3.0103` | 3,01029995664 |
| 0 dBW → W | `1` | 1,00000000000 |
| 0 dBW → dBm | `30` | 30,0000000000 |
| 50 dBm → dBW | `20` | 20,0000000000 |
| 100 W → dBW | `20` | 20,0000000000 |
| 5 W → dBW | `6.9897` | 6,98970004336 |

### 3.2 Nível de tensão ↔ nível de tensão

| Passo | Fórmula | Condição |
|---|---|---|
| dBV → V | `V = 10^(dBV / 20)` | resultado finito e > 0 |
| V → dBV | `dBV = 20 × log10(V)` | `V > 0` |
| dBu → V | `V = 0,775 × 10^(dBu / 20)` | resultado finito e > 0 |
| V → dBu | `dBu = 20 × log10(V / 0,775)` | `V > 0` |

A diferença entre as duas escalas é uma **constante**, independente do nível:
`dBu − dBV = 20·log10(1/0,775) = 2,213965949874 dB`. Há um teste que verifica
esta invariância em vários níveis.

**Verificado:**

| Conversão | Resultado | Valor interno |
|---|---|---|
| 0 dBu → dBV | `-2.214` | −2,21396594987 |
| 0 dBV → dBu | `2.214` | 2,21396594987 |
| 4 dBu → dBV | `1.786` | 1,78603405013 |
| −10 dBV → dBu | `-7.786` | −7,78603405013 |

### 3.3 Potência ↔ nível de tensão (exige impedância)

| Sentido | Cadeia aplicada |
|---|---|
| potência → nível | `→ mW` → `W = mW/1000` → `V = √(P × R)` → `dBV`/`dBu` |
| nível → potência | `→ V` → `P = V² / R` → `mW = W × 1000` → unidade de saída |

A relação de base é a lei de Joule para uma carga resistiva:
`P = V²/R`, logo `V = √(P·R)`.

> **Correcção M1.** A raiz quadrada usa `dart:math.sqrt`. A versão anterior
> usava uma raiz quadrada iterativa truncada em 20 iterações, que divergia em
> potências baixas: o erro era de 18,7 dB a −120 dBm e de 28,6 dB a −130 dBm.
> Ver [`AUDITORIA_INICIAL.md`](AUDITORIA_INICIAL.md) e
> [`evidence/verificacao_sqrt.dart`](evidence/verificacao_sqrt.dart).

**Verificado em 50 Ω** (valor habitual em radiofrequência):

| Conversão | Resultado | Valor interno |
|---|---|---|
| −120 dBm → dBV | `-133.0103` | −133,010299957 |
| −100 dBm → dBV | `-113.0103` | −113,010299957 |
| −90 dBm → dBV | `-103.0103` | −103,010299957 |
| −60 dBm → dBV | `-73.0103` | −73,0102999566 |
| 0 dBm → dBV | `-13.0103` | −13,0102999566 |
| 20 dBm → dBV | `6.9897` | 6,98970004336 |
| 43 dBm → dBV | `29.9897` | 29,9897000434 |

**Verificado em 600 Ω** (linha de áudio clássica):

| Conversão | Resultado | Valor interno |
|---|---|---|
| −20 dBm → dBu | `-20.0045` | −20,0045215463 |
| 0 dBm → dBu | `-0.004522` | −0,00452154629 |
| 10 dBm → dBu | `9.9955` | 9,99547845371 |
| 0 dBu → mW | `1.001` | 1,00104166667 |

**Verificado em 8 Ω** (altifalantes):

| Conversão | Resultado | Valor interno |
|---|---|---|
| 0 dBV → W | `0.125` | 0,125000000000 |
| 10 dBV → W | `1.25` | 1,25000000000 |
| 20 dBV → W | `12.5` | 12,5000000000 |

### 3.4 Conversões relativas em dB (exigem referência)

O `dB` é **adimensional**: exprime uma razão. Para ter significado absoluto
precisa de uma referência, que o utilizador introduz na unidade indicada pela
aplicação.

| Conversão | Fórmula | Unidade da referência |
|---|---|---|
| W/mW → dB | `dB = 10 × log10(P / Pref)` | a mesma do valor de entrada |
| dB → W/mW | `P = Pref × 10^(dB / 10)` | a mesma da saída |
| dBm → dB | `dB = dBm − dBm(ref)` | dBm |
| dB → dBm | `dBm = dB + dBm(ref)` | dBm |
| dBW → dB | `dB = dBW − dBW(ref)` | dBW |
| dB → dBW | `dBW = dB + dBW(ref)` | dBW |
| dBV → dB | `dB = dBV − dBV(ref)` | dBV |
| dB → dBV | `dBV = dB + dBV(ref)` | dBV |
| dBu → dB | `dB = dBu − dBu(ref)` | dBu |
| dB → dBu | `dBu = dB + dBu(ref)` | dBu |

A subtracção directa entre níveis logarítmicos da mesma escala é exacta, porque
`10·log10(A) − 10·log10(B) = 10·log10(A/B)`.

**Verificado:**

| Conversão | Referência | Resultado |
|---|---|---|
| 2 W → dB | 1 W | `3.0103` (3,01029995664) |
| 100 mW → dB | 1 mW | `20` |
| 23 dBm → dB | 20 dBm | `3` |
| 3 dB → dBm | 20 dBm | `23` |
| −3 dB → W | 100 W | `50.1187` (50,1187233627) |

---

## 4. Condições de validade e tratamento de erros

| Situação | Comportamento | Código de erro |
|---|---|---|
| Campo vazio | Rejeitado com mensagem | `emptyInput` |
| Texto não numérico | Rejeitado | `invalidNumber` |
| `NaN` ou infinito na entrada | Rejeitado | `nonFiniteInput` |
| `0 mW → dBm` (log de zero) | Rejeitado | `nonPositiveForLog` |
| `−5 W → dBm` (potência negativa) | Rejeitado | `negativePower` |
| Impedância em falta | Rejeitado | `missingImpedance` |
| Impedância ≤ 0 | Rejeitado | `nonPositiveImpedance` |
| Referência em falta | Rejeitado | `missingReference` |
| Potência de referência ≤ 0 | Rejeitado | `nonPositiveReference` |
| `4000 dBm → W` (estoiro para infinito) | Rejeitado | `outOfRange` |
| `−4000 dBW → W` (subfluxo para zero) | Rejeitado | `outOfRange` |
| Combinação não suportada | Rejeitado | `unsupportedCombination` |

**Garantia verificada por teste:** nenhuma combinação de unidades, com nenhum
valor de entrada, devolve um «sucesso» com `NaN` ou infinito. O teste *«nenhuma
conversão devolve um resultado não finito»* percorre todas as 49 combinações
com 11 valores extremos cada (539 casos) e exige que o resultado seja ou um
sucesso com valor finito, ou uma falha com mensagem.

### Porque zero watt é aceite mas zero miliwatt para dBm não é

`0 W → mW` dá `0 mW`: é uma potência nula, fisicamente válida. Mas `0 mW → dBm`
exigiria `log10(0)`, que tende para menos infinito e não tem representação
numérica. Por isso a primeira conversão é aceite e a segunda é rejeitada, com
uma mensagem que nomeia a unidade que o utilizador escolheu (correcção M3).

---

## 5. Limites numéricos

Todos os cálculos usam `double` IEEE 754 de dupla precisão (épsilon relativo
≈ 2,22 × 10⁻¹⁶).

Os limites abaixo foram **medidos** por pesquisa binária sobre o ponto em que
`10^(x/10)` deixa de ser finito ou passa a ser zero, e não estimados:

| Grandeza | Limite inferior | Limite superior | Motivo |
|---|---|---|---|
| Entrada em dBm | −3236,07 | +3082,55 | fora disto `10^(dBm/10)` dá 0 ou infinito |
| Entrada em dBW | −3266,07 | +3052,55 | o mesmo, deslocado dos 30 dB da referência |
| Entrada em dBV | −6472,14 | +6165,09 | o expoente é dividido por 20, logo a gama duplica |
| Entrada em dBu | −6472,14 | +6165,09 | idem (o factor 0,775 não altera a ordem de grandeza) |
| Impedância | > 0 | finita | `P = V²/R` e `V = √(P·R)` |
| Precisão em dB | — | ≈ 10⁻¹³ dB | resolução do `double` nesta gama |

Fora destes limites a aplicação **rejeita a conversão com uma mensagem**, em vez
de devolver `0`, `Infinity` ou `NaN` — comportamento coberto pelos testes de
valores-limite.

Estes limites excedem largamente qualquer aplicação física: a potência de
emissão mais alta usada em radiodifusão ronda os 90 dBm e o ruído térmico mais
baixo mensurável ronda os −174 dBm/Hz.

---

## 6. Cobertura de testes por conversão

| Família | Ficheiro de teste | Casos |
|---|---|---|
| Potência linear ↔ potência linear | `test/power_converter_service_test.dart` | 4 testes |
| dBm ↔ potência linear | `test/power_converter_service_test.dart` | 6 testes, 8 âncoras exactas |
| dBu ↔ dBV | `test/power_converter_service_test.dart` | 5 testes |
| Potência ↔ nível de tensão | `test/power_converter_service_test.dart` | 10 testes, incl. 2 de regressão de M1 |
| dB com referência | `test/power_converter_service_test.dart` | 7 testes |
| Limites e entradas inválidas | `test/power_converter_service_test.dart` | 6 testes, 539 casos na varredura |
| dBW (todas as famílias) | `test/dbw_conversion_test.dart` | 24 testes |
| Formatação de apresentação | `test/number_formatting_test.dart` | 14 testes |

Total do projecto: **146 testes**, todos aprovados em 2026-10-17.
Comando: `flutter test`.

### Independência dos valores de referência

Os testes **não** reutilizam as funções do código de produção para calcular o
valor esperado — isso reproduziria qualquer erro existente e os testes passariam
à mesma. Em vez disso, `test/reference_values.dart` usa:

1. **Âncoras exactas** por definição das unidades (0 dBm = 1 mW, 0 dBW = 1 W).
2. **Formas fechadas de um só passo** que eliminam algebricamente a raiz
   quadrada: `L_dBV = 10·log10(P·R)` em vez de `20·log10(√(P·R))`.

Foi precisamente a segunda estratégia que detectou o defeito M1: a referência
não usa raiz quadrada nenhuma, pelo que um erro na raiz quadrada do código de
produção não pode passar despercebido.

---

## 7. Conversões deliberadamente não suportadas

Para evitar expectativas erradas, fica registado o que a aplicação **não** faz:

| Não suportado | Porquê |
|---|---|
| `dBi`, `dBd` (ganho de antena) | Grandezas de ganho de antena; exigiriam um modelo de radiação |
| `dBc` (relativo à portadora) | Caso particular de dB com referência; pode ser obtido com `dB` + referência |
| `dBFS` (escala digital) | Depende do formato e da profundidade de bits do sistema digital |
| `dBSPL` (pressão sonora) | Grandeza acústica (referência 20 µPa), não eléctrica |
| `dBμV`, `dBmV` | Níveis de tensão com outras referências; podem ser calculados com `dB` + referência |
| Conversão com impedância complexa | A aplicação assume carga resistiva pura (`P = V²/R`) |
| Potência em regime não sinusoidal | Assume valores eficazes (RMS) |

**Pressuposto físico importante:** todas as conversões entre potência e tensão
assumem uma **carga resistiva pura** e valores **eficazes (RMS)**. Numa carga
reactiva, a potência activa envolve o factor de potência e os resultados desta
aplicação não se aplicam directamente.
