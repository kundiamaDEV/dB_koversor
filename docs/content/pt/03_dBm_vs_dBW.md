# dBm vs dBW: porque diferem exactamente 30 dB

**Tema:** unidades logarítmicas de potência · **Nível:** introdutório a intermédio
**Última revisão:** 2026-10-17
**Versão original:** [`../03_dBm_vs_dBW.md`](../03_dBm_vs_dBW.md)

---

## O problema

Um documento da ITU indica a PIRE de um satélite como **50 dBW**. A folha de
características do terminal que tens na mesa dá os valores do receptor em
**dBm**. Um colega escreve «17 dBW» numa coluna e «47 dBm» noutra e diz que é
o mesmo valor — será?

É. E a razão é uma única constante que vale a pena nunca mais ter de ir
procurar.

---

## As duas unidades são níveis de potência; só a referência difere

| Unidade | Definição | Referência | O zero da escala significa |
|---|---|---|---|
| **dBm** | `P_dBm = 10 × log₁₀(P_mW)` | 1 miliwatt | 0 dBm = 1 mW |
| **dBW** | `P_dBW = 10 × log₁₀(P_W)` | 1 watt | 0 dBW = 1 W |

Ambas são níveis de potência **absolutos** — ao contrário do dB simples, que é
uma razão e não significa nada sem uma referência declarada. A única diferença
entre elas é qual a potência a que a escala chama «zero».

---

## Dedução do desvio de 30 dB

Como `1 W = 1000 mW`:

```
P_dBm = 10 × log₁₀(P_mW)
      = 10 × log₁₀(1000 × P_W)
      = 10 × log₁₀(1000) + 10 × log₁₀(P_W)
      = 30 + P_dBW
```

Porque `log₁₀(1000) = 3` exactamente, o desvio é **exactamente 30 dB** — e não
29,9 nem 30,1. É uma consequência exacta do prefixo métrico *mili*.

```
P_dBm = P_dBW + 30
P_dBW = P_dBm − 30
```

**É toda a conversão.** Sem logaritmos nem exponenciais: somar ou subtrair 30.

---

## Exemplo resolvido: 50 dBm expresso em dBW

```
P_dBW = 50 − 30 = 20 dBW
```

Confirmação pelo caminho linear:

```
50 dBm = 10^(50/10) mW = 100 000 mW = 100 W
20 dBW = 10^(20/10) W  = 100 W            ✓
```

Os dois caminhos dão 100 W, como tem de ser.

### Exemplo resolvido: um transpondedor de satélite de 200 W

```
P_dBW = 10 × log₁₀(200) = 10 × 2,30103 = 23,0103 dBW
P_dBm = 23,0103 + 30    = 53,0103 dBm
```

**200 W = 23,0103 dBW = 53,0103 dBm.**

---

## Tabela de referência

Valores produzidos pelo motor do dB Konversor e confrontados com uma forma
fechada independente
([`../../evidence/exemplos_verificados.txt`](../../evidence/exemplos_verificados.txt)).

| Watts | dBW | dBm | Contexto |
|---|---|---|---|
| 0,001 W | −30 dBW | 0 dBm | A referência do dBm |
| 1 W | 0 dBW | 30 dBm | A referência do dBW |
| 10 W | 10 dBW | 40 dBm | |
| 20 W | 13,0103 dBW | 43,0103 dBm | Sector de estação base macro |
| 50,1187 W | 17 dBW | 47 dBm | O caso das «duas colunas, mesmo valor» |
| 100 W | 20 dBW | 50 dBm | |
| 200 W | 23,0103 dBW | 53,0103 dBm | Escala de transpondedor de satélite |
| 1000 W | 30 dBW | 60 dBm | |

Vale a pena fixar a simetria: **0 dBW = 30 dBm** e **−30 dBW = 0 dBm**.

---

## Que unidade se usa em cada área

Isto é convenção, não física — mas seguir a convenção da tua área evita
confusões.

| Domínio | Unidade habitual | Porquê |
|---|---|---|
| Rádio móvel e Wi-Fi, instrumentação de RF | **dBm** | Os níveis de sinal são pequenos; o dBm mantém os números numa gama cómoda (−120 a +50) |
| Ligações de satélite, PIRE, emissores de radiodifusão | **dBW** | As potências são grandes; o dBW evita carregar «+30» por todo o lado |
| Documentos da ITU-R e da ITU-T | frequentemente **dBW** | Estabelecido na regulamentação internacional de radiocomunicações |
| Sensibilidade de receptores, patamar de ruído | **dBm** | Os valores são muito negativos; o dBm é a norma |
| Áudio e som profissional | nenhuma das duas — **dBu/dBV** | O áudio trabalha em níveis de tensão, não de potência |

**Regra prática:** se os números saem entre −120 e +60, o dBm lê-se com
naturalidade. Se saem entre −30 e +90, é o dBW. As duas estão correctas;
misturá-las numa tabela sem rótulos é o que provoca erros.

---

## Interpretação: quanto custa um erro de 30 dB

Trocar este desvio não é um erro de arredondamento — é um **factor de 1000**:

| Indicado | Se a unidade for mal lida | Razão real |
|---|---|---|
| 20 dBW (= 100 W) | lido como 20 dBm (= 0,1 W) | 1000 vezes menos |
| 43 dBm (≈ 20 W) | lido como 43 dBW (≈ 20 kW) | 1000 vezes mais |

Num orçamento de ligação, um erro de 30 dB é a diferença entre uma ligação que
funciona e uma que não fecha ou que satura a entrada do receptor. Num processo
regulamentar, é a diferença entre cumprir o limite e ter um emissor mil vezes
acima dele.

---

## Erros frequentes

| Erro | Consequência | Como evitar |
|---|---|---|
| Usar 3 dB em vez de 30 dB | Factor de 2 em vez de 1000 | O desvio vem de `10·log₁₀(1000)`, não de `log₁₀(2)` |
| Subtrair quando se devia somar | Erro de 1000 vezes, no sentido errado | Os valores em dBm são sempre **maiores** 30 unidades, porque o miliwatt é uma referência menor |
| Escrever «dBw» ou «dbW» | Ambiguidade nos documentos | O `W` é maiúsculo: `dBW`. Do mesmo modo, `dBm` tem o `m` minúsculo |
| Tratar dBW como uma razão | «O ganho é de 10 dBW» não significa nada | Ganho mede-se em **dB**; dBW é uma potência absoluta |
| Pensar que dBW se relaciona com dBV também por 30 dB | Errado: dBV é um nível de **tensão** | A conversão potência↔tensão exige a impedância |

> **Este último é o subtil.** O atalho dos +30 funciona entre dBm e dBW porque
> ambos são potência referenciada a uma potência. **Não** se estende ao dBV
> nem ao dBu, que são níveis de tensão. Não existe desvio fixo entre dBm e
> dBV — depende da impedância. Ver
> [`../06_power_levels_and_impedance.md`](../06_power_levels_and_impedance.md).

---

## Onde isto se usa na prática

- **Orçamentos de ligação de satélite.** Os valores de PIRE e de G/T nos
  documentos da ITU vêm habitualmente em dBW, enquanto as especificações dos
  modems vêm em dBm.
- **Especificações de emissores de radiodifusão**, tipicamente em dBW ou kW.
- **Cálculos de PIRE.** Um emissor de 43 dBm com uma antena de 17 dBi dá
  60 dBm de PIRE, que são 30 dBW — a forma que um regulador pode esperar.
- **Confronto de documentos** de origens diferentes, que é exactamente quando o
  deslize dos 30 dB acontece.

---

## Fazer isto na aplicação

O **dB Konversor** suporta `dBW` directamente, a par de `dBm`, `W`, `mW`,
`dBV`, `dBu` e `dB`. Escolhe `dBW` como unidade de entrada e `dBm` como saída —
ou qualquer outra combinação — e o painel da fórmula mostra a cadeia aplicada:

```
mW = 10^((dBW + 30) / 10)  |  dBm = 10 × log10(mW)
```

O botão de inversão troca o sentido com um toque, o que torna a simetria dos
±30 visível em vez de ser algo para memorizar.

> **Nota sobre o historial desta unidade na aplicação.** O `dBW` foi
> acrescentado durante a auditoria técnica de Outubro de 2026, depois de ter
> sido identificado como lacuna para os utilizadores de radiodifusão e de
> satélite. Está coberto por 24 testes automatizados próprios, incluindo a
> verificação de que o desvio dBm−dBW é exactamente 30 dB em toda a gama de
> −90 a +90 dBW.

---

## Referências e leitura complementar

- **ITU-R V.574** e a série V da ITU-R sobre o uso do decibel e do neper em
  telecomunicações.
- **IEEE Std 100**, *The Authoritative Dictionary of IEEE Standards Terms* —
  definições de dBm e dBW.
- [Como converter dBm para watts](01_dBm_para_Watts.md)
- [`../02_Watts_to_dBm.md`](../02_Watts_to_dBm.md) — watts para dBm (inglês)
- [`../05_decibels_in_telecommunications.md`](../05_decibels_in_telecommunications.md) — fundamentos (inglês)
- [`../08_practical_telecommunications_examples.md`](../08_practical_telecommunications_examples.md) — problemas resolvidos (inglês)

> **Nota sobre os exemplos.** Todos os valores são *exemplos de cálculo*
> obtidos das fórmulas apresentadas. Os valores do «transpondedor de 200 W» e
> da «PIRE de 50 dBW» são ordens de grandeza ilustrativas, escolhidas por
> serem representativas do domínio; não foram retirados de nenhum satélite,
> processo de operadora ou folha de características concreta, e não se
> reivindicam dados de medição.
