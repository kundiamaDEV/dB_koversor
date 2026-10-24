# Relatório de Alterações — dB Konversor

**Data:** 2026-10-17
**Âmbito:** auditoria, correcção matemática, internacionalização e preparação para publicação
**Estado inicial registado em:** [`AUDITORIA_INICIAL.md`](AUDITORIA_INICIAL.md)

Este relatório descreve **o que foi efectivamente alterado**. As recomendações
não implementadas estão separadas, na secção 5, e não se misturam com o
trabalho feito.

Validação após todas as alterações:

| Comando | Resultado | Data |
|---|---|---|
| `flutter pub get` | APROVADO | 2026-10-17 |
| `flutter analyze` | APROVADO — «No issues found!» | 2026-10-17 |
| `flutter test` | APROVADO — **146 testes**, todos aprovados | 2026-10-17 |
| `flutter build apk --debug` | APROVADO — `app-debug.apk` gerado | 2026-10-17 |
| `flutter build appbundle --release` | APROVADO — `app-release.aab`, 45,0 MB | 2026-10-17 |

---

## 1. Correcções matemáticas

### 1.1 M1 — Raiz quadrada divergente (CRÍTICO)

| | |
|---|---|
| **Ficheiro** | `lib/features/converter/power_converter_service.dart` |
| **Problema anterior** | `_sqrt()` implementava Newton–Raphson com **20 iterações fixas** a partir de `x₀ = valor/2`. O método precisa de cerca de `log₂(valor)` iterações só para atingir a ordem de grandeza correcta, pelo que 20 iterações eram insuficientes fora de uma gama estreita. Usado em `V = √(P × R)`, afectava **todas** as conversões de potência para nível de tensão. |
| **Alteração** | A função `_sqrt` foi **removida** e substituída por `dart:math.sqrt`, com um comentário de 14 linhas no local da chamada a explicar o motivo, a magnitude do erro e a referência ao teste de regressão. |
| **Justificação técnica** | `dart:math.sqrt` compila para a instrução de raiz quadrada do processador, é exacta ao último bit (erro ≤ 0,5 ulp) e faz parte da biblioteca padrão. Não havia qualquer motivo para a implementação manual. |
| **Impacto funcional** | Resultados corrigidos em `W`/`mW`/`dBm`/`dBW` → `dBV`/`dBu` e no sentido inverso. **Nenhuma outra conversão foi afectada** (potência↔potência e dBu↔dBV não usam raiz quadrada). |
| **Testes associados** | `test/power_converter_service_test.dart`: «REGRESSÃO M1 — −120 dBm em 50 Ω», «REGRESSÃO M1 — gama completa de −130 a +150 dBm contra a forma fechada», «potência → dBu contra a forma fechada», «conversão inversa dBm → dBV → dBm». |
| **Resultado dos testes** | Antes da correcção: **4 reprovações** (evidência em [`evidence/teste_antes_da_correccao.txt`](evidence/teste_antes_da_correccao.txt)). Depois: **todos aprovados**. |
| **Riscos residuais** | Nenhum identificado. A correcção reduz código em vez de o aumentar. |

Magnitude do erro corrigido, medida em 50 Ω:

| Entrada | Valor correcto | Valor anterior | Erro |
|---|---|---|---|
| −90 dBm | −103,0103 dBV | −103,000 dBV | 0,010 dB |
| −100 dBm | −113,0103 dBV | −111,340 dBV | **1,671 dB** |
| −110 dBm | −123,0103 dBV | −114,006 dBV | **9,005 dB** |
| −120 dBm | −133,0103 dBV | −114,352 dBV | **18,659 dB** |
| −130 dBm | −143,0103 dBV | −114,387 dBV | **28,623 dB** |

A gama afectada (−90 dBm e abaixo) é a da sensibilidade de receptores — o caso
de uso mais comum do público-alvo.

### 1.2 M2 — Unidade dBW acrescentada

| | |
|---|---|
| **Ficheiros** | `lib/core/power_unit.dart`, `lib/features/converter/power_converter_service.dart`, `lib/features/converter/converter_controller.dart`, os 5 ficheiros ARB |
| **Problema anterior** | O enum `PowerUnit` não incluía `dBW`, unidade muito usada em radiodifusão, enlaces de satélite e cálculos de PIRE/EIRP. |
| **Alteração** | `dbw` acrescentado ao enum com rótulo `dBW`, categoria `powerLogAbsolute` e `isPowerUnit = true`. Implementadas as conversões `dBW → mW` (`10^((dBW+30)/10)`), `mW → dBW` (`10·log10(W)`), e os casos relativos `dBW ↔ dB`. |
| **Justificação técnica** | `P_dBm = P_dBW + 30`, porque 1 W = 1000 mW e `10·log10(1000) = 30`. A conversão para o pivô interno soma 30 **ao expoente** em vez de multiplicar o resultado por 1000: evita um valor intermédio desnecessariamente grande ou pequeno antes da multiplicação. |
| **Impacto funcional** | O conversor passa de 6 para **7 unidades**; 49 combinações em vez de 36. Nenhuma conversão existente foi alterada. |
| **Testes associados** | `test/dbw_conversion_test.dart` — **24 testes**: âncoras exactas, relação dos 30 dB, conversões com impedância contra forma fechada, conversões relativas, inversas e limites. |
| **Resultado dos testes** | Todos aprovados. |
| **Riscos residuais** | O enum ganhou um valor novo. Como o histórico grava o **símbolo** da unidade como texto e não o índice do enum, registos antigos continuam legíveis. |
| **Autorização** | Expansão de funcionalidade aprovada explicitamente pelo proprietário. |

### 1.3 M3 — Mensagens de erro referiam a unidade interna

| | |
|---|---|
| **Ficheiros** | `lib/utils/validators.dart`, `lib/features/converter/power_converter_service.dart` |
| **Problema anterior** | Converter `0 W → dBm` produzia «O valor em **mW** deve ser maior que zero» — uma unidade que o utilizador nunca introduziu, porque mW é apenas o pivô interno de cálculo. |
| **Alteração** | `_fromMilliwatt` e `_fromVoltage` recebem agora `inputUnitLabel`, a unidade escolhida pelo utilizador, usada **apenas** nas mensagens. |
| **Justificação técnica** | O parâmetro não participa em nenhum cálculo; a cadeia numérica mantém-se idêntica. |
| **Impacto funcional** | Mensagens compreensíveis. Nenhuma alteração de resultados. |
| **Testes associados** | `test/localization_test.dart`: «a unidade aparece nas mensagens que a exigem». |
| **Resultado** | Aprovado. |

### 1.4 M4 — Fórmula apresentada estava incompleta

| | |
|---|---|
| **Ficheiro** | `lib/features/converter/power_converter_service.dart` |
| **Problema anterior** | `W → dBm` mostrava apenas `dBm = 10 × log10(mW)`, escondendo o passo `mW = W × 1000`. |
| **Alteração** | Novo método `_chainFormula(List<String>)` que junta os passos por `  |  ` e descarta identidades (`mW = mW`). Aplicado às quatro famílias de conversão. |
| **Justificação técnica** | A apresentação da fórmula é um argumento pedagógico do produto; mostrar metade do cálculo contraria esse objectivo. O valor calculado já estava correcto. |
| **Impacto funcional** | Apenas na apresentação. Exemplo verificado: `dBm → dBV` passa a mostrar `mW = 10^(dBm / 10)  |  V = √(P × R)  |  dBV = 20 × log10(V)`. |
| **Testes associados** | `test/converter_screen_widget_test.dart`: «o botão de fórmula mostra a fórmula aplicada» verifica a presença dos **dois** passos. |
| **Resultado** | Aprovado. |

### 1.5 M5 — Linguagem de protótipo nos textos visíveis

| | |
|---|---|
| **Ficheiro** | `lib/core/power_unit.dart` (e `app_strings.dart`, entretanto removido) |
| **Problema anterior** | A descrição de `dB` dizia «Não representa potência absoluta neste **MVP**» — linguagem de protótipo, além de desactualizada, porque `dB` **é** convertido desde que haja referência. |
| **Alteração** | Texto substituído por «Relação logarítmica entre duas grandezas. Precisa de um valor de referência para dar um nível absoluto.», e traduzido nos 5 idiomas. |
| **Impacto funcional** | Apenas texto. |
| **Testes associados** | `test/localization_test.dart`: «todas as unidades têm descrição em todos os idiomas». |

### 1.6 M6 — Dois formatadores numéricos divergentes

| | |
|---|---|
| **Ficheiros** | `lib/utils/math_utils.dart`, `lib/features/converter/converter_screen.dart` |
| **Problema anterior** | `MathUtils.formatResult` (usada por um widget morto) e `_ConverterScreenState._formatValue` (usada pela interface real) tinham limiares diferentes e nenhum teste. A segunda removia zeros com uma expressão regular que **não tocava na mantissa** em notação científica (`1.0000e-9` ficava por limpar). |
| **Alteração** | `_formatValue` eliminada. `MathUtils.formatResult` reescrita como implementação única, com tratamento explícito de não finitos (`--`), limpeza de mantissa em notação científica e prevenção de `-0`. |
| **Justificação técnica** | Duas regras de arredondamento para o mesmo produto é uma armadilha de manutenção. Documentou-se explicitamente que a formatação é **só de apresentação**: o valor interno nunca é arredondado e nenhuma conversão parte de um valor formatado. |
| **Impacto funcional** | Valores muito grandes (≥ 10⁶) passam a usar notação científica, mais legível do que 7+ dígitos. |
| **Testes associados** | `test/number_formatting_test.dart` — **14 testes**, incluindo «a formatação não altera o valor interno». |
| **Resultado** | Aprovado. |

### 1.7 M7 — Dado fictício matematicamente errado

Resolvido com F1 (secção 2.1): a entrada fabricada `0.775 dBu → 0.614 dBV`
desapareceu com o histórico falso. O valor correcto é **−1,452 dBV**. Há um
teste de regressão que verifica que esse texto **não** volta a aparecer.

---

## 2. Correcções funcionais

### 2.1 F1 — Histórico fabricado substituído por histórico real

| | |
|---|---|
| **Ficheiros novos** | `lib/features/history/conversion_history_entry.dart`, `lib/features/history/conversion_history_store.dart` |
| **Ficheiros alterados** | `lib/features/converter/converter_screen.dart`, `lib/features/converter/converter_controller.dart`, `pubspec.yaml` |
| **Problema anterior** | `_showHistorySheet` construía a lista em cada abertura com a conversão corrente e **duas entradas fixas escritas no código**, com datas inventadas (`21/04/2026 • 15:48`) e uma delas com um resultado errado. Não havia registo, persistência nem limpeza. |
| **Alteração** | Histórico real: regista as conversões bem-sucedidas, guarda-as no dispositivo com `shared_preferences`, apresenta-as da mais recente para a mais antiga com tempo relativo traduzido, limita a 50 entradas e permite apagar com confirmação. |
| **Justificação técnica** | Guarda-se o **valor numérico** e não o texto formatado, para que a apresentação possa mudar sem reescrever o que está gravado e para conservar a precisão completa. Os símbolos das unidades são gravados como texto e não como índice do enum, para que uma reordenação futura de `PowerUnit` não corrompa o histórico já gravado. As datas são guardadas em **UTC**, para serem imunes a mudanças de fuso horário. |
| **Impacto funcional** | Funcionalidade que antes era simulada passa a existir. Permite declará-la na loja sem falsidade. |
| **Nova dependência** | `shared_preferences: ^2.3.2` — pacote oficial da equipa Flutter. Escrita num ficheiro XML privado da aplicação; **nada sai do dispositivo**. Autorizada pelo proprietário. |
| **Testes associados** | `test/conversion_history_test.dart` — 17 testes, incluindo «PERSISTÊNCIA: o histórico sobrevive a fechar e reabrir». `test/converter_screen_widget_test.dart` — 5 testes, incluindo a regressão «NÃO aparecem as entradas fabricadas da versão anterior». |
| **Resultado** | Todos aprovados. |
| **Riscos residuais** | A persistência foi verificada em teste automatizado (criação de um novo `ConversionHistoryStore` sobre o mesmo armazenamento), mas **não** num dispositivo Android real, por não haver emulador disponível. Ver secção 5. |

Tolerância a falhas implementada: um histórico ilegível ou uma falha de
escrita **não impedem** o conversor de funcionar. Todas as operações de
armazenamento estão protegidas, e há um teste que injecta dados corrompidos e
verifica que a aplicação arranca e continua a aceitar entradas novas.

### 2.2 F2 — Internacionalização

| | |
|---|---|
| **Ficheiros novos** | `l10n.yaml`, `lib/l10n/app_{pt,en,fr,es,zh}.arb`, `lib/l10n/generated/*` (6 ficheiros gerados), `lib/core/localization/conversion_messages.dart`, `lib/core/models/conversion_error.dart` |
| **Ficheiros alterados** | `lib/main.dart`, `lib/features/converter/converter_screen.dart`, `lib/features/converter/converter_controller.dart`, `lib/features/splash/splash_screen.dart`, `lib/utils/validators.dart`, `lib/features/converter/power_converter_service.dart`, `lib/core/models/conversion_result.dart`, `pubspec.yaml` |
| **Problema anterior** | Nenhuma internacionalização. ~80 literais em português só no ecrã do conversor; as mensagens de erro estavam escritas dentro da camada de cálculo. |
| **Alteração** | Sistema oficial do Flutter com ARB, 5 idiomas, **103 chaves** cada. Nenhuma frase para o utilizador ficou escrita nos widgets. |
| **Alteração arquitectural (profunda)** | A camada de cálculo deixou de devolver frases e passou a devolver **códigos** (`ConversionError`). A tradução acontece num único ponto, `ConversionMessages`. O `switch` de tradução **não tem `default`**, de propósito: se um código novo for acrescentado ao enum, o analisador acusa o `switch` incompleto e impede que um erro chegue ao utilizador sem tradução. O mesmo princípio aplicado ao controlador, que devolve `ConversionKind.power` em vez de texto. |
| **Justificação técnica** | A camada matemática não deve depender de `BuildContext` nem conter texto: isso tornaria a matemática dependente da interface e muito mais difícil de testar. `ConversionResult.errorMessage` foi mantido, em português, como recurso de diagnóstico e para os testes. |
| **Novas dependências** | `flutter_localizations` (SDK), `intl: any` (versão alinhada com a do SDK). |
| **Testes associados** | `test/localization_test.dart` — 15 testes, incluindo a verificação de que **todos** os `ConversionError` têm tradução em **todos** os idiomas, e de que nenhuma mensagem expõe o identificador interno. `test/converter_screen_widget_test.dart` — testes de interface em pt, en, fr e zh. |
| **Resultado** | Todos aprovados. `l10n_untranslated.json` = `{}` (zero chaves por traduzir). |
| **Riscos residuais** | A tradução chinesa não foi revista por falante nativo. Ver secção 5. |

### 2.3 F3 — Código morto e resíduos removidos

Confirmado por pesquisa que **nenhum** destes ficheiros era referenciado por
código vivo. Foram guardadas cópias de segurança fora do projecto antes da
remoção.

| Ficheiro removido | Porquê |
|---|---|
| `lib/app/app.dart` | Declarava um **segundo** `DbKonversorApp`, duplicando o de `main.dart` |
| `lib/app/app_theme.dart` | Tema **claro**, incompatível com a interface escura real |
| `lib/app/app_colors.dart` | Paleta clara, usada apenas pelo tema morto |
| `lib/core/constants/app_strings.dart` | Não importado por nenhum ficheiro; substituído pelos ARB |
| `lib/features/widgets/result_card.dart` | Widget não utilizado |
| `lib/features/widgets/formula_card.dart` | Widget não utilizado |
| `lib/features/widgets/impedance_field.dart` | Widget não utilizado |
| `lib/features/widgets/unit_dropdown.dart` | Widget não utilizado |
| `lib/features/widgets/value_input_field.dart` | Widget não utilizado |
| `lib/main.dart.bak` | Resíduo da remoção do Firebase |
| `pubspec.yaml.bak` | Resíduo da remoção do Firebase |

**Impacto funcional:** nenhum. `flutter analyze` e os 146 testes continuam a
passar, e a aplicação compila e corre.

### 2.4 F4 — Contactos na Ajuda

| | |
|---|---|
| **Ficheiro** | `lib/features/converter/converter_screen.dart` |
| **Decisão do proprietário** | Manter os contactos actuais. |
| **Alteração** | Os contactos deixaram de estar escritos dentro do texto do diálogo e passaram a ser duas constantes (`_contactPhones`, `_contactEmail`), separadas das frases traduzidas. As frases («Contacto: {phones}») estão nos ARB; os valores não, porque são dados e não texto a traduzir. |
| **Benefício** | Alterar o contacto no futuro não obriga a mexer em cinco ficheiros de tradução. |
| **Risco residual aceite pelo proprietário** | Um e-mail pessoal (`@gmail.com`) e dois números de telefone pessoais ficam visíveis numa aplicação distribuída globalmente. Ver secção 4. |

### 2.5 F6 — Dupla invocação de `convert()`

| | |
|---|---|
| **Ficheiro** | `lib/features/converter/converter_screen.dart` |
| **Problema anterior** | O ecrã chamava `controller.convert()` imediatamente a seguir a `setFromUnit`/`setToUnit`/`invertUnits`, que já convertem internamente. Cada mudança de unidade calculava duas vezes e notificava duas vezes. |
| **Alteração** | Chamadas redundantes removidas (5 ocorrências). Acrescentado um comentário em `ConverterController.convert()` a avisar que os métodos de mudança de unidade já convertem. |
| **Impacto funcional** | Nenhuma alteração de comportamento visível; menos trabalho por interacção. Com o histórico agora activo, a dupla chamada também geraria trabalho de gravação a dobrar. |
| **Testes associados** | Os testes de inversão de unidades verificam o resultado correcto. |

### 2.6 Acessibilidade

| | |
|---|---|
| **Problema anterior** | Os quatro botões só com ícone (menu, ajuda, inverter, histórico) não tinham descrição para leitores de ecrã, e o resultado não tinha rótulo semântico. |
| **Alteração** | `tooltip` traduzido nos quatro botões; `Semantics` no campo de resultado, com o valor e a unidade («Resultado: 0.01 W»). |
| **Testes associados** | `test/converter_screen_widget_test.dart`, grupo «Acessibilidade». |
| **Limitação** | Melhoria estrutural verificada por teste automatizado. **Não foi testada com o TalkBack num dispositivo real.** Ver secção 5. |

### 2.7 Robustez de layout

Acrescentados `Expanded` nos títulos de secção e `maxLines: 2` com reticências
nos rótulos dos cartões de unidade, porque as traduções são mais longas do que
o português (o francês é o pior caso). A fórmula, que agora mostra vários
passos encadeados, ficou com deslocamento horizontal em vez de ser cortada.

Verificado por testes de widget em: telemóvel de 320 dp, tablet de 10
polegadas, orientação horizontal, francês em ecrã estreito, e com ampliação de
texto a 1,5×. Em todos, `tester.takeException()` devolve `null` — ou seja,
**nenhum transbordo de layout**.

---

## 3. Android e publicação

### 3.1 B1 — `MainActivity.kt` continha um script PowerShell (BLOQUEADOR)

| | |
|---|---|
| **Ficheiro** | `android/app/src/main/kotlin/ao/kundiama/dbkonversor/MainActivity.kt` |
| **Problema anterior** | O ficheiro continha o *script PowerShell* usado para migrar o pacote de `com.example.db_konversor` para `ao.kundiama.dbkonversor`: o script foi gravado sobre o seu próprio destino. A classe `MainActivity` declarada no manifesto não existia. **A compilação Android falhava.** |
| **Alteração** | Reescrito como a actividade Kotlin padrão do Flutter (`class MainActivity : FlutterActivity()`), com comentário a explicar o sucedido e a lembrar que o pacote tem de coincidir com `namespace` e `applicationId`. |
| **Verificação** | `flutter build apk --debug` → **APROVADO**. `flutter build appbundle --release` → **APROVADO**. |

### 3.2 B2 — Assinatura de lançamento

| | |
|---|---|
| **Ficheiro** | `android/app/build.gradle.kts` |
| **Problema anterior** | `release` usava `signingConfigs.getByName("debug")`. Um pacote assinado com a chave de depuração **é rejeitado pela Google Play**, e essa chave é diferente em cada máquina. |
| **Alteração** | Configuração de assinatura lida de `android/key.properties`, ficheiro que **não** está no controlo de versões. Se o ficheiro não existir, a compilação **não falha**: continua a usar a chave de depuração, mas imprime um aviso explícito de que o pacote não serve para publicar. |
| **Justificação técnica** | Degradar com aviso, em vez de falhar, mantém `flutter run --release` utilizável numa máquina de desenvolvimento sem a chave de produção. O aviso impede que isso passe despercebido. |
| **O que NÃO foi feito** | **Nenhuma chave de assinatura foi gerada.** Criar uma chave privada é irreversível: perdê-la impede para sempre a actualização da aplicação publicada. Exige decisão e custódia do proprietário. Instruções na secção 5. |
| **Também acrescentado** | `isMinifyEnabled = false` e `isShrinkResources = false` explícitos, com comentário a justificar: a redução seria segura (não há reflexão), mas activá-la sem validação em dispositivo real é um risco desnecessário, porque um erro de regras R8 só se manifesta em tempo de execução na versão de lançamento. |

### 3.3 B3 — Nome da aplicação

| | |
|---|---|
| **Ficheiro** | `android/app/src/main/AndroidManifest.xml` |
| **Problema anterior** | `android:label="db_konversor"` — o nome técnico do projecto apareceria tal e qual no lançador do dispositivo. |
| **Alteração** | `android:label="dB Konversor"`. |
| **Verificação** | Manifesto fundido da variante `release`: `android:label="dB Konversor"`. |

> **Nota de transparência sobre um erro cometido e corrigido durante a
> auditoria:** ao documentar esta alteração, o comentário XML foi inicialmente
> colocado **dentro** da lista de atributos de `<application>`, o que é XML
> inválido e fez falhar a compilação com «Error parsing LocalFile». Foi
> detectado imediatamente pela compilação, o comentário foi movido para cima da
> etiqueta e o ficheiro passou a validar. A compilação subsequente teve êxito.

### 3.4 P1 — Artefactos do Firebase removidos

| | |
|---|---|
| **Ficheiros removidos** | `firebase.json`, `android/app/google-services.json` |
| **Problema anterior** | Permaneceram no repositório após a remoção de `firebase_core`. Continham `project_id`, `project_number`, `mobilesdk_app_id`, `storage_bucket` e uma **chave de API**. |
| **Confirmação antes de remover** | O plugin `com.google.gms.google-services` **não** estava aplicado em nenhum ficheiro Gradle, e nenhum pacote Firebase constava do `pubspec.lock`. Os ficheiros estavam inertes em tempo de execução: não havia recolha de dados por esta via. O risco era de **exposição da credencial** ao publicar no GitHub. |
| **Alteração** | Ficheiros removidos e regras acrescentadas ao `.gitignore` como prevenção. |
| **Acção ainda necessária pelo proprietário** | Ver secção 5: a chave esteve num ficheiro local; recomenda-se eliminar ou desactivar o projecto Firebase `db-konversor`, que já não é usado. |

### 3.5 P3 — `.gitignore` reforçado

Acrescentada uma secção dedicada a segredos, com um aviso explícito de que
**nunca deve ser removida**:

- `android/key.properties`, `key.properties`
- `*.jks`, `*.keystore`, `*.p12`, `*.pem`, `*.pepk`
- `android/local.properties`, `local.properties`
- `**/google-services.json`, `**/GoogleService-Info.plist`, `firebase.json`, `.firebaserc`, `lib/firebase_options.dart`
- `*.env`, `.env*`, `service-account*.json`, `secrets.properties`
- `l10n_untranslated.json` (artefacto de compilação)

**Importante:** estas regras foram postas em vigor **antes** de existir uma
chave de assinatura. Uma chave de assinatura publicada por engano é um
incidente não recuperável.

---

## 4. Configuração verificada no pacote final

Lida do manifesto fundido da variante `release`
(`build/app/intermediates/packaged_manifests/release/.../AndroidManifest.xml`),
e não do ficheiro de origem:

| Item | Valor verificado |
|---|---|
| `package` | `ao.kundiama.dbkonversor` |
| `android:label` | `dB Konversor` |
| `versionName` | `1.0.0` |
| `versionCode` | `1` |
| `minSdkVersion` | `24` |
| `targetSdkVersion` | `36` |
| Permissões no `release` | **Nenhuma permissão de acesso a dados.** Apenas a permissão auto-gerada `ao.kundiama.dbkonversor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`, de nível de assinatura, criada automaticamente pelo AndroidX para receptores internos. |
| Permissões no `debug` | `android.permission.INTERNET` (apenas na variante de depuração, não entra no pacote publicado) |

**Esta é a evidência central da declaração de privacidade:** a aplicação
publicada **não tem permissão para aceder à rede**. Ver
[`privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`](privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md).

---

## 5. Recomendações NÃO implementadas

Esta secção lista o que **não** foi feito, e porquê. Nada aqui foi executado.

| # | Recomendação | Porque não foi feita | Quem pode fazer |
|---|---|---|---|
| R1 | Gerar a chave de assinatura de lançamento | Acção irreversível com custódia de uma chave privada; perder a chave impede actualizações futuras da aplicação publicada | Proprietário |
| R2 | Inicializar o repositório Git | O prompt proíbe operações Git sem autorização explícita; o projecto continua sem controlo de versões | Proprietário |
| R3 | Eliminar/desactivar o projecto Firebase `db-konversor` | Acção numa consola externa, fora do repositório | Proprietário |
| R4 | Publicar a Política de Privacidade numa URL pública | Exige alojamento web; a Google Play exige uma URL acessível | Proprietário |
| R5 | Submeter o formulário *Data safety* | Acção na Play Console | Proprietário |
| R6 | Gerar capturas de ecrã reais | **Não há emulador nem dispositivo Android disponível** neste ambiente (`flutter devices` lista apenas Windows, Chrome e Edge; `flutter emulators` devolve «No emulators available») | Proprietário, com as instruções de `docs/store/screenshots/` |
| R7 | Revisão da tradução chinesa por falante nativo | A qualidade terminológica não é auto-verificável | Revisor técnico sinófono |
| R8 | Testar com o TalkBack | Exige dispositivo real | Proprietário |
| R9 | Confirmar a persistência do histórico num dispositivo real | Verificada em teste automatizado, mas não em Android real | Proprietário |
| R10 | Escolher uma licença | Decisão jurídica do proprietário; por isso o README **não** descreve o projecto como *open source* | Proprietário |
| R11 | Activar a redução de código (R8) | Um erro de regras R8 só se manifesta em execução, na versão de lançamento; exige validação em dispositivo | Depois de R6/R8 |
| R12 | Actualizar as 21 dependências com versões mais recentes | O prompt proíbe actualizações indiscriminadas; as versões actuais resolvem e passam todos os testes | Decisão futura, uma de cada vez |
| R13 | Substituir os contactos pessoais por institucionais | O proprietário decidiu manter os actuais | Proprietário, se mudar de ideias |

---

## 6. Inventário de ficheiros

### Criados (33)

**Código (8)**
`lib/core/models/conversion_error.dart` · `lib/core/localization/conversion_messages.dart` · `lib/features/history/conversion_history_entry.dart` · `lib/features/history/conversion_history_store.dart` · `lib/features/privacy/privacy_policy_screen.dart` · `l10n.yaml` · `lib/l10n/app_{pt,en,fr,es,zh}.arb` (5) · `lib/l10n/generated/*` (6, gerados)

**Testes (7)**
`test/reference_values.dart` · `test/power_converter_service_test.dart` · `test/dbw_conversion_test.dart` · `test/number_formatting_test.dart` · `test/conversion_history_test.dart` · `test/localization_test.dart` · `test/converter_screen_widget_test.dart` · `test/version_consistency_test.dart`

**Evidências e documentação**
Ver `docs/` — auditoria inicial, matriz de conversões, guia de localização, este relatório, privacidade, loja, conteúdos e relatório final.

### Alterados (10)

`lib/main.dart` · `lib/core/power_unit.dart` · `lib/core/models/conversion_result.dart` · `lib/utils/validators.dart` · `lib/utils/math_utils.dart` · `lib/features/converter/power_converter_service.dart` · `lib/features/converter/converter_controller.dart` · `lib/features/converter/converter_screen.dart` · `lib/features/splash/splash_screen.dart` · `pubspec.yaml` · `analysis_options.yaml` · `.gitignore` · `android/app/build.gradle.kts` · `android/app/src/main/AndroidManifest.xml` · `android/app/src/main/kotlin/ao/kundiama/dbkonversor/MainActivity.kt`

### Removidos (13)

Os 11 de F3 (secção 2.3) e os 2 artefactos do Firebase (secção 3.4).

---

## 7. O que ficou intacto

Por princípio de preservação, **não** foram alterados:

- A identidade visual: todas as cores, gradientes, raios de canto, sombras e
  animações do conversor, do ecrã de abertura e do menu lateral são
  exactamente as mesmas. A página de Política de Privacidade foi desenhada
  para seguir a mesma linguagem visual.
- A arquitectura de conversão por pivôs (mW e volts), que estava bem concebida.
- As três animações do ecrã (brilho do botão de inversão, pulsação do
  resultado, transição das unidades).
- O ecrã de abertura, o seu logótipo e a duração de 3 segundos.
- O identificador `ao.kundiama.dbkonversor`, o `versionCode`, o `versionName`
  e a configuração de ícones.
- Os recursos gráficos (`assets/`).
- As plataformas `ios/`, `web/`, `linux/`, `macos/`, `windows/`, fora do
  âmbito desta auditoria.
