# Como converter dBm para watts (com exemplos resolvidos)

**Tema:** conversão de unidades de potência · **Nível:** introdutório a intermédio
**Última revisão:** 2026-10-17
**Versão original:** [`../01_dBm_to_Watts.md`](../01_dBm_to_Watts.md)

---

## O problema

A folha de características diz que a potência de saída do emissor é
**43 dBm**. A especificação da fonte de alimentação que estás a verificar está
em watts. O formulário de levantamento do local pede watts. Então: quantos
watts são 43 dBm?

Isto aparece constantemente — folhas de características de rádios, manuais de
amplificadores, limites regulamentares e relatórios de ensaio misturam as duas
unidades com naturalidade, e errar a conversão por um factor de dez é fácil.

---

## A fórmula

dBm é um **nível de potência referenciado a 1 miliwatt**. A definição é:

```
P_dBm = 10 × log₁₀(P_mW)
```

Invertendo, obtém-se a conversão que precisas:

```
P_mW = 10^(P_dBm / 10)

P_W  = 10^(P_dBm / 10) / 1000
```

Dois pontos antes de aplicar:

1. **O factor é 10, não 20.** O factor 20 pertence às razões de tensão e de
   corrente, porque a potência é proporcional ao quadrado da tensão. Usar 20
   aqui duplica o resultado em dB.
2. **dBm é absoluto, não relativo.** Ao contrário do dB simples, o dBm designa
   uma potência específica, porque a sua referência (1 mW) está fixada por
   definição.

---

## Exemplo resolvido: 43 dBm em watts

**Passo 1 — Dividir por 10.**

```
43 / 10 = 4,3
```

**Passo 2 — Elevar 10 a essa potência. O resultado vem em miliwatts.**

```
P_mW = 10^4,3 = 19 952,6 mW
```

**Passo 3 — Dividir por 1000 para obter watts.**

```
P_W = 19 952,6 / 1000 = 19,9526 W
```

**Resposta: 43 dBm ≈ 19,95 W**, ou cerca de 20 watts.

### Interpretação

43 dBm é um nível de potência típico da porta de um amplificador de potência
de uma estação base macro. O valor «cerca de 20 W» é a âncora mental útil: se
alguém disser que um rádio de sector funciona a 43 dBm, deves imaginar um
equipamento de 20 W, e não de 2 W nem de 200 W.

---

## Tabela de referência

Todos os valores abaixo foram produzidos pelo motor de conversão do
dB Konversor e confrontados com uma forma fechada deduzida de modo
independente. A saída da verificação está em
[`../../evidence/exemplos_verificados.txt`](../../evidence/exemplos_verificados.txt).

| dBm | Miliwatts | Watts | Contexto típico |
|---|---|---|---|
| −100 dBm | 1 × 10⁻¹⁰ mW | 1 × 10⁻¹³ W | Perto do limite de sensibilidade de um receptor móvel |
| −70 dBm | 1 × 10⁻⁷ mW | 1 × 10⁻¹⁰ W | Sinal Wi-Fi utilizável |
| −30 dBm | 0,001 mW | 1 µW | Sinal recebido forte |
| 0 dBm | 1 mW | 0,001 W | O ponto de referência, por definição |
| 13 dBm | 19,9526 mW | 0,02 W | Bluetooth Classe 1 |
| 20 dBm | 100 mW | 0,1 W | Emissor de um cliente Wi-Fi |
| 23 dBm | 199,526 mW | 0,2 W | Ligação ascendente de um telemóvel |
| 30 dBm | 1000 mW | 1 W | Exactamente 1 watt |
| 37 dBm | 5011,87 mW | 5,01187 W | Emissor de célula pequena |
| 43 dBm | 19 952,6 mW | 19,9526 W | Sector de estação base macro |
| 50 dBm | 100 000 mW | 100 W | Emissor de alta potência |

### As duas âncoras que vale a pena memorizar

| Âncora | Porque ajuda |
|---|---|
| **0 dBm = 1 mW** | É a definição. Tudo o resto decorre dela |
| **30 dBm = 1 W** | Porque 10·log₁₀(1000) = 30, exactamente |

Com essas duas, mais a regra de que **+10 dB é ×10** e **+3 dB é cerca de
×2**, consegues estimar a maioria das conversões de cabeça:

```
43 dBm = 30 dBm + 10 dB + 3 dB
       ≈ 1 W × 10 × 2
       ≈ 20 W        (valor exacto: 19,95 W)
```

Essa estimativa mental fica a menos de 0,25 % do valor exacto.

---

## Erros frequentes

| Erro | Consequência | Como evitar |
|---|---|---|
| Usar `20 × log₁₀` em vez de `10 × log₁₀` | O valor em dB duplica. 100 mW passa a «40 dBm» em vez de 20 dBm | O factor 20 é para **tensão**, nunca para potência |
| Esquecer a divisão por 1000 de mW para W | Resultado 1000 vezes maior | Lembrar que o dBm se refere a um **mili**watt |
| Tratar dBm como uma razão | «O ganho é de 20 dBm» não significa nada | Ganho mede-se em **dB**; potência absoluta em dBm |
| Somar valores em dBm para somar potências | 20 dBm + 20 dBm ≠ 40 dBm | Duas potências iguais combinam-se em **+3 dB**, dando 23,0103 dBm |
| Arredondar 3,0103 dB para 3 dB numa cadeia longa | O erro acumula-se ao longo de muitas etapas | Serve para estimativas mentais; usar o valor exacto em relatórios |

---

## Onde isto se usa na prática

- **Orçamentos de ligação.** A potência recebida é calculada em dBm, e só se
  converte para watts se alguma especificação de equipamento o exigir.
- **Conformidade regulamentar.** Os limites de potência de emissão são
  publicados em watts ou em dBm de PIRE, e é preciso comparar o mesmo com o
  mesmo.
- **Dimensionamento da alimentação.** A saída de radiofrequência de um
  amplificador em dBm, convertida para watts, dá a potência de saída;
  combinada com o rendimento, dá o consumo em corrente contínua.
- **Medições de laboratório.** Os analisadores de espectro leem em dBm; muitos
  medidores de potência leem em watts.

---

## Fazer isto sem erros de aritmética

Na aplicação **dB Konversor**: escreve o valor, põe a unidade de entrada em
`dBm` e a de saída em `W`. O resultado aparece à medida que escreves, e o
painel da fórmula mostra a cadeia completa que foi aplicada:

```
mW = 10^(dBm / 10)  |  W = mW / 1000
```

Ver os dois passos é o que faz diferença quando se está a aprender: é a
distinção entre obter um número e entender de onde veio. A aplicação funciona
sem ligação à Internet e não exige conta.

---

## Verificar por ti mesmo

Todos os valores deste artigo são reproduzíveis:

```powershell
dart run docs/evidence/gerar_exemplos.dart
```

Esse script executa o código de conversão de produção e compara cada
resultado com uma forma fechada deduzida independentemente, pelo que os
números aqui não foram transcritos à mão.

---

## Referências e leitura complementar

- **Definição de dBm:** IEEE Std 100, *The Authoritative Dictionary of IEEE
  Standards Terms* — dBm como potência referenciada a 1 mW.
- **Recomendações da ITU-R** usam dBm e dBW extensivamente para potência de
  emissão e intensidade de campo; ver a série V da ITU-R sobre terminologia e
  unidades.
- [dBm vs dBW: o significado dos 30 dB de diferença](03_dBm_vs_dBW.md)
- [`../02_Watts_to_dBm.md`](../02_Watts_to_dBm.md) — a conversão inversa (inglês)
- [`../06_power_levels_and_impedance.md`](../06_power_levels_and_impedance.md) — potência e impedância (inglês)
- [`../../MATRIZ_CONVERSOES.md`](../../MATRIZ_CONVERSOES.md) — todas as conversões
  que a aplicação suporta, com as condições de validade

> **Nota sobre os exemplos.** Todos os valores numéricos aqui são *exemplos de
> cálculo*, obtidos das fórmulas apresentadas. Não são medições de campo, e
> não se reivindicam dados de operadoras, resultados de laboratórios de ensaio
> nem estatísticas de rede. Os contextos indicados na tabela («típico de uma
> estação base macro») servem de orientação de ordem de grandeza, e não são
> especificações de nenhum produto concreto.
