# Estratégia ASO Global — dB Konversor

**Data:** 2026-10-17
**Estado:** plano inicial, **antes** de qualquer publicação

---

> ## AVISO METODOLÓGICO — LER PRIMEIRO
>
> Este documento **não contém volumes de pesquisa, classificações,
> concorrentes nem taxas de conversão**. A razão é simples: a aplicação nunca
> foi publicada, não há conta da Play Console com dados, e este ambiente não
> tem acesso a ferramentas de ASO.
>
> Tudo o que se segue está classificado como:
>
> | Etiqueta | Significado |
> |---|---|
> | **[FACTO]** | Verificado no código, no pacote compilado ou em documentação pública da plataforma |
> | **[HIPÓTESE]** | Suposição razoável sobre o mercado, **a confirmar com dados** |
> | **[A MEDIR]** | Indicador que só existirá depois da publicação |
>
> Inventar um número de pesquisas mensais seria mais prejudicial do que não
> ter nenhum: levaria a decisões de investimento baseadas em ficção.

---

## 1. Posicionamento

**[FACTO]** O que a aplicação é, verificado no código: um conversor de 7
unidades de potência e nível logarítmico, que apresenta a fórmula completa de
cada conversão, pede a impedância apenas quando é matematicamente necessária,
guarda um histórico local de 50 entradas, funciona sem permissão de rede e não
tem publicidade.

**Posicionamento escolhido:**

> A ferramenta de decibéis **correcta e explicável**, para quem precisa de
> confiar no número.

Esta formulação é deliberada. Não se compete em «mais unidades» nem em «mais
bonito», mas em duas coisas verificáveis: a **correcção** (sustentada por 146
testes automatizados com valores de referência independentes) e a
**explicabilidade** (a fórmula completa, visível).

**[HIPÓTESE]** Quem procura um conversor de dBm já tentou fazer a conta à mão
ou num conversor genérico e quer confirmar o resultado. A confiança é o
critério de escolha, não o número de funcionalidades.

---

## 2. Público-alvo por idioma

### Português (pt)

| | |
|---|---|
| **Mercados** | Angola, Brasil, Portugal, Moçambique, Cabo Verde |
| **[FACTO]** | É a língua da organização (KUNDIAMA, Angola) e do desenvolvimento original |
| **[HIPÓTESE] Público** | Estudantes de engenharia e técnicos de operadoras. Em Angola e Moçambique, o sector das telecomunicações emprega muitos técnicos formados localmente, com formação em português |
| **[HIPÓTESE] Intenção** | «conversor dBm», «dBm para watt», e consultas de estudo durante o semestre |
| **Vantagem** | Conhecimento directo do mercado; pouca concorrência com fichas em português bem feitas |
| **Prioridade** | **1 — mercado de origem** |

### Inglês (en)

| | |
|---|---|
| **Mercados** | Global; é a língua por omissão para quem não tem ficha no seu idioma |
| **[HIPÓTESE] Público** | Engenheiros de RF, radioamadores, engenheiros de áudio, estudantes de todo o mundo |
| **[HIPÓTESE] Intenção** | «dbm to watts» é a consulta mais provável deste domínio, em qualquer mercado |
| **Realidade competitiva [HIPÓTESE]** | É o idioma com mais concorrência: existem muitos conversores de unidades genéricos |
| **Prioridade** | **1 — maior alcance** |

### Francês (fr)

| | |
|---|---|
| **Mercados** | França, Bélgica, Suíça, Canadá, e **África francófona**: RDC, Costa do Marfim, Senegal, Camarões, Gabão |
| **[HIPÓTESE] Público** | Técnicos e estudantes de telecomunicações. A formação técnica nestes países é em francês e o sector está em expansão |
| **[HIPÓTESE] Oportunidade** | Menos aplicações técnicas bem localizadas em francês do que em inglês; a localização completa pode ser um diferenciador real |
| **Prioridade** | **2** |

### Espanhol (es)

| | |
|---|---|
| **Mercados** | Espanha, México, Colômbia, Argentina, Chile, Peru, Guiné Equatorial |
| **[HIPÓTESE] Público** | Grande população estudantil de engenharia; forte tradição de radioamadorismo em Espanha e na América Latina |
| **Nota de cobertura [FACTO]** | O texto da ficha inclui «vatios» (forma da RAE) **e** «watts» (uso internacional), porque ambos são usados por públicos diferentes — estudantes e profissionais |
| **Prioridade** | **2** |

### Chinês simplificado (zh)

| | |
|---|---|
| **[FACTO] Restrição decisiva** | **A Google Play não está disponível na China continental.** O público real desta ficha são falantes de chinês simplificado em Singapura, Malásia, Taiwan, Hong Kong e na diáspora |
| **[HIPÓTESE] Público** | Engenheiros e estudantes sinófonos fora da China continental |
| **[FACTO] Limitação de qualidade** | A tradução **não foi revista por falante nativo** (ver `../GUIA_LOCALIZACAO.md`) |
| **Decisão** | Manter a localização disponível — custo marginal zero, já está feita — mas **não investir em promoção** antes da revisão |
| **Prioridade** | **3 — passiva** |

> **Erro de planeamento que este documento evita:** usar a população da China
> como justificação para investir em chinês. Sem Google Play na China
> continental, esse número é irrelevante para esta aplicação. Chegar à China
> exigiria publicar em lojas como Huawei AppGallery ou Xiaomi GetApps, o que é
> um projecto separado com requisitos próprios de conformidade.

---

## 3. Intenção de pesquisa e palavras-chave

**[FACTO]** A Google Play **não tem campo de palavras-chave**. A indexação vem
do nome da aplicação, da descrição curta e da descrição completa. É por isso
que os símbolos das unidades aparecem no início da descrição curta de todas as
fichas.

### Três tipos de intenção

| Intenção | Exemplo de consulta | Como a ficha responde |
|---|---|---|
| **Conversão concreta** (a mais valiosa) | «dbm to watts», «dBm para watt» | Símbolos no início da descrição curta; secção «O que podes calcular» |
| **Ferramenta genérica** | «conversor de decibéis», «dB calculator» | Primeira linha da descrição completa |
| **Compreensão** | «o que é dBu», «diferença dBV dBu» | Resolvida pelos artigos de `../content/`, não pela ficha da loja |

**[HIPÓTESE]** A intenção de conversão concreta converte melhor em instalação
do que a genérica: quem escreve «dbm to watts» tem um problema imediato.

### Palavras-chave prioritárias por idioma

| Idioma | Prioritárias | Secundárias |
|---|---|---|
| pt | conversor dBm · dBm para watt · conversor decibéis · dBW | telecomunicações · radiofrequência · impedância · calculadora dB |
| en | dbm to watts · dbm converter · decibel converter · dBW converter | rf power · link budget · ham radio · audio engineering |
| fr | convertisseur dBm · dBm en watt · convertisseur décibels | radiofréquence · impédance · bilan de liaison |
| es | conversor dBm · dBm a vatios · dBm a watts · decibelios | radiofrecuencia · impedancia · balance de enlace |
| zh | 分贝换算 · dBm 转 瓦特 · 分贝计算器 | 射频 · 阻抗 · 对数电平 |

**Não usados, deliberadamente:** nomes de marcas de instrumentos
(Rohde & Schwarz, Keysight, Anritsu), porque é apropriação indevida de marca e
pode levar à remoção da ficha; nomes de normas que a aplicação não implementa;
e repetição artificial do tipo «dBm dBm converter dBm», que a Google penaliza
e que piora a leitura.

---

## 4. Diferenciação face a calculadoras genéricas

**[FACTO]** A diferença técnica real, verificável no código:

| Comportamento | Calculadora de unidades genérica | dB Konversor |
|---|---|---|
| dBm → dBV | Trata como conversão de factor fixo, ou não suporta | Exige a impedância, porque `V = √(P·R)` |
| Impedância | Assume 50 Ω em silêncio, ou pede sempre | Pede **só** nas conversões que a exigem |
| Fórmula | Não mostra | Mostra a cadeia completa de passos |
| `0 mW → dBm` | Devolve `-Infinity`, `NaN` ou `0` | Rejeita com a explicação de que `log10(0)` não está definido |
| Potências baixas | Sem garantia | Verificado por teste até −130 dBm |

**[FACTO]** O ponto sobre a impedância não é marketing: é a distinção entre
uma grandeza de potência e uma de tensão, e é um erro conceptual comum
(descrito em `../content/07_common_conversion_mistakes.md`).

**Mensagem central:**

> Uma calculadora converte números. O dB Konversor sabe que dBm e dBV são
> grandezas diferentes, e que passar de uma para a outra exige a impedância.

---

## 5. Estratégia de capturas de ecrã

**[FACTO]** As capturas são o elemento visual mais influente numa ficha, e as
duas primeiras são as que aparecem sem o utilizador deslizar.

**Ordem decidida** (ver [`screenshots/PLANO_CAPTURAS.md`](screenshots/PLANO_CAPTURAS.md)):

| # | Conteúdo | Porque esta posição |
|---|---|---|
| 1 | Conversor com um resultado real | Mostra imediatamente o que a aplicação faz |
| 2 | Diálogo da fórmula aberto | É o diferenciador principal; tem de estar antes do deslizamento |
| 3 | Campo de impedância visível | Prova a competência técnica |
| 4 | Menu com as 7 unidades | Responde a «suporta a minha unidade?» |
| 5 | Histórico com entradas | Funcionalidade concreta |
| 6 | Disposição em tablet | Sinaliza suporte de tablet |

**Regras aplicadas:**

- **[FACTO]** Capturas da aplicação **realmente executada**, nunca maquetas
  promocionais apresentadas como produto.
- **[FACTO]** Resultados **reais**, não alterados. Um valor inventado numa
  captura é uma declaração falsa, e é verificável por qualquer pessoa que
  instale a aplicação.
- Texto sobreposto curto, máximo 6 palavras, legível na miniatura.
- Identidade visual preservada: fundo azul-escuro, destaques em ciano.

---

## 6. Estratégia de avaliações legítimas

**[FACTO]** A Google proíbe comprar, incentivar ou solicitar avaliações
selectivamente positivas. A violação pode levar à remoção da aplicação.

**O que será feito:**

1. **Qualidade primeiro.** A correcção do defeito M1 é a medida mais eficaz
   para evitar avaliações negativas: um utilizador que detecte um erro de
   18 dB escreve uma avaliação de uma estrela e não volta.
2. **Pedido neutro, no momento certo** [a implementar numa versão futura]:
   após várias conversões bem-sucedidas, um convite discreto a avaliar, sem
   condicionar o sentido da avaliação e sem bloquear o uso.
3. **Resposta a todas as avaliações**, incluindo e sobretudo as negativas, com
   o problema identificado e, quando aplicável, a versão que o corrige.
4. **Canal de contacto visível** no ecrã de Ajuda, para que um problema chegue
   por e-mail antes de chegar como avaliação pública.

**O que não será feito:** comprar avaliações, pedir «5 estrelas», mostrar o
pedido de avaliação apenas a quem demonstrou satisfação, ou usar famílias e
colegas para encher a ficha de avaliações iniciais.

---

## 7. Indicadores a acompanhar

**[A MEDIR]** Nenhum destes valores existe ainda. A coluna «referência» fica
deliberadamente vazia: será preenchida com os dados das primeiras semanas, e
só então se poderá falar de melhoria.

| Indicador | Onde se obtém | Referência | O que indica |
|---|---|---|---|
| Visualizações da ficha | Play Console → Aquisição | — | Alcance da pesquisa |
| Taxa de conversão (visualização → instalação) | Play Console | — | Eficácia do nome, ícone e capturas |
| Instalações por idioma | Play Console → Países | — | Que localizações valem investimento |
| Consultas de pesquisa que levaram à ficha | Play Console → Aquisição → Pesquisa | — | **O indicador mais importante:** substitui as hipóteses da secção 3 por factos |
| Taxa de desinstalação a 7 e 30 dias | Play Console | — | Se a aplicação cumpre o que a ficha promete |
| Classificação média e distribuição | Play Console | — | Satisfação |
| Falhas e ANR | Play Console → Vitals | — | Estabilidade; deve ser ≈ 0, dada a simplicidade da aplicação |
| Retenção (regresso ao 7.º dia) | Play Console | — | Se é ferramenta recorrente ou de uso único |

**[HIPÓTESE]** A retenção de uma ferramenta de conversão é naturalmente baixa
em comparação com uma aplicação social: as pessoas abrem-na quando precisam.
Uma retenção baixa **não** indica por si falha de produto. O indicador mais
relevante é a **taxa de desinstalação precoce**, que sugere expectativa não
cumprida.

---

## 8. Plano de experimentação

**[FACTO]** A Play Console permite testes A/B de ficha («Store listing
experiments»), com significância estatística calculada pela própria Google.

**Regra:** uma experiência por vez, por cada elemento. Mudar o ícone e as
capturas ao mesmo tempo torna impossível saber qual produziu o efeito.

| Ordem | Experiência | Variante A | Variante B | Hipótese a testar |
|---|---|---|---|---|
| 1 | Descrição curta (pt) | Começa pelos símbolos: `Conversor de dBm, dBW, W, dBV e dBu…` | Começa pelo benefício: `Converta decibéis com a fórmula à vista…` | Os símbolos convertem melhor do que o benefício abstracto? |
| 2 | Primeira captura | Conversor simples (dBm → W) | Conversor com a fórmula visível | A fórmula é um gancho suficientemente forte para a primeira posição? |
| 3 | Nome (zh) | `dB Konversor` | `dB Konversor 分贝换算` | Um subtítulo em chinês melhora a descoberta? |
| 4 | Ícone | Actual | Variante com `dB` mais destacado | Legibilidade na miniatura |

**Antes de começar:** só vale a pena testar A/B com tráfego suficiente para
significância estatística. Com poucas visualizações por semana, uma
experiência não conclui nada e só atrasa. **[HIPÓTESE]** Esperar pelas
primeiras semanas de dados antes da experiência 1.

---

## 9. Critérios para decidir em que mercados investir

Esta é a secção que impede decisões por intuição. Os critérios são
**condicionais**: só se aplicam quando houver dados.

### Regra de decisão

Revisão **ao fim de 8 semanas** de publicação, por idioma:

| Observação nos dados | Decisão |
|---|---|
| Boa taxa de conversão **e** volume de visualizações relevante | **Investir**: afinar a ficha, produzir conteúdo técnico nesse idioma, considerar experiências A/B |
| Volume relevante **mas** conversão baixa | **Corrigir a ficha**, não abandonar o mercado: o problema está na apresentação, não na procura |
| Volume baixo **mas** boa conversão | **Manter**: nicho pequeno e satisfeito; investir em descoberta (conteúdo, SEO) antes da ficha |
| Volume baixo **e** conversão baixa | **Manter passivo**: a localização já está feita e não custa nada; não investir mais |
| Taxa de desinstalação elevada | **Prioridade absoluta ao produto**, não ao ASO: a ficha está a prometer algo que a aplicação não cumpre |

### Ordem de investimento inicial

**[HIPÓTESE]**, a revalidar com dados:

1. **Português e inglês** — língua de origem e maior alcance
2. **Francês e espanhol** — grandes mercados técnicos, menor concorrência localizada
3. **Chinês** — passivo, até haver revisão nativa

### O que mudaria esta ordem

- Se os dados de pesquisa mostrarem procura concentrada num idioma não
  previsto (por exemplo alemão ou russo), acrescentar esse idioma é uma
  operação de baixo custo: o guia de localização descreve o procedimento.
- Se a África francófona mostrar conversão alta, o francês sobe para
  prioridade 1 — é um mercado onde a KUNDIAMA tem proximidade geográfica e
  cultural.

---

## 10. Articulação com os conteúdos técnicos

**[FACTO]** A ficha da loja responde a quem já procura um conversor. Os
artigos de [`../content/`](../content/) respondem a quem procura **entender** o
problema — «porque é que dBm e dBW diferem de 30 dB?» — e que ainda não sabe
que precisa de uma aplicação.

| Canal | Intenção que capta | Instrumento |
|---|---|---|
| Ficha da Google Play | «quero um conversor» | Descrições, capturas |
| Artigos técnicos | «quero entender» | 8 artigos de `../content/` |
| Pesquisa na Web | ambas | SEO dos artigos, com ligação para a aplicação |

Esta separação evita o erro de encher a descrição da loja com explicações
teóricas, que não é o que a pesquisa da loja recompensa, nem o que o
utilizador da loja quer ler.

---

## 11. Resumo honesto do estado

| Elemento | Estado |
|---|---|
| Fichas nos 5 idiomas | **Preparadas e verificadas** contra os limites de caracteres |
| Palavras-chave incorporadas no texto | **Feito** |
| Capturas de ecrã | **NÃO geradas** — não há emulador nem dispositivo neste ambiente |
| Ícone | Existe (`assets/icons/app_icon.png`), configurado |
| *Feature graphic* (1024 × 500) | **NÃO criado** — material distinto das capturas, ver `screenshots/PLANO_CAPTURAS.md` |
| Dados de mercado | **Nenhuns** — a aplicação não está publicada |
| Experiências A/B | **Planeadas**, não iniciadas |
| Conta da Play Console | Fora do âmbito desta auditoria |
