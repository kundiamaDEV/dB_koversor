# Proposta de alteração

> **Antes de preencher:** o projecto **não tem licença definida** e todos os
> direitos estão reservados à KUNDIAMA Tecnologia e Inovação. A integração de
> código externo depende de o proprietário escolher uma licença e definir os
> termos de contribuição. Ver [`CONTRIBUTING.md`](../CONTRIBUTING.md).

## O que muda

<!-- Uma ou duas frases. -->

## Porquê

<!-- O problema que isto resolve. Se houver um issue, referencie-o: Fixes #N -->

## Tipo de alteração

- [ ] Correcção de um erro de cálculo
- [ ] Correcção de comportamento
- [ ] Unidade de conversão nova
- [ ] Funcionalidade nova
- [ ] Tradução
- [ ] Documentação
- [ ] Refactorização sem alteração de comportamento
- [ ] Configuração de compilação ou de Android

---

## Verificação obrigatória

```powershell
flutter analyze      # tem de passar sem problemas
flutter test         # todos os testes têm de passar
```

- [ ] `flutter analyze` — sem problemas
- [ ] `flutter test` — todos passam. Total: `_____` testes
- [ ] Compila: `flutter build apk --debug`

---

## Se tocou na matemática

**Esta secção não é opcional.** A correcção numérica é a razão de existir deste
produto.

- [ ] Escrevi **primeiro** o teste e **confirmei que falhava** antes da correcção
- [ ] O valor esperado foi deduzido **independentemente da implementação
      testada** — por âncora exacta de definição, ou por forma fechada
      algebricamente distinta
- [ ] `test/reference_values.dart` continua a **não importar nada de `lib/`**
- [ ] Verifiquei que a **conversão inversa fecha**
- [ ] Testei os valores-limite: zero, negativos, muito grandes, muito pequenos,
      `NaN` e infinito
- [ ] Nenhuma conversão devolve sucesso com um valor não finito
- [ ] Comentei **porque** a alteração foi necessária, com a regra técnica
      aplicada
- [ ] Actualizei [`docs/MATRIZ_CONVERSOES.md`](../docs/MATRIZ_CONVERSOES.md), se
      o comportamento mudou
- [ ] Voltei a gerar os exemplos: `dart run docs/evidence/gerar_exemplos.dart`

**Valores verificados nesta alteração:**

| Entrada | Unidades | Esperado | Obtido | Como deduziu o esperado |
|---|---|---|---|---|
| | | | | |

---

## Se tocou em texto visível

- [ ] Nenhuma frase para o utilizador foi escrita dentro de um widget
- [ ] A chave foi acrescentada aos **cinco** ficheiros ARB (pt, en, fr, es, zh)
- [ ] `flutter gen-l10n` executado
- [ ] `l10n_untranslated.json` está a `{}`
- [ ] Os símbolos técnicos (`dB`, `dBm`, `W`, `Ω`, ...) **não** foram traduzidos
- [ ] Se acrescentei um código de erro, traduzi-o em `conversion_messages.dart`
- [ ] `flutter test test/localization_test.dart` passa

---

## Se tocou na interface

- [ ] Identidade visual preservada (azul-escuro, ciano, azul eléctrico)
- [ ] Testado em ecrã estreito (320 dp) **em francês** — o pior caso de layout
- [ ] Testado em tablet
- [ ] Testado com letra ampliada (`textScaler: 1.5`)
- [ ] `tester.takeException()` devolve `null` em todos — sem transbordo
- [ ] Botões só com ícone têm `tooltip` traduzido
- [ ] Usei o auxiliar `settle(tester)` e **não** `pumpAndSettle` (a animação do
      botão de inversão nunca estabiliza)

---

## Se acrescentou uma dependência

- [ ] Justifiquei por que razão não se resolve com os recursos existentes
- [ ] **O pacote acede à rede?** `Sim / Não`
- [ ] Acrescenta permissões ao `AndroidManifest`? `Sim / Não`
- [ ] Impacto no tamanho do pacote: `_____`

> Se acede à rede, **deixa de ser verdade** que a aplicação não transmite
> dados. Isso obriga a actualizar a Política de Privacidade nos 5 idiomas, o
> relatório de auditoria de privacidade, o guia da declaração *Data safety* e
> as 5 fichas da loja. Confirme que fez tudo isso:
>
> - [ ] Não aplicável — o pacote não acede à rede
> - [ ] Aplicável, e todos os documentos foram actualizados

---

## Segredos

- [ ] Nenhuma credencial, chave, *keystore* ou password foi confirmada
- [ ] Não removi nenhuma regra da secção de segredos do `.gitignore`

---

## Documentação

- [ ] [`CHANGELOG.md`](../CHANGELOG.md) actualizado
- [ ] Documentação relacionada actualizada

---

## Riscos residuais

<!-- O que esta alteração pode quebrar e que não ficou coberto por testes.
     Escrever «nenhum» é aceitável se for verdade; é preferível a deixar em
     branco. -->
