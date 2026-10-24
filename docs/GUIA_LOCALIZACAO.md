# Guia de Localização — dB Konversor

**Data:** 2026-10-17
**Mecanismo:** sistema oficial do Flutter (`flutter_localizations` + `intl` + ficheiros ARB)

---

## 1. Idiomas suportados

| Idioma | Código | Ficheiro | Estado |
|---|---|---|---|
| Português | `pt` | `lib/l10n/app_pt.arb` | **Modelo** (fonte de verdade) |
| Inglês | `en` | `lib/l10n/app_en.arb` | Completo |
| Francês | `fr` | `lib/l10n/app_fr.arb` | Completo |
| Espanhol | `es` | `lib/l10n/app_es.arb` | Completo |
| Chinês simplificado | `zh` | `lib/l10n/app_zh.arb` | Completo, **pendente de revisão por falante nativo** |

Todos os ficheiros têm as mesmas **103 chaves**. A verificação é automática: ver
a secção 6.

### Porquê `zh` e não `zh_CN`

O pedido original referia `zh_CN`. Foi usado `zh` porque:

- a aplicação não tem nenhum texto que difira entre as variantes regionais do
  chinês simplificado (não há formatação de moeda, nem de datas longas, nem
  terminologia regional divergente);
- `zh` abrange **todos** os dispositivos configurados em chinês simplificado,
  incluindo `zh_CN`, `zh_SG` e `zh_Hans`, enquanto `zh_CN` só abrangeria a
  China continental;
- a resolução de idioma em `main.dart` faz corresponder qualquer variante de
  `zh` a este ficheiro.

Se no futuro for preciso distinguir chinês **tradicional** (Hong Kong, Taiwan),
aí sim deve ser criado um `app_zh_Hant.arb` separado, porque a escrita é
genuinamente diferente. Na ficha da Google Play, a listagem continua a ser
submetida como *Chinês (Simplificado) – zh-CN*, que é o código que a loja usa.

---

## 2. Estrutura dos ficheiros ARB

Um ARB é JSON com uma convenção: as chaves que começam por `@` são metadados.

```json
{
  "@@locale": "pt",

  "sectionInputValue": "VALOR DE ENTRADA",
  "@sectionInputValue": {
    "description": "Título de secção, apresentado em maiúsculas."
  },

  "errNonPositiveForLog": "O valor em {unit} tem de ser maior que zero: ...",
  "@errNonPositiveForLog": {
    "description": "O símbolo da unidade não se traduz.",
    "placeholders": { "unit": { "type": "String", "example": "mW" } }
  },

  "historyMinutesAgo": "{minutes, plural, =1{Há 1 minuto} other{Há {minutes} minutos}}",
  "@historyMinutesAgo": {
    "placeholders": { "minutes": { "type": "int" } }
  }
}
```

Regras seguidas no projecto:

- **Os metadados `@chave` só existem no ficheiro modelo (`app_pt.arb`).** Nas
  traduções, repeti-los seria duplicação sem utilidade; o gerador usa sempre os
  do modelo.
- **Os marcadores `{unit}`, `{minutes}` têm de aparecer em todas as traduções**,
  com o mesmo nome. Se faltarem, a geração falha.
- Cada ficheiro começa com um `@@x-notes` que resume as convenções desse idioma
  (separador decimal, tratamento formal, terminologia).

### Configuração

[`l10n.yaml`](../l10n.yaml), na raiz:

```yaml
arb-dir: lib/l10n
template-arb-file: app_pt.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n/generated
untranslated-messages-file: l10n_untranslated.json
nullable-getter: false
```

`nullable-getter: false` faz com que `AppLocalizations.of(context)` devolva um
valor não nulo, evitando `!` espalhado pela interface.

---

## 3. Procedimento de geração

O código gerado fica em `lib/l10n/generated/` e **não deve ser editado à mão**:
é reescrito a cada geração.

```powershell
# Gerar explicitamente
flutter gen-l10n

# Também acontece automaticamente, porque o pubspec.yaml tem `generate: true`
flutter run
flutter build apk
```

Depois de alterar um ARB, voltar a gerar e correr os testes:

```powershell
flutter gen-l10n
flutter test test/localization_test.dart
```

### Como saber se falta alguma tradução

A geração escreve `l10n_untranslated.json` na raiz. Ficheiro com `{}` significa
que **nada** está por traduzir. Qualquer outra coisa lista o que falta, por
idioma:

```json
{ "fr": ["historyCleared", "privacyRightsBody"] }
```

Esse ficheiro é um artefacto de compilação e está no `.gitignore`.

---

## 4. Como acrescentar um idioma novo

Exemplo com alemão (`de`):

1. **Copiar o modelo:**
   ```powershell
   Copy-Item lib/l10n/app_pt.arb lib/l10n/app_de.arb
   ```
2. **Mudar o cabeçalho** do novo ficheiro para `"@@locale": "de"` e actualizar
   a nota `@@x-notes`.
3. **Apagar todos os blocos `@chave`** do ficheiro novo (os metadados ficam só
   no modelo) e traduzir os valores.
4. **Gerar e verificar:**
   ```powershell
   flutter gen-l10n
   Get-Content l10n_untranslated.json
   ```
5. **Acrescentar `'de'` à lista `expectedLanguages`** em
   `test/localization_test.dart`. Os testes passam então a exigir que o novo
   idioma esteja completo e coerente.
6. **Correr os testes:**
   ```powershell
   flutter test
   ```
7. Preparar a ficha da loja correspondente em `docs/store/`.

Não é preciso alterar `main.dart`: `supportedLocales` vem de
`AppLocalizations.supportedLocales`, que é gerado a partir dos ficheiros
existentes.

---

## 5. Convenções de tradução

### 5.1 O que NUNCA se traduz

| Categoria | Exemplos | Porquê |
|---|---|---|
| Símbolos de unidades | `dB`, `dBm`, `dBW`, `dBV`, `dBu`, `W`, `mW`, `V`, `Ω` | Notação técnica internacional. Um engenheiro chinês escreve `dBm`, não uma transliteração. |
| Nome do produto | `dB Konversor` | Marca. Há um teste que o verifica em todos os idiomas. |
| Fórmulas | `dBm = 10 × log10(mW)` | Construídas em código, nunca passam pelos ARB. |
| Marcador de vazio | `--` | Igual em todos os idiomas, verificado por teste. |
| Nome da organização | `KUNDIAMA` | Marca. |
| Identificadores internos | `ConversionError.outOfRange`, nomes de classes | Código, não texto. |

### 5.2 O que muda por idioma

| Aspecto | pt | en | fr | es | zh |
|---|---|---|---|---|---|
| Separador decimal nos exemplos de texto | `0,775 V` | `0.775 V` | `0,775 V` | `0,775 V` | `0.775 V` |
| Tratamento do utilizador | 3.ª pessoa | 2.ª («you») | *vous* | *usted* | neutro |
| Espaço antes de `:` e `?` | não | não | **sim** (regra tipográfica francesa) | não | não |
| Formato da data de revisão | `17/10/2026` | `2026-10-17` | `17/10/2026` | `17/10/2026` | `2026年10月17日` |
| Categorias de plural | 2 | 2 | 2 | 2 | **1** (só `other`) |

O chinês não tem flexão de plural: a mensagem usa apenas a categoria `other`.
Escrever `=1{...}` em chinês seria incorrecto do ponto de vista linguístico, e
o teste de plurais reflecte isso (só exige singular ≠ plural nos idiomas que
têm essa distinção).

### 5.3 Terminologia técnica fixada

| Conceito | pt | en | fr | es | zh |
|---|---|---|---|---|---|
| power | potência | power | puissance | potencia | 功率 |
| voltage | tensão | voltage | tension | tensión | 电压 |
| impedance | impedância | impedance | impédance | impedancia | 阻抗 |
| reference (value) | referência | reference | référence | referencia | 参考值 |
| level | nível | level | niveau | nivel | 电平 |
| ratio | razão | ratio | rapport | relación | 比值 |
| decibel | decibel | decibel | décibel | decibelio | 分贝 |
| history | histórico | history | historique | historial | 记录 |

Nota de uso regional: em espanhol usa-se **decibelio** (forma da RAE), e
*vatio*/*milivatio* para watt/milliwatt no texto corrido — mas o **símbolo**
mantém-se `W`/`mW`.

---

## 6. Como testar a localização

### Automaticamente

```powershell
flutter test test/localization_test.dart
```

O ficheiro [`test/localization_test.dart`](../test/localization_test.dart)
verifica, em **todos** os idiomas:

| Verificação | O que apanha |
|---|---|
| Os 5 idiomas estão declarados e carregam | Um ARB mal formado, um idioma esquecido |
| Nenhuma das ~50 cadeias principais está vazia | Uma chave traduzida como `""` |
| Todas as 18 secções da política têm texto | Uma secção legal em falta num idioma |
| As traduções diferem do português | Um ficheiro copiado e não traduzido |
| `appTitle` = `dB Konversor` em todos | Marca traduzida por engano |
| `resultPlaceholder` = `--` em todos | Marcador alterado |
| As unidades passadas como argumento aparecem intactas | `dBm` traduzido dentro de uma mensagem |
| **Todos** os `ConversionError` têm texto em **todos** os idiomas | Um erro que apareceria em branco ao utilizador |
| Nenhuma mensagem contém `ConversionError` | Identificador interno a vazar para o ecrã |
| Todas as 7 unidades têm descrição em todos os idiomas | `dBW` sem descrição num idioma |
| As descrições são distintas entre si | Copiar/colar entre unidades |
| Plurais correctos | `{minutes}` que não aparece no texto |

E os testes de widget verificam o comportamento real do ecrã:

```powershell
flutter test test/converter_screen_widget_test.dart
```

- a interface aparece em inglês quando o idioma é inglês;
- não há texto em português quando o idioma é chinês;
- as mensagens de erro aparecem traduzidas;
- a Política de Privacidade abre no idioma seleccionado;
- **em francês, no ecrã mais estreito (320 dp), não há transbordo de layout** —
  o francês tem as cadeias mais longas do conjunto, é o pior caso.

### Manualmente, num dispositivo

Mudar o idioma do dispositivo Android (Definições → Sistema → Idiomas) e
reabrir a aplicação. Ou, sem mudar o sistema, forçar o idioma temporariamente
em `main.dart`:

```dart
// APENAS PARA TESTE LOCAL — nunca entregar com esta linha activa.
locale: const Locale('zh'),
```

Lista de verificação manual:

- [ ] Todos os títulos de secção aparecem traduzidos.
- [ ] Nenhum texto fica cortado nem transborda.
- [ ] Os acentos aparecem correctamente (`ê`, `ç`, `ñ`, `é`, `à`).
- [ ] Os caracteres chineses aparecem (ver secção 7).
- [ ] As mensagens de erro aparecem no idioma certo.
- [ ] A Política de Privacidade está completa e legível.
- [ ] O histórico mostra o tempo relativo traduzido.
- [ ] Os símbolos `dB`, `dBm`, `Ω` **não** foram traduzidos.

---

## 7. Fontes e caracteres chineses

A aplicação **não inclui** nenhuma fonte própria: usa a fonte do sistema. No
Android, os caracteres chineses são desenhados pela fonte Noto Sans CJK, que
faz parte do sistema operativo em qualquer dispositivo que suporte chinês.

**Consequência a verificar:** num dispositivo Android sem suporte de CJK
instalado — o que é raro, mas acontece em algumas ROMs reduzidas — os
caracteres apareceriam como quadrados vazios (*tofu*). Como não foi possível
testar num dispositivo real nesta auditoria (não há emulador disponível no
ambiente), isto fica registado como **verificação manual pendente**, listada
em `docs/RELATORIO_FINAL_AUDITORIA.md`.

Se o problema aparecer, a solução é empacotar um subconjunto da Noto Sans SC,
com o custo de alguns MB no tamanho da aplicação.

---

## 8. Arquitectura: porque não há texto dentro da lógica

A camada de cálculo (`PowerConverterService`, `Validators`) **não contém
nenhuma frase para o utilizador**. Devolve códigos:

```dart
// lib/core/models/conversion_error.dart
enum ConversionError { nonPositiveForLog, missingImpedance, outOfRange, ... }
```

A tradução acontece num único sítio,
[`lib/core/localization/conversion_messages.dart`](../lib/core/localization/conversion_messages.dart):

```dart
String localizedError(ConversionError error, {String? unitLabel}) {
  switch (error) {
    case ConversionError.nonPositiveForLog:
      return errNonPositiveForLog(unitLabel ?? '');
    // ... todos os casos, sem `default`
  }
}
```

**O `switch` não tem `default` de propósito.** Se alguém acrescentar um código
de erro novo ao enum, o analisador acusa o `switch` incompleto e a compilação
avisa — o que impede que um erro chegue ao utilizador sem tradução. É uma
garantia estrutural, mais forte do que uma convenção.

Vantagens desta separação:

1. A matemática é testável sem `BuildContext` nem widgets.
2. Uma tradução nova não obriga a tocar na lógica de cálculo.
3. É impossível esquecer a tradução de um erro novo.

O mesmo princípio aplica-se ao `ConverterController`, que devolve
`ConversionKind.power` em vez de `'Conversão de potência'`.

---

## 9. Limitações conhecidas

| Limitação | Impacto | Acção recomendada |
|---|---|---|
| A tradução chinesa não foi revista por falante nativo | Terminologia tecnicamente defensável mas não validada no mercado | Revisão por engenheiro de telecomunicações sinófono antes de promover a ficha em chinês |
| Não há suporte de idiomas da direita para a esquerda (árabe, hebraico) | Nenhum — não estão previstos | O Flutter trata o RTL automaticamente; seria preciso rever o layout se forem acrescentados |
| Os números são sempre apresentados com ponto decimal | O utilizador francês vê `3.0103` e não `3,0103` | Ver nota abaixo |
| Os contactos na Ajuda não são traduzíveis | Nenhum — são valores, não texto | — |

### Nota sobre o separador decimal nos resultados

Na **entrada**, a vírgula é aceite em qualquer idioma: `33,0103` e `33.0103`
são ambos lidos correctamente (há um teste de widget para isso).

Na **saída**, o resultado é sempre apresentado com ponto decimal. Foi uma
decisão deliberada, não um esquecimento:

- a notação técnica e científica internacional usa o ponto;
- os valores são frequentemente copiados para folhas de cálculo e
  instrumentos, onde o ponto é o formato esperado;
- formatar com `intl` por local exigiria inicializar os dados de local e
  introduziria o risco de um separador de milhares aparecer num valor
  científico (`1,234.57`), o que seria ambíguo para quem usa a vírgula como
  decimal.

Se o mercado francófono ou hispanófono pedir o separador local, a alteração é
isolada: afecta apenas `MathUtils.formatResult` e os seus testes. Fica
registado como melhoria possível, não como defeito.
