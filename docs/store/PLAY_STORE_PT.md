# Ficha da Google Play — Português (pt-PT)

**Aplicação:** dB Konversor
**Pacote:** `ao.kundiama.dbkonversor`
**Idioma da ficha:** Português (Portugal) — usar também para pt-BR com as notas da secção 9
**Data:** 2026-10-17

> **Limites de caracteres da Google Play** (verificados com o script
> [`verificar_limites.py`](verificar_limites.py), que conta os caracteres de
> todos os textos deste ficheiro): nome 30, descrição curta 80, descrição
> completa 4000. Os limites estão sujeitos a alteração pela Google; o script
> permite reverificar a qualquer momento.

---

## 1. Nome da aplicação (máx. 30)

```
dB Konversor
```

**12 caracteres.**

Alternativa, se for preciso reforçar as palavras-chave no nome:

```
dB Konversor: dBm, W, dBV
```

**25 caracteres.** Não é a opção recomendada: o nome limpo é mais forte como
marca, e as palavras-chave já estão na descrição curta, que é indexada.

---

## 2. Descrição curta (máx. 80)

```
Conversor de dBm, dBW, W, dBV e dBu com fórmulas. Offline, sem anúncios.
```

**72 caracteres.**

Alternativas testadas:

| Texto | Caracteres | Avaliação |
|---|---|---|
| `Conversor de dBm, dBW, W, dBV e dBu com fórmulas. Offline, sem anúncios.` | 72 | **Recomendada.** Unidades (procura real) + 2 diferenciadores |
| `Converta dBm, dBW, watts, dBV e dBu. Fórmulas visíveis e histórico local.` | 73 | Boa; troca «offline» por «histórico» |
| `Calculadora de decibéis para telecomunicações, áudio e radiofrequência.` | 71 | Mais genérica; perde os símbolos que as pessoas realmente escrevem |

A descrição curta **é indexada** pela pesquisa da Play e aparece no resultado
de pesquisa. Daí começar pelos símbolos das unidades.

---

## 3. Descrição completa (máx. 4000)

```
O dB Konversor converte unidades de potência e níveis logarítmicos usados todos
os dias em telecomunicações, electrónica, radiofrequência e áudio.

Escreve o valor, escolhe a unidade de entrada e a de saída, e o resultado
aparece imediatamente. Sem anúncios, sem conta e sem ligação à Internet.


UNIDADES SUPORTADAS

• dBm — potência referenciada a 1 mW
• dBW — potência referenciada a 1 W
• W — watt
• mW — miliwatt
• dBV — nível de tensão referenciado a 1 V
• dBu — nível de tensão referenciado a 0,775 V
• dB — razão logarítmica, a partir de uma referência que indicas


O QUE PODES CALCULAR

• dBm para watts e watts para dBm
• dBm para dBW e dBW para dBm
• dBV para dBu e dBu para dBV
• Potência para nível de tensão, indicando a impedância (50 Ω, 75 Ω, 600 Ω, 8 Ω
  ou outra)
• Ganhos e perdas em dB, a partir de uma referência à tua escolha


A FÓRMULA ESTÁ SEMPRE À VISTA

Cada resultado traz a fórmula que foi aplicada, com todos os passos. Numa
conversão de dBm para dBV vês a cadeia completa:

mW = 10^(dBm / 10)  |  V = √(P × R)  |  dBV = 20 × log10(V)

É por isso que a aplicação serve para estudar, e não apenas para obter um
número. Quem está a aprender vê o caminho; quem já sabe confirma que o cálculo
é o que espera.


IMPEDÂNCIA PEDIDA SÓ QUANDO É PRECISA

Converter potência em nível de tensão exige conhecer a impedância, porque
V = √(P × R). Converter dBm em watts não exige. A aplicação pede a impedância
apenas nas conversões em que ela é mesmo necessária, em vez de a exigir sempre
ou de assumir 50 Ω em silêncio.


HISTÓRICO GUARDADO NO TEU TELEMÓVEL

As últimas 50 conversões ficam registadas, com a data, para consultares
depois. Ficam só no teu dispositivo, podes apagá-las quando quiseres, e nunca
são enviadas para lado nenhum.


FUNCIONA SEM INTERNET

A versão publicada nem sequer pede permissão de acesso à rede. Todos os
cálculos são feitos no telemóvel. Funciona numa torre de telecomunicações, numa
cave, num laboratório ou num avião.


PARA QUEM É

• Estudantes de telecomunicações, electrónica e engenharia electrotécnica
• Professores, para mostrar a relação entre escalas lineares e logarítmicas
• Técnicos de instalação e manutenção de redes
• Engenheiros de radiofrequência e de telecomunicações
• Técnicos de som e engenheiros de áudio
• Radioamadores


RIGOR DO CÁLCULO

As conversões são verificadas por uma bateria de testes automatizados, com
valores de referência calculados de forma independente da implementação. Os
cálculos usam precisão dupla e, em vez de devolverem um resultado duvidoso
quando o valor sai fora da gama representável, mostram uma mensagem clara a
explicar o que se passou.


IDIOMAS

Português, inglês, francês, espanhol e chinês simplificado.


Desenvolvido pela KUNDIAMA Tecnologia e Inovação.
```

**2 767 caracteres**, dentro do limite de 4000.

### Porque não está cheia até aos 4000

Encher a descrição com repetições de palavras-chave já não ajuda a
classificação na Play e prejudica a leitura, que é o que determina a
instalação. O texto cobre as palavras-chave de forma natural, dentro de frases
que informam.

---

## 4. Lista de funcionalidades (para o formulário e para as capturas)

Apenas funcionalidades **verificadas no código**:

1. Conversão entre 7 unidades: W, mW, dBm, dBW, dBu, dBV e dB
2. Fórmula completa apresentada em cada conversão, com todos os passos
3. Campo de impedância, pedido apenas nas conversões que o exigem
4. Campo de referência para conversões relativas em dB
5. Botão de inversão de unidades
6. Resultado actualizado à medida que se escreve
7. Histórico das últimas 50 conversões, guardado no dispositivo
8. Eliminação do histórico pelo utilizador, com confirmação
9. Menu de consulta com a descrição de cada unidade
10. Política de Privacidade consultável dentro da aplicação
11. Cinco idiomas
12. Funciona sem ligação à Internet
13. Sem anúncios e sem conta de utilizador

**Deliberadamente não declarado:** «resultados certificados», «precisão
absoluta», «aprovado por norma X», número de utilizadores, ou qualquer
funcionalidade que não exista.

---

## 5. Termos de pesquisa relevantes

A Google Play não tem um campo de palavras-chave: a indexação vem do nome, da
descrição curta e da descrição completa. Estes termos foram incorporados
naturalmente no texto.

**Prioritários** (intenção de procura directa):

| Termo | Onde aparece |
|---|---|
| conversor dBm | descrição curta e completa |
| dBm para watt | secção «O que podes calcular» |
| dBm para W | idem |
| watt para dBm | idem |
| dBW | nome das unidades, várias vezes |
| dBV dBu | secção de unidades e de conversões |
| conversor decibéis | primeira linha |
| calculadora dB | descrição curta alternativa |

**Secundários** (contexto e público):

telecomunicações · radiofrequência · potência RF · nível de tensão ·
impedância · 50 ohm · 600 ohm · áudio · ganho · perda · engenharia ·
electrónica · fórmula

**Evitados de propósito:** termos de marcas de instrumentos (Rohde & Schwarz,
Keysight), nomes de normas que a aplicação não implementa, e repetições
artificiais do tipo «dBm dBm converter dBm».

---

## 6. Proposta de valor (uma frase)

> O conversor de decibéis que mostra a fórmula, pede a impedância só quando
> ela é necessária, e funciona sem Internet nem anúncios.

---

## 7. Textos para as capturas de ecrã

Um texto curto por captura, sobreposto à imagem real da aplicação. Máximo
recomendado: 6 palavras, legível num ecrã pequeno.

| # | Ecrã | Texto principal | Subtexto |
|---|---|---|---|
| 1 | Conversor com dBm → W | **Converte decibéis num instante** | 7 unidades, resultado imediato |
| 2 | Diálogo da fórmula aberto | **Vê a fórmula, não só o número** | Todos os passos do cálculo |
| 3 | Conversão com campo de impedância | **Impedância só quando é precisa** | 50 Ω, 75 Ω, 600 Ω ou a tua |
| 4 | Menu lateral com as unidades | **dBm, dBW, dBV, dBu, W, mW, dB** | Com a referência de cada uma |
| 5 | Histórico com conversões | **O teu histórico, no teu telemóvel** | Nunca sai do dispositivo |
| 6 | Conversor em modo tablet | **Sem anúncios. Sem Internet.** | Funciona em qualquer lado |

Ver [`screenshots/PLANO_CAPTURAS.md`](screenshots/PLANO_CAPTURAS.md) para as
dimensões e o procedimento de captura.

---

## 8. Mensagem de diferenciação

Face a uma calculadora genérica:

> Uma calculadora converte números. O dB Konversor sabe que dBm e dBV são
> grandezas **diferentes** — uma é potência, a outra é tensão — e que passar de
> uma para a outra exige conhecer a impedância. É por isso que pede a
> impedância nessas conversões, e só nessas.

Face a outros conversores de decibéis:

> Mostra a fórmula completa de cada conversão, não pede permissões nenhumas e
> guarda o histórico sem o enviar para lado nenhum.

---

## 9. Notas sobre terminologia

| Termo | Escolha | Porquê |
|---|---|---|
| decibéis | com acento, plural | Forma correcta em português europeu |
| miliwatt | um «l» | Forma portuguesa (ingl. *milliwatt*) |
| impedância | — | Termo técnico padrão |
| telemóvel | — | Português europeu. **Em pt-BR: «celular»** |
| ecrã | — | Português europeu. **Em pt-BR: «tela»** |
| «Offline» | mantido em inglês na descrição curta | É compreendido universalmente e é curto; no corpo do texto usa-se «sem ligação à Internet» |
| dBm, dBW, dBV, dBu, W, mW, Ω | **nunca traduzidos** | Notação técnica internacional; é assim que as pessoas procuram |

### Se for criada uma ficha separada para pt-BR

Trocar: telemóvel → celular · ecrã → tela · «à tua escolha» → «à sua escolha»
(o tratamento por «você» é mais natural no Brasil) · manter todos os símbolos
técnicos inalterados.

---

## 10. Campos administrativos da ficha

| Campo | Valor | Estado |
|---|---|---|
| Categoria | Ferramentas (*Tools*) | Decidido. Alternativa: Educação, se o foco for estudantil |
| Etiquetas | Calculadora, Engenharia, Utilidades | — |
| Classificação de conteúdo | Para todos (sem conteúdo sensível) | A obter respondendo ao questionário da Play Console |
| E-mail de contacto | diassilua.simao@gmail.com | Confirmado pelo proprietário |
| Sítio web | — | **PENDENTE** |
| URL da Política de Privacidade | — | **PENDENTE** — ver [`../privacy/GUIA_DATA_SAFETY.md`](../privacy/GUIA_DATA_SAFETY.md) |
| Contém anúncios | **Não** | Verificado: nenhum SDK de publicidade |
| Compras na aplicação | **Não** | Verificado |
