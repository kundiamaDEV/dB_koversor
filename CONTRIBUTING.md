# Contribuir para o dB Konversor

Obrigado pelo interesse. Este documento descreve como propor alterações de
forma que possam ser aceites sem retrabalho.

> **Nota sobre a licença.** O projecto **não tem licença definida** e todos os
> direitos estão reservados à KUNDIAMA Tecnologia e Inovação. Isto significa
> que contribuições externas só podem ser integradas depois de o proprietário
> escolher uma licença e definir os termos de contribuição. Até lá, propostas
> são bem-vindas como sugestão, mas a sua integração fica dependente dessa
> decisão. Ver `README.md`, secção Licença.

---

## Antes de começar

```powershell
flutter pub get
flutter gen-l10n
flutter analyze      # tem de passar sem problemas
flutter test         # os 146 testes têm de passar
```

Se algum destes passos falhar num repositório recém-clonado, o problema é do
ambiente e não da sua alteração — resolva-o primeiro.

Leia também:

- [`docs/MATRIZ_CONVERSOES.md`](docs/MATRIZ_CONVERSOES.md) — o que a aplicação
  converte e com que condições de validade
- [`docs/AUDITORIA_INICIAL.md`](docs/AUDITORIA_INICIAL.md) — os defeitos já
  encontrados e corrigidos, para não os reintroduzir
- [`docs/GUIA_LOCALIZACAO.md`](docs/GUIA_LOCALIZACAO.md) — se a alteração
  envolver texto

---

## A regra mais importante: alterações à matemática

Esta aplicação existe para dar resultados numéricos correctos. Uma alteração à
camada de cálculo tem um padrão obrigatório:

### 1. Escrever primeiro o teste que falha

```dart
test('REGRESSÃO: descrição do problema', () {
  expect(
    ok(input: -120, from: PowerUnit.dbm, to: PowerUnit.dbv, impedance: 50),
    closeTo(valorEsperado, 1e-6),
  );
});
```

Execute-o e **confirme que falha** pelo motivo certo. Um teste que passa antes
da correcção não testa a correcção.

### 2. O valor esperado tem de ser deduzido independentemente

Esta é a regra que não pode ser contornada. O valor esperado **não pode** vir
da função que está a ser testada, nem de uma reescrita da mesma fórmula — isso
reproduziria o erro e o teste passaria com o código errado.

Use uma das duas estratégias de [`test/reference_values.dart`](test/reference_values.dart):

| Estratégia | Exemplo |
|---|---|
| **Âncora exacta** por definição da unidade | `0 dBm = 1 mW`; `0 dBW = 1 W` |
| **Forma fechada de um só passo**, algebricamente distinta | `L_dBV = 10·log₁₀(P·R)` em vez de `20·log₁₀(√(P·R))` |

Foi exactamente a segunda que detectou um erro real de **18,7 dB** na versão
anterior: a referência não usa raiz quadrada, pelo que um erro na raiz
quadrada do código de produção não pôde passar.

`test/reference_values.dart` **não importa nada de `lib/`**. Mantenha essa
regra.

### 3. Corrigir o código e comentar o *porquê*

```dart
// CORRECCAO <ID> (data).
//
// Problema: <o que estava errado, e qual era a magnitude do erro>
// Regra tecnica: <a razao matematica ou fisica da correccao>
// Limitacao: <o que continua a nao ser tratado, se aplicavel>
// Teste: <ficheiro e nome do teste de regressao>
final volts = math.sqrt(watts * impedance);
```

Comente **a decisão**, não a mecânica. `// incrementa o contador` não serve de
nada; `// o Newton-Raphson com 20 iteracoes divergia abaixo de -90 dBm` serve.

### 4. Confirmar que a conversão inversa fecha

A verificação mais simples e mais eficaz: converta num sentido e no inverso. Se
não voltar ao valor de partida, uma das direcções está errada.

### 5. Actualizar a documentação

Se a alteração mudar o comportamento, actualize
[`docs/MATRIZ_CONVERSOES.md`](docs/MATRIZ_CONVERSOES.md) e volte a gerar os
exemplos:

```powershell
dart run docs/evidence/gerar_exemplos.dart
```

---

## Alterações a texto visível

**Nunca escreva uma frase para o utilizador dentro de um widget.** Todos os
textos vivem nos ficheiros ARB.

```powershell
# 1. Acrescentar a chave em lib/l10n/app_pt.arb (modelo), com o bloco @chave
# 2. Traduzir nos outros quatro ficheiros (en, fr, es, zh)
# 3. Gerar
flutter gen-l10n
# 4. Confirmar que nada ficou por traduzir ({} significa completo)
Get-Content l10n_untranslated.json
# 5. Testar
flutter test test/localization_test.dart
```

### O que nunca se traduz

`dB` · `dBm` · `dBW` · `dBV` · `dBu` · `W` · `mW` · `V` · `Ω` ·
`dB Konversor` · as fórmulas · `--`

Há testes que verificam isto em todos os idiomas.

### Mensagens de erro

As mensagens de erro **não** se escrevem onde o erro ocorre. A camada de
cálculo devolve um código:

1. Acrescentar o valor a `ConversionError` em
   [`lib/core/models/conversion_error.dart`](lib/core/models/conversion_error.dart)
2. Devolvê-lo no local da falha, com `errorUnitLabel` se a mensagem precisar da
   unidade
3. Traduzi-lo em `conversion_messages.dart` — o `switch` **não tem `default`**,
   pelo que o analisador avisa se se esquecer de um caso
4. Acrescentar a chave `err...` aos cinco ficheiros ARB

O teste «todos os códigos têm tradução em todos os idiomas» garante que nenhum
erro chega ao utilizador em branco.

---

## Alterações à interface

Preserve a identidade visual: fundo azul-escuro (`#020817`), destaques em
ciano (`#22C7FF`) e azul eléctrico (`#0B58F4`), cartões com borda
(`#123E83` / `#173A74`).

Não altere o aspecto sem necessidade funcional.

### Testes de widget: uma particularidade deste projecto

**`pumpAndSettle` não funciona neste ecrã.** O botão de inversão tem uma
animação em ciclo infinito (`AnimationController.repeat`), pelo que a árvore
nunca atinge um estado estável e `pumpAndSettle` expira sempre.

Use o auxiliar `settle(tester)` de
[`test/converter_screen_widget_test.dart`](test/converter_screen_widget_test.dart),
que avança um número fixo de fotogramas.

Se um teste precisar de ver uma lista completa (menu de unidades, página de
privacidade), use `useTallScreen(tester)`: no ecrã pequeno por omissão, o
`ListView` não constrói os últimos elementos e `find.text` não os encontra — o
que se confundiria facilmente com um defeito da aplicação.

### Transbordo de layout

Os textos traduzidos são mais longos do que os portugueses, sobretudo em
francês. Teste em ecrã estreito:

```dart
testWidgets('sem transbordo em frances', (tester) async {
  tester.view.physicalSize = const Size(320 * 3, 568 * 3);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(wrap(locale: const Locale('fr')));
  await settle(tester);

  expect(tester.takeException(), isNull);
});
```

---

## Dependências novas

Acrescentar uma dependência é uma decisão com consequências de privacidade e
tem de ser justificada:

- [ ] O problema não se resolve com os recursos existentes?
- [ ] O pacote é mantido e tem uma origem credível?
- [ ] **O pacote acede à rede?** Se sim, deixa de ser verdade que a aplicação
      não transmite dados, e obriga a rever a Política de Privacidade, a
      declaração *Data safety* e as fichas das cinco lojas
- [ ] Acrescenta permissões ao `AndroidManifest`?
- [ ] Qual o impacto no tamanho do pacote?

Se a resposta à terceira pergunta for «sim», leia
[`docs/privacy/GUIA_DATA_SAFETY.md`](docs/privacy/GUIA_DATA_SAFETY.md),
secção 5, **antes** de propor a alteração.

---

## O que nunca fazer

| Nunca | Porquê |
|---|---|
| Alterar um teste para o fazer passar | Esconde o defeito em vez de o corrigir. Se um teste falha, ou o código está errado, ou o teste tem uma premissa errada — e nesse caso corrija a premissa com uma justificação escrita |
| Escrever dados fictícios na interface | Foi exactamente o defeito F1 desta auditoria: um histórico fabricado, com um valor matematicamente errado |
| Confirmar segredos | `key.properties`, `*.jks`, `google-services.json` estão no `.gitignore`. **Nunca remova essas regras.** Uma chave de assinatura publicada é um incidente não recuperável |
| Editar `lib/l10n/generated/` | É código gerado; é reescrito a cada geração |
| Usar `20 × log₁₀` para potência, ou `10 × log₁₀` para tensão | 10 para potência, 20 para tensão. Ver [`docs/content/07_common_conversion_mistakes.md`](docs/content/07_common_conversion_mistakes.md) |
| Devolver `NaN`, `Infinity` ou `0` para entradas inválidas | Devolva uma falha com um código de erro. Há um teste que varre as 49 combinações a verificar isto |
| Reescrever uma função da biblioteca padrão | A raiz quadrada escrita à mão foi o defeito mais grave encontrado nesta auditoria |

---

## Lista de verificação antes de propor a alteração

- [ ] `flutter analyze` sem problemas
- [ ] `flutter test` — todos os testes passam
- [ ] Teste de regressão acrescentado, e confirmado que falha sem a correcção
- [ ] Valor esperado deduzido independentemente da implementação
- [ ] Comentário a explicar **porque** a alteração foi necessária
- [ ] Texto novo nos cinco ficheiros ARB; `l10n_untranslated.json` = `{}`
- [ ] Documentação actualizada, se o comportamento mudou
- [ ] Nenhum segredo confirmado
- [ ] Identidade visual preservada
- [ ] `CHANGELOG.md` actualizado

---

## Comunicar um problema

Use os modelos em `.github/ISSUE_TEMPLATE/`. Para um erro de cálculo, inclua
sempre:

1. Valor de entrada, unidade de entrada, unidade de saída
2. Impedância ou referência, se aplicável
3. Resultado obtido
4. Resultado esperado **e como o calculou**
5. Versão da aplicação e dispositivo

O ponto 4 é o que permite confirmar o problema sem adivinhar.

---

## Comunicar uma vulnerabilidade

**Não** abra um *issue* público. Ver [`SECURITY.md`](SECURITY.md).
