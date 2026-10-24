# Relatório Final de Auditoria — dB Konversor

**Projecto:** dB Konversor
**Organização:** KUNDIAMA Tecnologia e Inovação
**Identificador Android:** `ao.kundiama.dbkonversor`
**Versão auditada:** 1.0.0+1
**Período:** 2026-10-17 a 2026-10-19
**Ambiente:** Windows 11 Pro 10.0.26200 · Flutter 3.41.1 (stable) · Dart 3.11.0

---

## A. Resumo executivo

### Estado inicial

O dB Konversor tinha uma arquitectura compreensível, identidade visual
coerente e um motor de conversão bem estruturado. Passava a análise estática
sem um único aviso.

E, apesar disso, **não era publicável nem numericamente fiável**:

| | |
|---|---|
| **Não compilava para Android** | `MainActivity.kt` continha um *script PowerShell* gravado por engano sobre o seu próprio destino |
| **Não podia ser assinado** | A variante de lançamento usava a chave de **depuração** |
| **Produzia resultados errados** | Erro de **18,7 dB a −120 dBm** e **28,6 dB a −130 dBm** nas conversões de potência para nível de tensão |
| **Mostrava dados falsos** | Histórico fabricado em código, com datas inventadas e um valor **matematicamente errado** |
| **Não tinha Política de Privacidade** | Ao contrário do que se presumia |
| **Não tinha testes** | Zero. A pasta `test/` estava vazia |
| **Não tinha internacionalização** | ~80 literais em português só no ecrã principal |
| **Continha credenciais** | Artefactos do Firebase com uma chave de API, num projecto sem controlo de versões e com `.gitignore` insuficiente |

### Objectivos

Auditar, corrigir, testar e preparar a aplicação para publicação na Google
Play e para expansão internacional, **preservando tudo o que funcionava**.

### Principais alterações

1. **Correcção do defeito matemático crítico** (raiz quadrada divergente),
   provado por teste antes da correcção.
2. **146 testes automatizados**, onde não havia nenhum, com valores de
   referência deduzidos independentemente da implementação.
3. **Desbloqueio da compilação Android** e preparação da assinatura de
   lançamento.
4. **Internacionalização completa** em 5 idiomas, com uma arquitectura que
   torna estruturalmente impossível um erro chegar ao utilizador sem tradução.
5. **Histórico real e persistente**, substituindo dados fabricados.
6. **Política de Privacidade** dentro da aplicação, nos 5 idiomas, sustentada
   por uma auditoria técnica de privacidade.
7. **Unidade `dBW`** acrescentada, por decisão do proprietário.
8. **Documentação completa**: auditoria, matriz de conversões, loja, ASO,
   privacidade, 8 artigos técnicos, README e guias.

### Estado final

| Verificação | Resultado | Data |
|---|---|---|
| `flutter analyze` | **APROVADO** — «No issues found!» | 2026-10-19 |
| `flutter test` | **APROVADO** — 146 testes | 2026-10-19 |
| `flutter build apk --debug` | **APROVADO** | 2026-10-17 |
| `flutter build apk --release` | **APROVADO** — 53,1 MB | 2026-10-19 |
| `flutter build appbundle --release` | **APROVADO** — 45,0 MB | 2026-10-17 |
| **Instalação em Android real** | **APROVADO** — «Success» | 2026-10-19 |
| **Arranque em Android real** | **APROVADO** — PID 17813, sem falhas | 2026-10-19 |
| Chaves de tradução por traduzir | **ZERO**, nos 5 idiomas | 2026-10-19 |
| Limites das fichas da loja | **APROVADO**, nos 5 idiomas | 2026-10-19 |

**A aplicação está tecnicamente pronta.** O que falta para a publicação são
**acções externas do proprietário** — chave de assinatura, URL pública,
formulário *Data safety*, capturas de ecrã — listadas na secção L.

---

## B. Auditoria matemática

### Conversões analisadas

**49 combinações** entre 7 unidades (`W`, `mW`, `dBm`, `dBW`, `dBu`, `dBV`,
`dB`), inventariadas em [`MATRIZ_CONVERSOES.md`](MATRIZ_CONVERSOES.md) com
fórmula, condições de validade, limites numéricos **medidos** e exemplos
verificados.

### Fórmulas validadas

| Família | Verificação |
|---|---|
| `dBm ↔ mW/W` | 8 âncoras exactas de definição |
| `dBW ↔ W/mW` | 7 âncoras + desvio de 30 dB verificado em toda a gama |
| `dBu ↔ dBV` | Deslocamento constante de 2,213965949874 dB, verificado em 6 níveis |
| Potência ↔ nível de tensão | Contra forma fechada de um só passo, em 4 impedâncias e de −150 a +150 dB |
| `dB` relativo | Razões e somas algébricas, com referência |

### Problemas encontrados e corrigidos

| ID | Problema | Gravidade |
|---|---|---|
| **M1** | **Raiz quadrada iterativa divergente** | **CRÍTICO** |
| M2 | Unidade `dBW` inexistente | Alto (lacuna) |
| M3 | Mensagens de erro nomeavam a unidade interna | Médio |
| M4 | Fórmula apresentada omitia passos intermédios | Baixo |
| M5 | Linguagem de protótipo («MVP») em textos visíveis | Médio |
| M6 | Dois formatadores numéricos divergentes | Médio |
| M7 | Dado fictício matematicamente errado | Baixo |

#### O defeito M1, em detalhe

`V = √(P × R)` usava uma raiz quadrada escrita à mão: Newton–Raphson com **20
iterações fixas** a partir de `x₀ = valor/2`. O método precisa de cerca de
`log₂(valor)` iterações só para atingir a ordem de grandeza correcta.

Erro medido em 50 Ω, contra `dart:math.sqrt`:

| Potência | Valor correcto | Valor produzido | Erro |
|---|---|---|---|
| −90 dBm | −103,0103 dBV | −103,000 dBV | 0,010 dB |
| −100 dBm | −113,0103 dBV | −111,340 dBV | **1,671 dB** |
| −110 dBm | −123,0103 dBV | −114,006 dBV | **9,005 dB** |
| −120 dBm | −133,0103 dBV | −114,352 dBV | **18,659 dB** |
| −130 dBm | −143,0103 dBV | −114,387 dBV | **28,623 dB** |

A gama afectada é a da **sensibilidade de receptores** — GSM, LTE e Wi-Fi
situam-se tipicamente entre −70 e −110 dBm. O erro atingia o caso de uso mais
comum do público-alvo.

**Por que razão passou despercebido:** `flutter analyze` não deteta erros de
algoritmo, e não havia um único teste. Em potências médias — onde se testa à
mão — o resultado estava certo.

**Correcção:** substituído por `dart:math.sqrt`, exacto ao último bit.

### Cobertura de testes

**Medida por contagem de testes, não por percentagem de linhas** — não foi
executada ferramenta de cobertura, pelo que nenhuma percentagem é declarada.

| Ficheiro | Testes |
|---|---|
| `power_converter_service_test.dart` | 38 (incl. varredura de 539 casos) |
| `dbw_conversion_test.dart` | 24 |
| `number_formatting_test.dart` | 14 |
| `conversion_history_test.dart` | 17 |
| `localization_test.dart` | 16 |
| `converter_screen_widget_test.dart` | 33 |
| `version_consistency_test.dart` | 2 |
| **Total** | **146** |

### Independência dos valores de referência

[`test/reference_values.dart`](../test/reference_values.dart) **não importa
nada de `lib/`**. Usa âncoras exactas de definição e **formas fechadas de um
só passo** que eliminam algebricamente a raiz quadrada:

```
L_dBV = 20·log₁₀(√(P·R))  →  10·log₁₀(P·R)
```

Foi esta segunda estratégia que detectou M1: a referência não usa raiz
quadrada nenhuma, pelo que o erro não pôde passar.

**Prova de que os testes detectam o defeito:** executados contra o código
**ainda não corrigido**, 35 passaram e **4 falharam**, todos por M1. Registo
em [`evidence/teste_antes_da_correccao.txt`](evidence/teste_antes_da_correccao.txt).

---

## C. Qualidade do código

### Problemas encontrados

| ID | Problema |
|---|---|
| F1 | Histórico fabricado, com dados falsos e um valor errado |
| F2 | Sem internacionalização |
| F3 | 11 ficheiros de código morto, incluindo um **segundo** `DbKonversorApp` |
| F4 | Contactos pessoais escritos dentro do texto do diálogo |
| F5 | Zero testes |
| F6 | `convert()` invocado duas vezes por mudança de unidade |
| F7 | Atraso fixo de 3 s no arranque |
| F8 | Layout não verificado em tablet nem em horizontal |

### Alterações arquitecturais

**1. A camada de cálculo deixou de conter texto.** Devolve códigos
(`ConversionError`); a tradução acontece num único ponto. O `switch` de
tradução **não tem `default`**, de propósito: um código novo provoca um aviso
do analisador, o que impede estruturalmente que um erro chegue sem tradução.

**2. Formatação numérica unificada**, com a garantia documentada e testada de
que o arredondamento é **só de apresentação** e nunca realimenta um cálculo.

**3. Histórico como camada própria**, com modelo, serialização tolerante a
dados corrompidos e armazenamento isolado.

### Impacto funcional

Nenhuma regressão. A identidade visual, as três animações, o ecrã de abertura,
o identificador, a versão e os recursos gráficos ficaram **intactos**.

---

## D. Internacionalização

### Idiomas implementados

| Idioma | Código | Chaves | Estado |
|---|---|---|---|
| Português | `pt` | 103 | Completo (modelo) |
| Inglês | `en` | 103 | Completo |
| Francês | `fr` | 103 | Completo |
| Espanhol | `es` | 103 | Completo |
| Chinês simplificado | `zh` | 103 | Completo, **sem revisão nativa** |

`l10n_untranslated.json` = `{}` — **zero chaves por traduzir**.

### Recursos criados

`l10n.yaml` · 5 ficheiros ARB · 6 ficheiros gerados ·
`conversion_error.dart` · `conversion_messages.dart`

### Traduções pendentes

- **Revisão da tradução chinesa por falante nativo** com formação técnica.
- Conteúdos de `docs/content/`: 4 de 40 combinações artigo×idioma feitas; ver
  a matriz em [`content/PLANO_EDITORIAL_GLOBAL.md`](content/PLANO_EDITORIAL_GLOBAL.md).

### Testes executados

16 testes de localização, incluindo a verificação de que **todos** os códigos
de erro têm tradução em **todos** os idiomas, e de que os símbolos técnicos
não são traduzidos. Mais testes de widget em pt, en, fr e zh, e a verificação
de que o francês — o idioma com os textos mais longos — não provoca transbordo
num ecrã de 320 dp.

---

## E. Google Play e ASO

### Descrições por idioma

Cinco fichas completas, **verificadas por script** contra os limites de
caracteres:

| Idioma | Nome | Descrição curta | Descrição completa |
|---|---|---|---|
| pt | 12/30 | 72/80 | 2767/4000 |
| en | 12/30 | 66/80 | 2660/4000 |
| fr | 12/30 | 72/80 | 3110/4000 |
| es | 12/30 | 77/80 | 2902/4000 |
| zh | 12/30 | 40/80 | 1098/4000 |

> **Nota de honestidade:** as contagens que eu tinha escrito à mão nestes
> documentos estavam **erradas** (por exemplo, 1932 em vez de 2767). O script
> [`store/verificar_limites.py`](store/verificar_limites.py) detectou as cinco
> divergências e os valores foram corrigidos para os medidos. O script
> continua disponível para reverificar sempre que um texto mudar.

### Palavras-chave

Incorporadas naturalmente no texto, sem repetição artificial. A Google Play
não tem campo de palavras-chave: a indexação vem do nome e das descrições, e
por isso os símbolos das unidades aparecem no início da descrição curta.

### Materiais preparados

Fichas nos 5 idiomas · [`store/ASO_ESTRATEGIA_GLOBAL.md`](store/ASO_ESTRATEGIA_GLOBAL.md)
· plano de capturas · script de captura · textos para as capturas

### Capturas reais geradas

**NENHUMA.** Ver secção K.

### Materiais pendentes

Capturas de ecrã · *feature graphic* (1024 × 500) · ícone de 512 × 512 a
verificar

---

## F. Privacidade

### SDKs encontrados

**Um único plugin nativo:** `shared_preferences_android`. Verificado em
`GeneratedPluginRegistrant.java`, que regista exactamente um plugin.

**Nenhum** SDK de publicidade, análise de utilização, rastreio, notificações
push ou relato de erros.

### Resultado da auditoria

| Conclusão | Evidência |
|---|---|
| Não recolhe dados pessoais | Sem conta, sem formulários, sem identificadores |
| Não transmite dados | Sem código de rede **e** sem permissão de rede |
| Guarda histórico **só no dispositivo** | `SharedPreferences`, área privada da aplicação |
| Firebase não estava activo | Plugin Gradle não aplicado; nenhum pacote no `pubspec.lock` |

**A evidência decisiva** é o manifesto fundido da variante `release`:

| Variante | Permissões |
|---|---|
| **release (publicada)** | apenas `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` (auto-gerada, nível de assinatura, sem acesso a dados) |
| debug | `android.permission.INTERNET` + a anterior |

Sem `INTERNET`, o Android **impede** qualquer transmissão. É uma garantia do
sistema operativo, não uma promessa.

### Política preparada

5 idiomas em `docs/privacy/` **e** dentro da aplicação, acessível pelo menu
lateral sem ligação à Internet.

### URL pública

**NÃO EXISTE e não foi inventada.** Todos os documentos a marcam como
pendente.

### Estado da declaração *Data safety*

**Respostas preparadas, formulário NÃO submetido.** Ver
[`privacy/GUIA_DATA_SAFETY.md`](privacy/GUIA_DATA_SAFETY.md).

A resposta à pergunta principal é **«No»** — e isso é tecnicamente correcto,
não otimismo: a Google define «recolha» como transmissão para fora do
dispositivo, e o histórico nunca sai do dispositivo.

---

## G. Conteúdos técnicos

### Artigos criados

Oito, em [`content/`](content/): dBm→W · W→dBm · dBm vs dBW · dBV vs dBu ·
decibéis em telecomunicações · potência e impedância · erros frequentes ·
exemplos práticos resolvidos.

### Idiomas disponíveis

| Artigo | EN | PT | FR | ES |
|---|---|---|---|---|
| 01 dBm→W | ✔ | ✔ | ✔ | ✔ |
| 03 dBm vs dBW | ✔ | ✔ | — | — |
| 02, 04–08 | ✔ | — | — | — |

### Exemplos verificados

**Todos.** Produzidos por
[`evidence/gerar_exemplos.dart`](evidence/gerar_exemplos.dart), que executa o
código de produção e compara cada resultado com uma forma fechada
independente. Saída registada em
[`evidence/exemplos_verificados.txt`](evidence/exemplos_verificados.txt).

> **Três erros meus, detectados por este processo e corrigidos:** `20 W − 4 dB`
> escrito como 7,94328 W em vez de 7,96214 W (usei 43 dBm arredondado em vez
> de 43,0103); a coluna linear do artigo 05 incoerente com a coluna em dB; e
> uma média dada como 17,0332 dBm em vez de 17,0329 dBm. Um artigo sobre erros
> de conversão que contivesse erros de conversão seria uma ironia cara.

### Referências consultadas

ITU-R V.574 e série V · IEEE Std 100 · IEC 60268 · equação de transmissão de
Friis · ruído térmico `N = kTB`. **Nenhuma medição de campo, dado de operadora
ou estatística foi inventada** — todos os artigos declaram explicitamente que
os valores são exemplos de cálculo.

---

## H. GitHub

| Item | Estado |
|---|---|
| `README.md` | Completo: objectivo, funcionalidades, arquitectura, instalação, testes, compilação, traduções, limitações |
| `CONTRIBUTING.md` | Com a regra obrigatória para alterações matemáticas |
| `CHANGELOG.md` | Auditoria documentada; estado anterior registado |
| `SECURITY.md` | Comunicação privada, superfície de ataque, gestão da chave |
| `.github/ISSUE_TEMPLATE/` | 4 modelos + `config.yml` |
| `.github/PULL_REQUEST_TEMPLATE.md` | Listas específicas por tipo de alteração |
| `.gitignore` | Secção de segredos, com aviso de não remoção |
| **Licença** | **NÃO DEFINIDA** — o README **não** descreve o projecto como *open source* |
| **Repositório Git** | **NÃO INICIALIZADO** — nenhum comando Git foi executado |

> Os URL nos modelos contêm o marcador `<OWNER>/<REPO>`, que tem de ser
> substituído quando o repositório existir. Nenhum URL foi inventado.

---

## I. Testes

| Teste | Comando ou método | Resultado | Evidência | Pendências |
|---|---|---|---|---|
| Dependências | `flutter pub get` | **APROVADO** | «Got dependencies!» | — |
| Geração de localizações | `flutter gen-l10n` | **APROVADO** | 6 ficheiros gerados | — |
| Chaves por traduzir | `l10n_untranslated.json` | **APROVADO** | `{}` | — |
| Análise estática | `flutter analyze` | **APROVADO** | «No issues found!» | — |
| Testes automatizados | `flutter test` | **APROVADO** | 146 testes | — |
| Testes matemáticos | `flutter test test/power_converter_service_test.dart` | **APROVADO** | 38 testes | — |
| Testes de dBW | `flutter test test/dbw_conversion_test.dart` | **APROVADO** | 24 testes | — |
| Testes de formatação | `flutter test test/number_formatting_test.dart` | **APROVADO** | 14 testes | — |
| Testes de histórico | `flutter test test/conversion_history_test.dart` | **APROVADO** | 17 testes | Confirmar em Android real |
| Testes de localização | `flutter test test/localization_test.dart` | **APROVADO** | 16 testes | — |
| Testes de widget | `flutter test test/converter_screen_widget_test.dart` | **APROVADO** | 33 testes | — |
| Regressão do defeito M1 | `flutter test` antes da correcção | **FALHOU (como esperado)** | [`evidence/teste_antes_da_correccao.txt`](evidence/teste_antes_da_correccao.txt) | — |
| Verificação numérica independente | `dart run docs/evidence/gerar_exemplos.dart` | **APROVADO** | [`evidence/exemplos_verificados.txt`](evidence/exemplos_verificados.txt) | — |
| Limites das fichas da loja | `python docs/store/verificar_limites.py` | **APROVADO** | 5 ficheiros | — |
| Compilação de depuração | `flutter build apk --debug` | **APROVADO** | `app-debug.apk` | — |
| Compilação de lançamento (APK) | `flutter build apk --release` | **APROVADO** | 53,1 MB | — |
| Compilação de lançamento (AAB) | `flutter build appbundle --release` | **APROVADO** | 45,0 MB | Assinado com chave de **depuração** |
| Permissões do pacote final | Manifesto fundido de `release` | **APROVADO** | Sem `INTERNET` | — |
| **Instalação em Android real** | `adb install -r app-release.apk` | **APROVADO** | «Success» | — |
| **Arranque em Android real** | `adb shell monkey` + `pidof` | **APROVADO** | PID 17813 | — |
| **Ausência de falhas no arranque** | `adb logcat -d -t 400` | **APROVADO** | Sem `FATAL`/`AndroidRuntime` | — |
| Capturas de ecrã | `capturar.ps1` | **NÃO EXECUTADO** | Dispositivo desligou-se | Ver secção K |
| Persistência em Android real | Manual | **NÃO EXECUTADO** | — | Verificado só por teste |
| Modo de voo | Manual | **NÃO EXECUTADO** | — | — |
| Acessibilidade (TalkBack) | Manual | **NÃO EXECUTADO** | — | — |
| Caracteres chineses em dispositivo | Manual | **NÃO EXECUTADO** | — | — |
| Layout em tablet | Manual | **NÃO EXECUTADO** | — | Verificado por teste de widget |
| Revisão da tradução chinesa | Humana | **PENDENTE DE VALIDAÇÃO EXTERNA** | — | Revisor nativo |
| URL da Política de Privacidade | Externo | **PENDENTE DE VALIDAÇÃO EXTERNA** | — | Alojamento |
| Formulário *Data safety* | Play Console | **PENDENTE DE VALIDAÇÃO EXTERNA** | — | Proprietário |
| Assinatura de lançamento | Externo | **PENDENTE DE VALIDAÇÃO EXTERNA** | — | Proprietário |

**Reexecução completa:** `./scripts/validar.ps1` (ou `-ComCompilacao`). Último
registo: [`evidence/`](evidence/).

---

## J. Inventário de alterações

### Código criado

| Ficheiro | Porquê |
|---|---|
| `lib/core/models/conversion_error.dart` | Códigos de erro traduzíveis |
| `lib/core/localization/conversion_messages.dart` | Único ponto de tradução dos códigos |
| `lib/features/history/conversion_history_entry.dart` | Modelo e serialização do histórico |
| `lib/features/history/conversion_history_store.dart` | Persistência local tolerante a falhas |
| `lib/features/privacy/privacy_policy_screen.dart` | Bloqueador B4 |
| `lib/l10n/app_{pt,en,fr,es,zh}.arb` | Traduções |
| `l10n.yaml` | Configuração da geração |
| `test/*` (8 ficheiros) | 146 testes |
| `scripts/validar.ps1` | Cadeia de validação repetível |

### Código alterado

| Ficheiro | O que mudou |
|---|---|
| `power_converter_service.dart` | **M1** (raiz quadrada), **M2** (dBW), M3, M4, códigos de erro |
| `power_unit.dart` | `dBW`; linguagem de protótipo removida |
| `converter_controller.dart` | Códigos em vez de texto; histórico; F6 |
| `converter_screen.dart` | i18n; histórico real; privacidade; formatação; acessibilidade; layout |
| `splash_screen.dart` | i18n; constante de versão testável |
| `validators.dart` | Devolve códigos em vez de frases |
| `math_utils.dart` | **M6** — formatador único |
| `conversion_result.dart` | Campos de código de erro |
| `main.dart` | Delegados e resolução de idioma |
| `MainActivity.kt` | **B1** — reescrito em Kotlin |
| `build.gradle.kts` | **B2** — assinatura de lançamento |
| `AndroidManifest.xml` | **B3** — nome da aplicação |
| `pubspec.yaml` | `flutter_localizations`, `intl`, `shared_preferences`, `generate: true` |
| `.gitignore` | **P3** — secção de segredos |
| `analysis_options.yaml` | Exclusão de `docs/` |

### Removido

11 ficheiros de código morto e resíduos (F3) · `firebase.json` ·
`android/app/google-services.json` (P1)

---

## K. Riscos residuais

| # | Risco | Porque permanece | Acção recomendada |
|---|---|---|---|
| R1 | **Chave de assinatura não existe** | Acção irreversível: perdê-la impede actualizações para sempre | Gerar e guardar com cópia de segurança; considerar *Play App Signing* |
| R2 | **Projecto não está sob Git** | Nenhum comando Git foi executado sem autorização | `git init` **depois** de confirmar o `.gitignore` |
| R3 | **Chave de API do Firebase pode continuar válida** | A rotação é externa. Não houve exposição pública (nunca esteve num repositório) | Eliminar ou desactivar o projecto `db-konversor` |
| R4 | **Interface nunca foi vista em Android real** | O dispositivo desligou-se antes das capturas. O arranque sem falhas está confirmado, o aspecto não | Executar e observar |
| R5 | **Persistência do histórico não confirmada em Android real** | Verificada por teste automatizado | Converter, fechar, reabrir |
| R6 | **Tradução chinesa sem revisão nativa** | Qualidade terminológica não é auto-verificável | Revisor sinófono antes de promover esse mercado |
| R7 | **TalkBack não testado** | Exige dispositivo | Testar antes de declarar acessibilidade |
| R8 | **Sem URL pública da política** | Exige alojamento | Publicar; a Google Play exige |
| R9 | **Licença não definida** | Decisão do proprietário | Decidir antes de tornar o repositório público |
| R10 | **Contactos pessoais visíveis globalmente** | **Decisão informada do proprietário** de manter os contactos actuais | Considerar contacto institucional se o volume incomodar |
| R11 | **Caracteres chineses não verificados em dispositivo** | ROMs reduzidas podem não ter fontes CJK | Verificar; se falhar, empacotar Noto Sans SC |
| R12 | **R8/ofuscação desactivada** | Activá-la sem validação em dispositivo é arriscado | Activar e testar em dispositivo |
| R13 | **Plataformas não-Android não auditadas** | Fora do âmbito | Auditar antes de publicar noutra plataforma |
| R14 | **Tablet verificado só por teste de widget** | Sem tablet disponível | Capturar em tablet real |

### Sobre o risco R10

O proprietário decidiu manter os contactos actuais (dois números de telefone e
um e-mail pessoal `@gmail.com`), que ficam visíveis no ecrã de Ajuda e na
Política de Privacidade de uma aplicação distribuída globalmente. A decisão
está registada; o risco de exposição e de volume de contacto indesejado fica
assinalado. Os valores foram isolados em constantes, pelo que mudá-los no
futuro não obriga a mexer em cinco ficheiros de tradução.

---

## L. Próximos passos

Ordenados por dependência. Os primeiros quatro são **bloqueadores de
publicação**.

### Prioridade 1 — Bloqueadores

| # | Acção | Depende de |
|---|---|---|
| 1 | **Gerar a chave de assinatura** e criar `android/key.properties`. Procedimento no README. Guardar com cópia de segurança | — |
| 2 | **Publicar a Política de Privacidade** numa URL pública; actualizar as 5 políticas e o README | Alojamento |
| 3 | **Gerar as capturas de ecrã** com `capturar.ps1`, em telefone e tablet | Dispositivo estável |
| 4 | **Criar o *feature graphic*** 1024 × 500 (material distinto das capturas) | Design |

### Prioridade 2 — Verificação em dispositivo

| # | Acção |
|---|---|
| 5 | Observar a interface em Android real e confirmar que corresponde aos testes |
| 6 | Confirmar a persistência do histórico: converter, fechar, reabrir |
| 7 | Testar em modo de voo |
| 8 | Testar com o TalkBack |
| 9 | Verificar os caracteres chineses |
| 10 | Verificar o layout em tablet |

### Prioridade 3 — Publicação

| # | Acção |
|---|---|
| 11 | Compilar o App Bundle **assinado** |
| 12 | Preencher a ficha na Play Console com os textos de `docs/store/` |
| 13 | Preencher o formulário *Data safety* com `privacy/GUIA_DATA_SAFETY.md` |
| 14 | Teste interno antes da publicação aberta |

### Prioridade 4 — Sustentação

| # | Acção |
|---|---|
| 15 | `git init` e primeiro *commit*, com o `.gitignore` confirmado |
| 16 | Decidir a licença |
| 17 | Eliminar ou desactivar o projecto Firebase |
| 18 | Revisão da tradução chinesa |
| 19 | Medir os dados reais da loja e substituir as hipóteses do plano ASO |
| 20 | Continuar as traduções dos conteúdos, segundo o plano editorial |

---

## Nota final sobre o método

Este relatório distingue deliberadamente **o que foi feito** do **que foi
preparado** e do **que depende de intervenção humana**.

Três princípios foram aplicados sem excepção:

1. **Nenhum teste foi declarado aprovado sem ter sido executado.** Os
   resultados vêm de comandos cuja saída está registada.
2. **Nenhum número foi inventado.** Os exemplos vêm do código de produção e
   são confrontados com formas fechadas independentes. Quando as contagens de
   caracteres que escrevi à mão estavam erradas, o script detectou-as e foram
   corrigidas — o erro está registado em vez de apagado.
3. **Nenhuma funcionalidade inexistente foi declarada.** As fichas da loja
   listam apenas as 13 funcionalidades verificadas no código; a secção
   «não suportado» existe precisamente para evitar expectativas erradas.

O defeito mais grave encontrado — um erro de 18,7 dB — estava num código que
passava a análise estática sem um único aviso. É a melhor demonstração do
valor de testes com valores de referência **independentes da implementação**,
e a razão pela qual essa regra está escrita no
[`CONTRIBUTING.md`](../CONTRIBUTING.md) como condição obrigatória para
qualquer alteração futura à matemática.
