# dB Konversor — Auditoria Inicial

**Projecto:** dB Konversor
**Organização:** KUNDIAMA Tecnologia e Inovação
**Caminho auditado:** `C:\Users\pc\Documents\portfolio\db_konversor`
**Data da auditoria:** 2026-10-17
**Ambiente observado:** Windows 11 Pro (10.0.26200), PowerShell, Flutter 3.41.1 (stable, revisão 582a0e7c55), Dart 3.11.0
**Estado deste documento:** registo do estado **inicial**, escrito antes de qualquer alteração ao código.

---

## 1. Estado inicial observado

### 1.1 Estrutura do repositório

```
db_konversor/
├─ lib/
│  ├─ main.dart                  (ponto de entrada efectivo)
│  ├─ main.dart.bak              (resíduo da remoção do Firebase)
│  ├─ app/
│  │  ├─ app.dart                (DbKonversorApp DUPLICADO — não utilizado)
│  │  ├─ app_colors.dart         (paleta clara — não utilizada na UI real)
│  │  └─ app_theme.dart          (tema claro — não utilizado na UI real)
│  ├─ core/
│  │  ├─ constants/app_strings.dart   (não utilizado)
│  │  ├─ models/conversion_result.dart
│  │  └─ power_unit.dart         (enum PowerUnit + categorias)
│  ├─ features/
│  │  ├─ converter/
│  │  │  ├─ converter_screen.dart        (1168 linhas — UI inteira)
│  │  │  ├─ converter_controller.dart
│  │  │  └─ power_converter_service.dart (597 linhas — matemática)
│  │  ├─ splash/splash_screen.dart
│  │  └─ widgets/                (5 widgets — NENHUM utilizado)
│  └─ utils/
│     ├─ math_utils.dart
│     └─ validators.dart
├─ test/                         (VAZIO — zero testes)
├─ android/
├─ assets/{icons,images}/
├─ firebase.json                 (resíduo do Firebase, com identificadores reais)
├─ pubspec.yaml
├─ pubspec.yaml.bak              (resíduo)
└─ README.md                     (template por omissão do Flutter)
```

Outras plataformas presentes por omissão (`ios/`, `web/`, `linux/`, `macos/`, `windows/`) não foram alvo desta auditoria, cujo âmbito é Android.

### 1.2 Verificações executadas

| Verificação | Comando | Resultado | Data |
|---|---|---|---|
| Versão do SDK | `flutter --version` | Flutter 3.41.1 • Dart 3.11.0 | 2026-10-17 |
| Resolução de dependências | `flutter pub get` | **APROVADO** — "Got dependencies!"; 17 pacotes com versões mais recentes incompatíveis com as restrições actuais | 2026-10-17 |
| Análise estática | `flutter analyze` | **APROVADO** — "No issues found! (ran in 2.9s)" | 2026-10-17 |
| Testes automatizados | `flutter test` | **NÃO EXECUTADO** — a pasta `test/` está vazia | 2026-10-17 |
| Estado do Git | `git status` | **NÃO APLICÁVEL** — o directório **não é um repositório Git** | 2026-10-17 |
| Histórico de commits | `git log` | **NÃO APLICÁVEL** — sem repositório | 2026-10-17 |

> Nota importante: a análise estática limpa **não** significa ausência de defeitos. O erro
> matemático mais grave encontrado (secção 3, M1) passa a análise estática sem qualquer aviso,
> porque é um erro de algoritmo e não de tipos ou de sintaxe.

### 1.3 Estado face ao contexto fornecido no pedido

O pedido descrevia um estado anterior que foi necessário confirmar. Resultado da confirmação:

| Afirmação do contexto | Estado real verificado |
|---|---|
| "A dependência `firebase_core` foi removida" | **Confirmado** em `pubspec.yaml` e em `pubspec.lock` (nenhum pacote Firebase). Mas **ficaram artefactos**: `firebase.json` e `android/app/google-services.json` (ver P1). |
| "O identificador Android foi alterado" | **Confirmado**: `applicationId` e `namespace` = `ao.kundiama.dbkonversor`. Mas a migração do `MainActivity.kt` **falhou** (ver B1). |
| "A Política de Privacidade foi integrada numa página interna" | **NÃO CONFIRMADO.** Uma busca por `privac`/`política` em `lib/` e `android/` não devolve nenhuma ocorrência. **Não existe** qualquer página, ecrã ou texto de Política de Privacidade na aplicação nem no repositório. |
| "Histórico local" | **Parcialmente falso.** Existe um painel de histórico, mas o conteúdo é estático e fabricado em código (ver F1). Não existe persistência nem dependência capaz de a suportar. |
| "Conversões locais, sem publicidade" | **Confirmado pelas evidências:** zero SDKs de terceiros; o manifesto de `release` não declara a permissão `INTERNET` (ver P2). |

---

## 2. Funcionalidades encontradas

### 2.1 Implementadas e funcionais

- **Ecrã de abertura (splash)** com animações e logótipo (`assets/images/dB_k_logo.png`), transição automática após 3 s fixos para o conversor.
- **Conversor principal** (`ConverterScreen`): campo de valor de entrada, selecção de unidade de entrada e de saída por `DropdownButton`, botão de inversão de unidades, resultado actualizado a cada alteração de texto.
- **Campo de impedância contextual**, apresentado apenas quando a conversão relaciona tensão e potência.
- **Campo de valor de referência contextual**, apresentado quando uma das unidades é `dB`, com rótulo adaptado à unidade (dBm, dBV, dBu, W, mW).
- **Diálogo de fórmula**, com a fórmula aplicada na conversão corrente.
- **Diálogo de ajuda**, com instruções de utilização e contactos.
- **Menu lateral (drawer) de consulta de unidades**, com descrição de cada unidade e opção de a usar como entrada ou saída.
- **Motor de conversão** (`PowerConverterService`) com 6 unidades: `W`, `mW`, `dB`, `dBm`, `dBu`, `dBV`.
- **Validação de entrada** (`Validators`): valor vazio, valor não numérico, impedância ausente ou não positiva, argumento de logaritmo não positivo. Aceita vírgula como separador decimal.
- **Tratamento de valores não finitos**: o serviço rejeita entradas não finitas e resultados não finitos (`_success` verifica `isFinite`).
- **Ícone de aplicação** configurado via `flutter_launcher_icons`, com ícone adaptativo e fundo `#050B18`.

### 2.2 Incompletas, simuladas ou ausentes

- **Histórico**: simulado com dados fixos escritos em código. Sem persistência.
- **Internacionalização**: inexistente. Todos os textos estão em português, escritos directamente nos widgets.
- **Política de Privacidade**: inexistente no produto e no repositório.
- **Testes automatizados**: inexistentes.
- **Assinatura de lançamento Android**: inexistente (usa chaves de depuração).
- **Unidade `dBW`**: não implementada (ver M2).
- **Licença do projecto**: não definida.
- **Acessibilidade**: não há `Semantics`, rótulos de acessibilidade nem suporte explícito a leitores de ecrã.

---

## 3. Problemas confirmados

Classificação: **[BLOQ]** impede a publicação · **[CRÍT]** compromete a correcção do produto · **[ALTO]** · **[MÉDIO]** · **[BAIXO]**

### Bloqueadores de compilação e de publicação

| ID | Grav. | Ficheiro | Problema |
|---|---|---|---|
| **B1** | BLOQ | `android/app/src/main/kotlin/ao/kundiama/dbkonversor/MainActivity.kt` | **O ficheiro não contém código Kotlin.** Contém o *script PowerShell* que foi escrito para fazer a migração do pacote, gravado por engano sobre o destino. O `AndroidManifest.xml` declara `android:name=".MainActivity"`, uma classe que não existe. A compilação Android falha e, se compilasse, a aplicação não arrancaria. O ficheiro antigo `kotlin/com/example/db_konversor/MainActivity.kt` foi removido; o directório ficou vazio. |
| **B2** | BLOQ | `android/app/build.gradle.kts` | A variante `release` usa `signingConfig = signingConfigs.getByName("debug")`. Um pacote assinado com a chave de depuração **é rejeitado pela Google Play**. Os dois `TODO` originais do template continuam presentes. |
| **B3** | ALTO | `android/app/src/main/AndroidManifest.xml` | `android:label="db_konversor"`. O nome apresentado no dispositivo e no lançador seria `db_konversor` em vez de `dB Konversor`. |
| **B4** | BLOQ | — | **Não existe Política de Privacidade.** A Google Play exige uma URL pública de Política de Privacidade e a declaração *Data safety* para todas as aplicações. |
| **B5** | ALTO | — | **O projecto não está sob controlo de versões.** Não há repositório Git, logo não há histórico, não há reversão possível e o `.gitignore` existente não protege nada. |

### Erros matemáticos

| ID | Grav. | Ficheiro | Problema |
|---|---|---|---|
| **M1** | **CRÍT** | `power_converter_service.dart:584-596` | **Raiz quadrada implementada à mão e divergente.** `_sqrt()` aplica 20 iterações de Newton–Raphson a partir de `x₀ = valor/2`. Este método precisa de aproximadamente `log₂(valor)` iterações só para chegar à ordem de grandeza correcta, pelo que 20 iterações são insuficientes fora de um intervalo restrito. A função é usada em `V = √(P × R)`, isto é, em **todas** as conversões de potência para nível de tensão (`W`/`mW`/`dBm` → `dBV`/`dBu`). Erro medido (impedância de 50 Ω), comparando com `dart:math.sqrt`: <br>• `−90 dBm` → erro de 0,010 dB<br>• `−100 dBm` → erro de **1,671 dB**<br>• `−110 dBm` → erro de **9,005 dB**<br>• `−120 dBm` → erro de **18,659 dB**<br>• `−130 dBm` → erro de **28,623 dB**<br>• `+200 dBm` → erro de **60,557 dB**<br>A gama afectada (−90 dBm e inferior) é precisamente a gama da **sensibilidade de receptores** em telecomunicações (GSM, LTE, Wi-Fi situam-se tipicamente entre −70 dBm e −110 dBm), ou seja, o erro atinge o caso de uso mais comum do público-alvo. `dart:math.sqrt` está disponível e é exacto; não há qualquer justificação para a implementação manual. |
| **M2** | ALTO | `lib/core/power_unit.dart` | **A unidade `dBW` não existe.** O enum `PowerUnit` tem apenas `watt, milliwatt, db, dbm, dbu, dbv`. `dBW` é uma das unidades mais pedidas em telecomunicações e radiodifusão (`P_dBW = 10·log₁₀(P_W)`, `P_dBm = P_dBW + 30`). Não é um defeito do que existe, é uma lacuna face ao mercado-alvo. **Requer decisão do proprietário** antes de implementar. |
| **M3** | MÉDIO | `power_converter_service.dart:474-479, 547-552` | **Mensagens de erro referem a unidade intermédia, não a do utilizador.** Ao converter `0 W → dBm`, o pipeline passa por mW e a mensagem produzida é "O valor em **mW** deve ser maior que zero", apesar de o utilizador ter introduzido watts. O mesmo sucede com `V` nas conversões de nível de tensão. Confunde o utilizador. |
| **M4** | BAIXO | `power_converter_service.dart:294-299` | **A fórmula apresentada perde passos intermédios.** Em `W → dBm`, o diálogo mostra apenas `dBm = 10 × log10(mW)`, omitindo a conversão `mW = W × 1000`. O valor calculado está correcto; apenas a fórmula exibida é incompleta. Como a apresentação da fórmula é um argumento pedagógico do produto, é relevante. |
| **M5** | MÉDIO | `power_unit.dart:42`, `app_strings.dart:36-37` | **Textos visíveis ao utilizador referem "MVP".** A descrição de `dB` diz "Não representa potência absoluta neste MVP." e `AppStrings.dbUnsupportedMessage` fala de "Neste MVP". Linguagem de protótipo num produto a publicar; além disso a segunda afirmação está desactualizada, porque `dB` **é** convertido desde que seja fornecida uma referência. |
| **M6** | MÉDIO | `math_utils.dart:12-26` vs `converter_screen.dart:738-759` | **Dois formatadores numéricos divergentes.** `MathUtils.formatResult` (limiares 1000/100/10/1/0,001) só é usado pelo widget morto `ResultCard`; a UI real usa `_ConverterScreenState._formatValue` (limiares diferentes e remoção de zeros por expressão regular). Duplicação com regras inconsistentes e nenhum teste. |
| **M7** | BAIXO | `converter_screen.dart:640-647` | **Os dados fictícios do histórico contêm um resultado matematicamente errado:** `0.775 dBu → 0.614 dBV`. O valor correcto é `0,775 dBu ≈ −1,452 dBV` (`V = 0,775 × 10^(0,775/20) = 0,8461 V`; `20·log₁₀(0,8461) = −1,452`). Dados falsos *e* incorrectos visíveis ao utilizador num produto cujo valor é a exactidão. |

### Funcionalidade, qualidade e manutenção

| ID | Grav. | Ficheiro | Problema |
|---|---|---|---|
| **F1** | ALTO | `converter_screen.dart:629-648` | **O histórico é falso.** `_showHistorySheet` constrói a lista a cada abertura: a primeira entrada reflecte a conversão corrente (rotulada "Agora") e as outras duas são literais fixas, com datas inventadas (`21/04/2026 • 15:48`, `21/04/2026 • 15:30`). Não há registo de conversões anteriores, não há persistência, não há limpeza, e nenhuma dependência de armazenamento está instalada. Apresentar isto como "histórico" na loja seria uma declaração falsa de funcionalidade. |
| **F2** | ALTO | todo o `lib/` | **Sem internacionalização.** Nenhum uso de `flutter_localizations`, `intl` ou ARB. Todos os textos estão escritos em português dentro dos widgets (≈80 literais só em `converter_screen.dart`). `AppStrings`, que centralizaria parte deles, **não é importado por nenhum ficheiro**. Impede o mercado global pretendido. |
| **F3** | MÉDIO | 10 ficheiros | **Código morto e resíduos.** Não referenciados por nenhum ficheiro vivo: `lib/app/app.dart` (declara um **segundo** `DbKonversorApp`, duplicando o de `main.dart`), `lib/app/app_theme.dart`, `lib/app/app_colors.dart` (tema **claro**, incompatível com a UI escura real), `lib/core/constants/app_strings.dart`, e os cinco widgets `lib/features/widgets/{result_card,formula_card,impedance_field,unit_dropdown,value_input_field}.dart`. Resíduos de edição: `lib/main.dart.bak`, `pubspec.yaml.bak`. A existência de duas classes `DbKonversorApp` e de dois formatadores é uma armadilha de manutenção concreta. |
| **F4** | ALTO | `converter_screen.dart:604-606` | **Dados de contacto pessoais escritos em código**, visíveis no diálogo de ajuda: dois números de telefone e um endereço de e-mail pessoal (`@gmail.com`). Numa aplicação publicada globalmente, convém usar um contacto institucional. Não traduzíveis, não alteráveis sem recompilar. |
| **F5** | ALTO | `test/` | **Zero testes.** Não existe nenhum teste unitário, de widget ou de integração para um produto cuja proposta de valor é a correcção numérica. O defeito M1 teria sido detectado por um único teste de conversão inversa. |
| **F6** | BAIXO | `converter_screen.dart:91-99, 218-245` | **`convert()` é invocado duas vezes** em cada mudança de unidade: `controller.setFromUnit()` já chama `convert()` internamente, e o ecrã chama `controller.convert()` imediatamente depois. Sem efeito incorrecto, mas duplica trabalho e `notifyListeners()`. |
| **F7** | BAIXO | `splash_screen.dart:59` | Atraso fixo de 3 segundos antes do conversor, sem possibilidade de o saltar com um toque. |
| **F8** | BAIXO | `converter_screen.dart` | **Layout não verificado em tablet nem em horizontal.** O corpo está limitado a `maxWidth: 520` e centrado, o que é razoável, mas não há `LayoutBuilder` nem variação por classe de dimensão, e não existe ainda nenhuma captura real para confirmar o comportamento. |

### Privacidade e segurança

| ID | Grav. | Ficheiro | Problema |
|---|---|---|---|
| **P1** | ALTO | `firebase.json`, `android/app/google-services.json` | **Artefactos do Firebase permaneceram no repositório** após a remoção de `firebase_core`. Contêm `project_id`, `project_number`, `mobilesdk_app_id`, `storage_bucket` e uma **chave de API** (`api_key.current_key`). O plugin `com.google.gms.google-services` **não** está aplicado em nenhum ficheiro Gradle e nenhum pacote Firebase consta de `pubspec.lock`, pelo que **estes ficheiros estão inertes em tempo de execução** — não há recolha de dados por esta via. O risco é de **exposição da credencial** quando o projecto for para o GitHub, e de confusão na declaração *Data safety*. O valor da chave **não é reproduzido neste relatório**. Procedimento recomendado na Fase 7 (remoção, `.gitignore`, e rotação/eliminação do projecto Firebase pelo proprietário). |
| **P2** | — | `android/app/src/main/AndroidManifest.xml` | **Evidência favorável, a preservar:** o manifesto principal **não declara a permissão `INTERNET`**. Ela só existe em `src/debug/` e `src/profile/`, variantes que não entram no pacote de lançamento. Combinado com a ausência de SDKs de terceiros, isto sustenta tecnicamente a afirmação de funcionamento totalmente local no `release`. Deve ser verificado no manifesto fundido do pacote final antes de ser declarado à Google Play. |
| **P3** | ALTO | `.gitignore` | **Não protege segredos.** Não exclui `android/key.properties`, `*.jks`, `*.keystore`, `android/app/google-services.json`, `firebase.json` nem `android/local.properties` (que contém caminhos locais do sistema). Com B5 (ausência de Git), o primeiro `git add .` publicaria a chave de API do Firebase e, mais tarde, a chave de assinatura. |

---

## 4. Riscos identificados

| Risco | Probabilidade | Impacto | Mitigação planeada |
|---|---|---|---|
| Resultados errados em potências baixas (M1) chegarem ao utilizador final | **Certa** no estado actual | **Muito alto** — destrói a credibilidade técnica, que é a única proposta de valor do produto | Substituir `_sqrt` por `dart:math.sqrt`; criar testes de conversão inversa que falhem com a implementação antiga |
| Compilação Android falhar (B1) | **Certa** | Alto — nada pode ser publicado | Reescrever `MainActivity.kt` em Kotlin |
| Rejeição pela Google Play por assinatura de depuração (B2) | **Certa** | Alto | Preparar `signingConfig` de `release` lido de `key.properties`; a geração da chave exige acção do proprietário |
| Rejeição ou remoção por falta de Política de Privacidade e *Data safety* (B4) | **Certa** | Alto | Produzir a política nos 5 idiomas, integrá-la na aplicação, e preparar as respostas do formulário; a publicação da URL exige acção externa |
| Fuga da chave de API do Firebase ao publicar no GitHub (P1+P3+B5) | Alta | Médio — a chave é de um projecto que deixou de ser usado, mas continua a ser uma credencial | Remover artefactos, reforçar `.gitignore`, recomendar eliminação do projecto Firebase ao proprietário |
| Fuga da chave de assinatura (`.jks`) no futuro (P3) | Média | **Muito alto** — uma chave de assinatura comprometida não é recuperável e impede actualizações da aplicação | Reforçar `.gitignore` **antes** de criar a chave e antes de inicializar o Git |
| Declarar na loja funcionalidades inexistentes — "histórico" (F1), "offline" (P2) | Alta se os textos forem escritos sem auditoria | Médio — suspensão da ficha por declaração enganosa | Só declarar o que ficar verificado; corrigir o histórico ou não o anunciar |
| Regressão ao introduzir a internacionalização em 1168 linhas de UI sem rede de segurança (F2+F5) | Alta | Médio | Criar os testes **antes** da internacionalização |
| Perda de trabalho por ausência de controlo de versões (B5) | Média | Alto | Recomendar `git init` ao proprietário; nenhum comando Git será executado sem autorização |
| Expectativa de precisão não cumprida em valores extremos | Média | Médio | Documentar limites de validade na matriz de conversões e nas notas técnicas |

---

## 5. Testes que podem ser executados neste ambiente

| Teste | Comando | Estado inicial |
|---|---|---|
| Resolução de dependências | `flutter pub get` | Já executado — APROVADO |
| Análise estática | `flutter analyze` | Já executado — APROVADO |
| Testes unitários da matemática | `flutter test` | A criar na Fase 2 |
| Testes de widget da UI | `flutter test` | A criar na Fase 2 |
| Testes de localização | `flutter test` | A criar na Fase 4 |
| Verificação numérica independente | script Dart autónomo em `docs/evidence/` | A criar na Fase 2 |
| Compilação Android de depuração | `flutter build apk --debug` | Bloqueada por B1 |
| Compilação de lançamento (não assinada para a loja) | `flutter build appbundle --release` | Bloqueada por B1 e B2 |

## 6. Testes que dependem de dispositivos, serviços externos ou validação humana

| Teste | Dependência | Porquê |
|---|---|---|
| Capturas de ecrã reais (telemóvel, tablet 7", tablet 10") | Emulador ou dispositivo Android | `flutter devices` tem de listar um alvo; as imagens não podem ser inventadas |
| Layout em horizontal e em diferentes densidades | Emulador ou dispositivo | Só verificável com execução real |
| Acessibilidade com leitor de ecrã (TalkBack) | Dispositivo Android | Não simulável em testes automatizados |
| Persistência do histórico entre reinícios | Dispositivo + decisão sobre a dependência de armazenamento | Não existe armazenamento implementado |
| Comportamento sem ligação à Internet | Dispositivo em modo de voo | Confirmação empírica da evidência P2 |
| Assinatura de lançamento | **Proprietário** | Exige gerar e guardar uma chave privada; não será feito sem autorização |
| Publicação da URL da Política de Privacidade | **Proprietário** + alojamento web | Acção externa |
| Formulário *Data safety* e ficha da loja | **Proprietário** + Google Play Console | Acção externa |
| Escolha da licença do projecto | **Proprietário** | Decisão jurídica, não técnica |
| Validação da tradução técnica para chinês simplificado | Revisor humano | A qualidade terminológica não é auto-verificável |
| Confirmação dos contactos institucionais e da entidade jurídica | **Proprietário** | Não podem ser inventados na política de privacidade |

---

## 7. Plano de execução por prioridade

A ordem obedece a dois princípios: **primeiro a correcção, depois a expansão**; e **criar os testes antes de refactorizar**, para que a internacionalização não introduza regressões silenciosas.

### Prioridade 1 — Correcção matemática (Fase 2)
1. Inventariar todas as conversões realmente suportadas → `docs/MATRIZ_CONVERSOES.md`.
2. Escrever a verificação numérica independente de `_sqrt` e registar a evidência.
3. Criar a bateria de testes matemáticos em `test/`, com valores de referência calculados **fora** da implementação testada, incluindo um teste que falhe com o `_sqrt` actual.
4. Corrigir **M1** (`dart:math.sqrt`), com comentário técnico a explicar o motivo.
5. Corrigir **M3** (mensagens com a unidade do utilizador) e **M4** (fórmula completa).
6. Unificar a formatação numérica (**M6**) e garantir que o arredondamento é só de apresentação.
7. Executar `flutter test` e registar resultados.

### Prioridade 2 — Desbloquear a compilação Android (Fase 3)
8. Reescrever `MainActivity.kt` em Kotlin (**B1**).
9. Corrigir `android:label` para `dB Konversor` (**B3**).
10. Preparar a configuração de assinatura de `release` a partir de `key.properties`, degradando para depuração apenas em ausência do ficheiro, sem gerar chaves (**B2**).
11. Remover os artefactos do Firebase e reforçar o `.gitignore` (**P1**, **P3**).
12. Compilar em depuração e confirmar.

### Prioridade 3 — Correcção funcional e limpeza (Fase 3)
13. Substituir o histórico fabricado por um histórico real das conversões da sessão (**F1**, **M7**); a persistência entre reinícios **depende de decisão** sobre uma dependência de armazenamento.
14. Remover o código morto e os resíduos (**F3**), preservando o que a UI real utiliza.
15. Eliminar a linguagem de protótipo ("MVP") dos textos visíveis (**M5**).
16. Substituir os contactos pessoais por contactos institucionais confirmados (**F4**) — **depende de confirmação do proprietário**.
17. Eliminar a dupla invocação de `convert()` (**F6**).

### Prioridade 4 — Internacionalização (Fase 4)
18. Introduzir `flutter_localizations` + `intl` + ARB para `pt`, `en`, `fr`, `es`, `zh-CN`.
19. Extrair todos os literais da UI para os recursos de localização, sem tocar nas fórmulas.
20. Testes de localização e `docs/GUIA_LOCALIZACAO.md`.

### Prioridade 5 — Privacidade (Fase 7)
21. Auditoria de tratamento de dados com base em evidências → `docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`.
22. Política de Privacidade nos 5 idiomas, coerente com o comportamento auditado.
23. Integrar a página na aplicação (satisfaz **B4** do lado do produto).
24. `docs/privacy/GUIA_DATA_SAFETY.md` com as respostas a introduzir na Play Console.

### Prioridade 6 — Loja, conteúdos e documentação (Fases 5, 6, 8, 9)
25. Fichas da loja nos 5 idiomas e estratégia ASO.
26. Plano e scripts de capturas de ecrã; geração real **se** houver emulador disponível.
27. Oito artigos técnicos com exemplos numéricos verificados contra os testes.
28. `README.md`, `CONTRIBUTING.md`, `CHANGELOG.md`, `SECURITY.md` e modelos do GitHub.

### Prioridade 7 — Validação final (Fases 10, 11)
29. Reexecutar toda a cadeia de validação e registar os resultados.
30. `docs/RELATORIO_FINAL_AUDITORIA.md`, distinguindo o que foi feito, o que foi preparado e o que depende de intervenção humana.

---

## 8. Decisões que requerem o proprietário

Estas questões não serão respondidas por invenção. Estão registadas aqui e são colocadas antes das fases que delas dependem.

| # | Questão | Fase bloqueada |
|---|---|---|
| D1 | Implementar a unidade **`dBW`** (M2)? É uma expansão de funcionalidade, não uma correcção. | Fase 2 |
| D2 | O histórico deve **persistir entre reinícios**? Isso exige uma dependência de armazenamento (`shared_preferences`); sem ela, o histórico fica limitado à sessão. | Fase 3 |
| D3 | Que **contactos institucionais** e que **entidade jurídica** devem constar da Política de Privacidade e da ficha da loja? Os actuais são pessoais (F4). | Fases 7 e 5 |
| D4 | Que **licença** atribuir ao projecto? Sem licença, o repositório não pode ser descrito como *open source*. | Fase 9 |
| D5 | Existe uma **URL pública** confirmada para a Política de Privacidade? | Fase 7 |

---

## 9. Conclusão da Fase 1

O dB Konversor tem uma arquitectura compreensível, uma identidade visual coerente e um motor de conversão cuja estrutura (pivô por mW e por volts) está bem concebida. Passa a análise estática sem avisos.

No entanto, no estado inicial **não é publicável e não é numericamente fiável**:

- **não compila** para Android (B1);
- **não pode ser assinado** para a loja (B2);
- **produz resultados errados** nas conversões de potência para nível de tensão em potências baixas, exactamente na gama de sensibilidade de receptores (M1, erro de 18,7 dB a −120 dBm);
- **apresenta um histórico fabricado**, com um dos valores fictícios matematicamente errado (F1, M7);
- **não tem Política de Privacidade** (B4), ao contrário do que se presumia;
- **não tem testes** (F5) nem **internacionalização** (F2);
- mantém **credenciais do Firebase** num repositório sem controlo de versões e com `.gitignore` insuficiente (P1, P3, B5).

Nenhuma alteração ao código foi efectuada até ao momento do registo deste documento.
