# Plano Editorial Global — dB Konversor

**Data:** 2026-10-17
**Estado:** 8 artigos base escritos; traduções prioritárias iniciadas

---

## 1. Objectivo e princípio

Os conteúdos técnicos existem para **resolver um problema concreto a quem o
tem**, e não para promover a aplicação. A promoção é consequência: quem resolve
o problema com a ajuda de um artigo bem feito instala a ferramenta por sua
iniciativa.

Isto tem uma implicação prática que condiciona todo o plano:

> Cada artigo tem de ser útil **mesmo para quem nunca instala a aplicação**. Se
> um artigo só funciona como anúncio, está mal escrito.

A menção à aplicação aparece numa secção própria («Doing it in the app»), onde
diz o que a aplicação faz e nada mais. Sem superlativos, sem comparações com
produtos que não foram testados, sem promessas de precisão absoluta.

---

## 2. Público-alvo

| Segmento | O que procura | Artigos que o servem |
|---|---|---|
| **Estudante de engenharia** | Entender porque é 10 e não 20; passar no exame | 01, 02, 05, 07 |
| **Professor** | Material para explicar escalas logarítmicas | 05, 06, 07 |
| **Técnico de instalação** | Converter rapidamente para preencher um relatório | 01, 02, 08 |
| **Engenheiro de RF** | Confirmar uma conversão; orçamento de ligação | 03, 06, 08 |
| **Engenheiro de áudio** | Resolver a confusão dBu/dBV; estrutura de ganho | 04, 06 |
| **Radioamador** | dBm, dBW, ganho de antena, perdas de cabo | 01, 03, 08 |

**[HIPÓTESE]** O segmento mais numeroso é o estudante, e o que mais
provavelmente instala a aplicação é o técnico — o primeiro tem tempo para
procurar, o segundo precisa de velocidade. Os artigos servem ambos: explicação
completa para quem lê, tabela de referência no topo para quem só quer o
número.

---

## 3. Estado dos artigos

### Artigos base (inglês)

Todos escritos, com exemplos numéricos verificados contra formas fechadas
independentes.

| # | Ficheiro | Tema | Palavras-chave principais |
|---|---|---|---|
| 01 | [`01_dBm_to_Watts.md`](01_dBm_to_Watts.md) | dBm → W | dbm to watts, dbm to w |
| 02 | [`02_Watts_to_dBm.md`](02_Watts_to_dBm.md) | W → dBm | watts to dbm |
| 03 | [`03_dBm_vs_dBW.md`](03_dBm_vs_dBW.md) | O desvio de 30 dB | dbm vs dbw, dbw to dbm |
| 04 | [`04_dBV_vs_dBu.md`](04_dBV_vs_dBu.md) | O desvio de 2,2 dB | dbu vs dbv, dbu to dbv |
| 05 | [`05_decibels_in_telecommunications.md`](05_decibels_in_telecommunications.md) | Fundamentos | what is a decibel, db explained |
| 06 | [`06_power_levels_and_impedance.md`](06_power_levels_and_impedance.md) | Potência ↔ tensão | dbm to dbv, impedance conversion |
| 07 | [`07_common_conversion_mistakes.md`](07_common_conversion_mistakes.md) | Erros frequentes | db conversion errors |
| 08 | [`08_practical_telecommunications_examples.md`](08_practical_telecommunications_examples.md) | Problemas resolvidos | link budget example, db calculation examples |

### Matriz de traduções

| # | EN | PT | FR | ES | ZH |
|---|---|---|---|---|---|
| 01 | ✔ base | ✔ [`pt/`](pt/01_dBm_para_Watts.md) | ✔ [`fr/`](fr/01_dBm_vers_Watts.md) | ✔ [`es/`](es/01_dBm_a_Vatios.md) | **pendente** |
| 02 | ✔ base | pendente | pendente | pendente | pendente |
| 03 | ✔ base | ✔ [`pt/`](pt/03_dBm_vs_dBW.md) | pendente | pendente | pendente |
| 04 | ✔ base | pendente | pendente | pendente | pendente |
| 05 | ✔ base | pendente | pendente | pendente | pendente |
| 06 | ✔ base | pendente | pendente | pendente | pendente |
| 07 | ✔ base | pendente | pendente | pendente | pendente |
| 08 | ✔ base | pendente | pendente | pendente | pendente |

**Critério usado para escolher as traduções feitas primeiro:** o artigo 01
(`dBm → W`) é o que responde à consulta mais provável deste domínio, e o 03
(`dBm vs dBW`) responde a um erro que custa 30 dB. São os dois com melhor
relação entre esforço e utilidade.

**Chinês:** nenhuma tradução de conteúdo foi feita. Motivo coerente com o
resto do projecto: a tradução da interface ainda aguarda revisão por falante
nativo, e traduzir oito artigos técnicos sem essa validação produziria
conteúdo de qualidade não verificável. Ver
[`../GUIA_LOCALIZACAO.md`](../GUIA_LOCALIZACAO.md), secção 9.

---

## 4. Temas prioritários para novos artigos

Ordenados por **[HIPÓTESE]** de procura cruzada com a capacidade da aplicação
de responder.

| Prioridade | Tema proposto | Porquê | A aplicação ajuda? |
|---|---|---|---|
| 1 | Como ler a sensibilidade de um receptor | Liga −100 dBm a «funciona ou não funciona» | Sim, directamente |
| 2 | Perdas de cabo coaxial: calcular a perda total | Problema diário de instalação | Parcialmente (soma em dB é manual) |
| 3 | dBi, dBd e dBic: ganhos de antena | Unidades frequentemente confundidas | Não — fica claro que não as suporta |
| 4 | Orçamento de ligação passo a passo | Expande o problema 2 do artigo 08 | Sim, nas conversões |
| 5 | VSWR, perda de retorno e potência refletida | Muito procurado; liga-se a dB | Não directamente |
| 6 | dBFS e a escala digital em áudio | Completa a família de áudio | Não — unidade não suportada |
| 7 | Porque é que 3 dB não é exactamente o dobro | Curiosidade técnica com valor pedagógico | Sim |

**Regra honesta:** quando um artigo trata de unidades que a aplicação **não**
suporta (dBi, dBFS, VSWR), tem de o dizer explicitamente. Atrair alguém com um
artigo sobre dBi para depois lhe oferecer uma aplicação que não converte dBi é
um desperdício do tempo dessa pessoa e prejudica a confiança.

---

## 5. Calendário inicial

**[HIPÓTESE]** de capacidade: um artigo novo ou duas traduções por quinzena,
assumindo que a redacção é feita pela mesma pessoa que desenvolve. É uma
estimativa de esforço, não um compromisso.

| Quinzena | Trabalho | Resultado |
|---|---|---|
| 1 | Traduções PT dos artigos 02 e 04 | Mercado de origem coberto nos 4 artigos de conversão |
| 2 | Traduções FR e ES do artigo 03 | Os dois mercados secundários com os 2 artigos principais |
| 3 | Artigo novo: sensibilidade de receptor (EN) | Tema de prioridade 1 |
| 4 | Traduções PT dos artigos 05 e 07 | Material pedagógico em português |
| 5 | Artigo novo: perdas de cabo coaxial (EN) | Tema de prioridade 2 |
| 6 | **Revisão**: medir o que foi publicado antes de continuar | Decisão informada em vez de calendário cego |

A quinzena 6 é deliberada. Produzir conteúdo durante três meses sem olhar para
os dados é a forma mais eficaz de escrever oito artigos que ninguém procura.

---

## 6. Formatos

| Formato | Estado | Nota |
|---|---|---|
| **Artigo técnico em Markdown** | **Em uso** | Formato base, versionável, legível no GitHub |
| Página web (HTML) | Não iniciado | Depende de existir um sítio; a mesma decisão pendente da URL da política de privacidade |
| Tabela de referência imprimível (PDF) | Ideia | Uma folha A4 com as âncoras e os desvios; útil em laboratório |
| Vídeo curto | Não previsto | Custo elevado, benefício não demonstrado para este público |
| Fio em rede social | Ideia | Os artigos 03 e 07 adaptam-se bem a formato curto |

**Decisão:** manter Markdown como fonte única. Qualquer outro formato deriva
dele, para que não haja duas versões do mesmo conteúdo a divergir — exactamente
o problema que esta auditoria encontrou no código (dois formatadores
numéricos, defeito M6).

---

## 7. Estratégia de SEO

**[FACTO]** sobre a estrutura já aplicada nos 8 artigos:

| Elemento | Como foi feito |
|---|---|
| **Título** | Contém a consulta provável: «How to Convert dBm to Watts» |
| **Primeira secção** | «The problem» — um cenário concreto, não uma definição de dicionário |
| **Fórmula destacada** | Em bloco de código, fácil de copiar |
| **Tabela de referência** | Responde à consulta sem obrigar a ler o artigo todo |
| **Ligações internas** | Cada artigo liga aos relacionados, formando um conjunto coerente |
| **Referências externas** | ITU-R, IEEE Std 100, IEC 60268 — fontes verificáveis |
| **Aviso sobre os exemplos** | Todos os artigos terminam a distinguir exemplo de cálculo de medição |

**[HIPÓTESE]** A intenção «dbm to watts» é informativa e transaccional ao mesmo
tempo: a pessoa quer o número agora. Daí a tabela de referência aparecer cedo,
antes das secções de interpretação.

**O que não foi feito e não será:** encher o texto de repetições da
palavra-chave, inventar contagens de utilizadores, afirmar primeiro lugar em
nada, ou criar artigos que só existem para ligar à aplicação.

---

## 8. Métricas de sucesso

**[A MEDIR]** — nenhum destes valores existe; os artigos não estão publicados
em nenhum sítio web.

| Métrica | Onde se obteria | O que indica |
|---|---|---|
| Visitas por artigo | Analítica do sítio (quando existir) | Que temas têm procura |
| Consultas de entrada | Google Search Console | Substitui as hipóteses da secção 4 por factos |
| Tempo na página | Analítica | Se o artigo responde ou se a pessoa desiste |
| Taxa de saída da secção da aplicação | Analítica | Se a menção à aplicação é relevante ou intrusiva |
| Instalações atribuíveis | Comparação temporal com a Play Console | Ligação entre conteúdo e produto |

**Aviso metodológico:** sem um sítio publicado, não há analítica. Os artigos
existem hoje como documentação do repositório, o que já tem valor (qualquer
pessoa que avalie o projecto no GitHub vê o rigor técnico), mas não gera
métricas de audiência.

---

## 9. Processo de revisão técnica

Nenhum artigo é publicado sem passar por estes quatro passos. Os três
primeiros já foram aplicados aos 8 artigos existentes.

| Passo | Como | Estado nos 8 artigos |
|---|---|---|
| **1. Verificação numérica** | Todo o valor é calculado por script e comparado com uma forma fechada independente | **Feito** — [`../evidence/gerar_exemplos.dart`](../evidence/gerar_exemplos.dart) |
| **2. Coerência com a aplicação** | O que o artigo diz que a aplicação faz tem de corresponder ao código | **Feito** — confrontado com [`../MATRIZ_CONVERSOES.md`](../MATRIZ_CONVERSOES.md) |
| **3. Separação entre exemplo e medição** | Todo o artigo declara explicitamente que os números são exemplos de cálculo | **Feito** — nota final em todos |
| **4. Revisão por um segundo técnico** | Leitura por alguém que não escreveu o texto | **PENDENTE** — nenhum dos 8 foi revisto por terceiros |

### Erros encontrados e corrigidos por este processo

O passo 1 não é cerimónia. Durante a redacção destes artigos detectou e
corrigiu dois erros reais:

| Erro | Onde | Correcção |
|---|---|---|
| `20 W − 4 dB` calculado como 7,94328 W | Artigo 02 | Valor correcto 7,96214 W. A origem do erro foi usar 43 dBm arredondado em vez de 43,0103 dBm |
| Coluna linear incoerente com a coluna em dB | Artigo 05 | Factores recalculados: 0,3981 / 50,12 / 7,039 × 10⁻¹² / 1,585 |
| Média de 50,5 mW dada como 17,0332 dBm | Artigo 02 | Valor correcto 17,0329 dBm |

Fica registado porque demonstra que o processo funciona — e porque um artigo
sobre erros de conversão que contivesse erros de conversão seria uma ironia
caríssima.

---

## 10. Processo de tradução

| Passo | Regra |
|---|---|
| 1 | **Nunca traduzir os símbolos** — `dB`, `dBm`, `dBW`, `dBV`, `dBu`, `W`, `mW`, `V`, `Ω`. Ver [`../GUIA_LOCALIZACAO.md`](../GUIA_LOCALIZACAO.md), secção 5.1 |
| 2 | **Nunca traduzir as fórmulas** nem recalcular os valores: os números são os mesmos em todos os idiomas |
| 3 | **Adaptar o separador decimal no texto corrido** — `0,775 V` em pt/fr/es, `0.775 V` em en/zh |
| 4 | **Usar a terminologia fixada** na tabela do guia de localização (potência/puissance/potencia, tensão/tension/tensión) |
| 5 | **Adaptar o exemplo ao mercado**, se melhorar a relevância, mas sem inventar dados |
| 6 | **Manter a nota final** sobre exemplos de cálculo em todas as traduções |
| 7 | **Revalidar as ligações internas** entre artigos traduzidos |

### Nomes dos ficheiros traduzidos

Traduzidos, porque o nome do ficheiro faz parte do endereço e portanto da
pesquisa:

```
pt/01_dBm_para_Watts.md
fr/01_dBm_vers_Watts.md
es/01_dBm_a_Vatios.md
```

O número de ordem mantém-se, para que a correspondência entre versões seja
imediata.

---

## 11. Resumo honesto do estado

| Item | Estado |
|---|---|
| 8 artigos base em inglês | **Escritos**, com exemplos verificados |
| Verificação numérica | **Feita** por script, contra formas fechadas independentes |
| Traduções | **4 feitas** (PT 01 e 03, FR 01, ES 01); 36 pendentes |
| Revisão por segundo técnico | **PENDENTE** nos 8 |
| Tradução chinesa de conteúdos | **Não iniciada**, por decisão fundamentada |
| Publicação num sítio web | **Não feita** — não existe sítio |
| Métricas | **Nenhumas** — nada publicado |
| Calendário | **Definido** para 6 quinzenas, com ponto de revisão |
