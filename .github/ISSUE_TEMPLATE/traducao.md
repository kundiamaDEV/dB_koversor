---
name: Tradução
about: Erro de tradução, texto cortado, ou proposta de novo idioma
title: '[TRADUCAO] '
labels: ['i18n']
assignees: ''
---

## Tipo

- [ ] Erro de tradução (texto incorrecto ou pouco natural)
- [ ] Terminologia técnica inadequada no meu mercado
- [ ] Texto cortado ou a transbordar no ecrã
- [ ] Texto não traduzido (aparece noutro idioma)
- [ ] Caracteres mal apresentados (quadrados vazios, acentos errados)
- [ ] Proposta de um idioma novo

## Idioma

| Campo | Valor |
|---|---|
| Idioma afectado | <!-- pt / en / fr / es / zh --> |
| Idioma do dispositivo | |
| É falante nativo deste idioma? | |

> **Nota:** a tradução para **chinês simplificado** está completa mas
> **ainda não foi revista por um falante nativo**. Contributos de revisores
> sinófonos com formação técnica são particularmente úteis.

## Onde aparece o texto

- [ ] Ecrã do conversor
- [ ] Menu lateral de unidades
- [ ] Mensagem de erro
- [ ] Diálogo de fórmula ou de ajuda
- [ ] Painel de histórico
- [ ] Política de Privacidade
- [ ] Ecrã de abertura
- [ ] Ficha da Google Play

## O texto

**Como está:**

```
```

**Como devia estar:**

```
```

**Porquê** (sobretudo se for uma questão de terminologia técnica):

<!-- Ex.: «neste mercado, os engenheiros dizem X e não Y». A justificação é
     o que permite decidir entre duas traduções ambas defensáveis. -->

---

### Se for um texto cortado ou a transbordar

| Campo | Valor |
|---|---|
| Modelo do dispositivo | |
| Dimensão do ecrã | |
| Tamanho de letra do sistema | |

Anexe uma captura de ecrã, se possível. O francês é o idioma com os textos
mais longos e por isso o mais sujeito a este problema.

---

### Se for uma proposta de idioma novo

| Campo | Valor |
|---|---|
| Idioma proposto | |
| Código do idioma (ex.: `de`, `ru`, `ar`) | |
| Disponível para traduzir ou revisar? | |

O procedimento completo para acrescentar um idioma está em
[`docs/GUIA_LOCALIZACAO.md`](../../docs/GUIA_LOCALIZACAO.md), secção 4. São 103
chaves.

---

### Lembrete sobre símbolos técnicos

Os seguintes **nunca** são traduzidos, em nenhum idioma, e há testes
automatizados que o verificam:

`dB` · `dBm` · `dBW` · `dBV` · `dBu` · `W` · `mW` · `V` · `Ω` ·
`dB Konversor` · as fórmulas matemáticas

Se o relatório for sobre um destes, descreva o problema de outra forma — por
exemplo, se um símbolo aparecer traduzido, isso **é** um defeito a comunicar.
