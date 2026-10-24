---
name: Nova unidade ou funcionalidade
about: Propor uma unidade de conversão ou funcionalidade nova
title: '[PROPOSTA] '
labels: ['enhancement']
assignees: ''
---

## O que propõe

<!-- Uma frase. -->

## Se for uma unidade nova

| Campo | Valor |
|---|---|
| Símbolo (ex.: `dBi`, `dBFS`, `dBμV`) | |
| Grandeza física | <!-- potência / tensão / corrente / ganho / razão / outra --> |
| Valor de referência | <!-- ex.: 1 µV, radiador isotrópico, escala digital --> |
| Fórmula de conversão | |
| Factor: 10 ou 20? | <!-- 10 para potência, 20 para tensão --> |
| Precisa de impedância? | |
| Norma ou fonte que a define | |

### Unidades já consideradas e deliberadamente não suportadas

Antes de propor, verifique a secção 7 de
[`docs/MATRIZ_CONVERSOES.md`](../../docs/MATRIZ_CONVERSOES.md). Estas foram
avaliadas e ficaram de fora, com razões registadas:

| Unidade | Razão de não estar suportada |
|---|---|
| `dBi`, `dBd` | Ganho de antena; exigiria um modelo de radiação |
| `dBc` | Caso particular de dB com referência; obtém-se com `dB` + referência |
| `dBFS` | Depende do formato e da profundidade de bits do sistema digital |
| `dBSPL` | Grandeza acústica (referência 20 µPa), não eléctrica |
| `dBμV`, `dBmV` | Níveis de tensão com outras referências; calculáveis com `dB` + referência |

Se propõe uma destas, explique por que razão a avaliação anterior devia ser
revista — por exemplo, um caso de uso concreto que a solução actual não
resolve bem.

## Se for uma funcionalidade

**O problema que resolve:**

<!-- Descreva a situação real, não a solução. Ex.: «quando estou numa torre
     preciso de somar as perdas de vários trechos de cabo e a aplicação só
     converte uma unidade de cada vez». -->

**Como a resolveria:**

<!-- -->

**Com que frequência precisaria disto?**

- [ ] Em cada utilização
- [ ] Algumas vezes por semana
- [ ] Ocasionalmente

## Perguntas que a proposta deve conseguir responder

- [ ] Esta funcionalidade exige **acesso à rede**?

> Se a resposta for sim, é uma alteração de grande impacto: a versão de
> lançamento **não declara** a permissão de Internet, o que sustenta toda a
> Política de Privacidade e a declaração *Data safety*. Acrescentar essa
> permissão obriga a rever esses documentos e as fichas das cinco lojas. Ver
> [`docs/privacy/GUIA_DATA_SAFETY.md`](../../docs/privacy/GUIA_DATA_SAFETY.md),
> secção 5.

- [ ] Exige recolher ou guardar dados novos?
- [ ] Exige uma dependência nova?
- [ ] Exige novas permissões do Android?
- [ ] Como se chamaria nos cinco idiomas? (ou prescinde de texto?)

## Disponibilidade

- [ ] Proponho apenas a ideia
- [ ] Posso ajudar a especificar a matemática
- [ ] Posso ajudar a testar
- [ ] Posso ajudar a traduzir

> **Nota sobre contribuições de código:** o projecto **não tem licença
> definida** e todos os direitos estão reservados. Propostas são bem-vindas
> como sugestão, mas a integração de código externo depende de o proprietário
> escolher uma licença e definir os termos. Ver
> [`CONTRIBUTING.md`](../../CONTRIBUTING.md).
