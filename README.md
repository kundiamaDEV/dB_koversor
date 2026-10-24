# dB Konversor

**Conversor de decibéis e unidades de potência para telecomunicações,
electrónica, radiofrequência e áudio.**

Desenvolvido pela **KUNDIAMA Tecnologia e Inovação**.

> **Estado do projecto:** em preparação para publicação na Google Play.
> Funcional e testado; com acções externas pendentes, listadas na secção
> [Limitações conhecidas](#limitações-conhecidas).
>
> **Licença:** ainda **não definida**. Todos os direitos reservados. Este
> repositório **não é** um projecto *open source* — ver
> [Licença](#licença).

---

## Índice

- [Objectivo](#objectivo)
- [Funcionalidades](#funcionalidades)
- [Idiomas suportados](#idiomas-suportados)
- [Tecnologias](#tecnologias)
- [Arquitectura](#arquitectura)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e configuração](#instalação-e-configuração)
- [Executar em desenvolvimento](#executar-em-desenvolvimento)
- [Executar os testes](#executar-os-testes)
- [Compilar para Android](#compilar-para-android)
- [Traduções](#traduções)
- [Política de Privacidade](#política-de-privacidade)
- [Documentação de auditoria](#documentação-de-auditoria)
- [Contribuir](#contribuir)
- [Licença](#licença)
- [Contactos](#contactos)
- [Limitações conhecidas](#limitações-conhecidas)

---

## Objectivo

Converter entre unidades de potência e níveis logarítmicos com rigor
verificável, mostrando a fórmula aplicada em cada conversão.

O que distingue este conversor de uma calculadora de unidades genérica:

- **Sabe que dBm e dBV são grandezas diferentes** — uma é potência, a outra
  tensão — e por isso pede a **impedância** nas conversões que a exigem
  (`V = √(P·R)`), em vez de assumir 50 Ω em silêncio.
- **Mostra a cadeia completa de cálculo**, não apenas o resultado.
- **Recusa explicitamente** conversões matematicamente inválidas, como
  `log₁₀(0)`, em vez de devolver `0`, `NaN` ou `Infinity`.
- **Verifica-se a si mesmo:** 146 testes automatizados, com valores de
  referência deduzidos independentemente da implementação testada.

Público: estudantes e professores de engenharia, técnicos de redes,
engenheiros de radiofrequência e de telecomunicações, técnicos de áudio e
radioamadores.

---

## Funcionalidades

Apenas o que está implementado e coberto por testes:

| Funcionalidade | Detalhe |
|---|---|
| **7 unidades** | `W`, `mW`, `dBm`, `dBW`, `dBu`, `dBV`, `dB` |
| **49 combinações de conversão** | Todas documentadas em [`docs/MATRIZ_CONVERSOES.md`](docs/MATRIZ_CONVERSOES.md) |
| **Fórmula visível** | Cadeia completa de passos, por conversão |
| **Impedância contextual** | Pedida apenas quando a conversão relaciona potência e tensão |
| **Referência contextual** | Pedida nas conversões relativas em `dB`, na unidade correcta |
| **Inversão de unidades** | Um toque |
| **Cálculo em tempo real** | Resultado actualizado à medida que se escreve |
| **Histórico local** | Últimas 50 conversões, persistidas no dispositivo |
| **Limpeza do histórico** | Pelo utilizador, com confirmação |
| **Consulta de unidades** | Menu lateral com a descrição e a referência de cada unidade |
| **Política de Privacidade** | Consultável na aplicação, sem ligação à Internet |
| **Funcionamento local** | A versão de lançamento **não declara a permissão de acesso à rede** |
| **Sem publicidade nem conta** | Zero SDKs de terceiros |
| **Acessibilidade** | Descrições nos botões só com ícone; rótulo semântico no resultado |

### Não suportado (registado para evitar expectativas erradas)

`dBi`, `dBd` (ganho de antena) · `dBc` · `dBFS` · `dBSPL` · `dBμV`, `dBmV` ·
impedância complexa · regimes não sinusoidais. Ver a secção 7 de
[`docs/MATRIZ_CONVERSOES.md`](docs/MATRIZ_CONVERSOES.md).

---

## Idiomas suportados

| Idioma | Código | Estado |
|---|---|---|
| Português | `pt` | Completo (idioma modelo) |
| Inglês | `en` | Completo |
| Francês | `fr` | Completo |
| Espanhol | `es` | Completo |
| Chinês simplificado | `zh` | Completo, **pendente de revisão por falante nativo** |

103 chaves de tradução por idioma, zero por traduzir. Procedimento em
[`docs/GUIA_LOCALIZACAO.md`](docs/GUIA_LOCALIZACAO.md).

---

## Tecnologias

| Componente | Versão usada no desenvolvimento |
|---|---|
| Flutter | 3.41.1 (canal stable) |
| Dart | 3.11.0 |
| Android `minSdk` | 24 |
| Android `targetSdk` | 36 |
| Java / Kotlin JVM target | 17 |
| Gradle Plugin (Android) | 8.11.1 |
| Kotlin | 2.2.20 |

### Dependências de produção

| Pacote | Função |
|---|---|
| `flutter`, `flutter_localizations` | SDK e traduções dos widgets do sistema |
| `intl` | Suporte dos ficheiros ARB gerados |
| `shared_preferences` | Persistência local do histórico |
| `cupertino_icons` | Tipo de letra de ícones |

Nenhum SDK de publicidade, análise de utilização, rastreio ou relato de erros.
Auditoria completa das dependências, incluindo as transitivas, em
[`docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`](docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md).

---

## Arquitectura

Camadas com uma regra central: **a matemática não conhece a interface**.

```
┌─────────────────────────────────────────────────────────────┐
│  Interface (features/)                                      │
│  converter_screen · splash_screen · privacy_policy_screen   │
│  Traduz os códigos em texto. Nenhuma frase escrita no code  │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│  Estado (ConverterController, ChangeNotifier)               │
│  Devolve ConversionKind e ConversionError, nunca texto      │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│  Cálculo (PowerConverterService, Validators)                │
│  Dart puro. Sem BuildContext, sem widgets, sem texto de UI  │
│  Pivôs internos: mW para potência, volts para tensão        │
└────────────────────────┬────────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────────┐
│  Modelos (core/)                                            │
│  PowerUnit · ConversionResult · ConversionError             │
└─────────────────────────────────────────────────────────────┘
```

### Duas decisões de desenho que convém conhecer

**1. A camada de cálculo devolve códigos, não mensagens.**
`PowerConverterService` nunca produz uma frase para o utilizador: devolve um
`ConversionError`. A tradução acontece num único ponto,
`core/localization/conversion_messages.dart`, cujo `switch` **não tem
`default`** — de propósito. Se um código novo for acrescentado ao enum, o
analisador acusa o `switch` incompleto, o que impede estruturalmente que um
erro chegue ao utilizador sem tradução.

**2. Conversão por pivôs.** Toda a potência passa por mW; todo o nível de
tensão passa por volts. Com 7 unidades, isto evita escrever 49 conversões
directas, e concentra cada fórmula num só lugar.

---

## Estrutura de pastas

```
db_konversor/
├─ lib/
│  ├─ main.dart                       Ponto de entrada; localização
│  ├─ core/
│  │  ├─ power_unit.dart              As 7 unidades e as suas categorias
│  │  ├─ models/
│  │  │  ├─ conversion_result.dart
│  │  │  └─ conversion_error.dart     Códigos de erro traduzíveis
│  │  └─ localization/
│  │     └─ conversion_messages.dart  Códigos → texto traduzido
│  ├─ features/
│  │  ├─ converter/
│  │  │  ├─ power_converter_service.dart   A matemática
│  │  │  ├─ converter_controller.dart      O estado
│  │  │  └─ converter_screen.dart          A interface
│  │  ├─ history/
│  │  │  ├─ conversion_history_entry.dart  Modelo e serialização
│  │  │  └─ conversion_history_store.dart  Persistência local
│  │  ├─ privacy/privacy_policy_screen.dart
│  │  └─ splash/splash_screen.dart
│  ├─ l10n/
│  │  ├─ app_{pt,en,fr,es,zh}.arb     Traduções (editar aqui)
│  │  └─ generated/                   Código gerado (NÃO editar)
│  └─ utils/
│     ├─ math_utils.dart              log10, pow10, formatação única
│     └─ validators.dart              Validação com códigos de erro
├─ test/                              146 testes
│  ├─ reference_values.dart           Valores de referência INDEPENDENTES
│  ├─ power_converter_service_test.dart
│  ├─ dbw_conversion_test.dart
│  ├─ number_formatting_test.dart
│  ├─ conversion_history_test.dart
│  ├─ localization_test.dart
│  ├─ converter_screen_widget_test.dart
│  └─ version_consistency_test.dart
├─ docs/                              Auditoria, loja, privacidade, conteúdos
├─ android/
├─ assets/{icons,images}/
├─ l10n.yaml                          Configuração da geração de traduções
└─ pubspec.yaml
```

---

## Pré-requisitos

| Requisito | Versão |
|---|---|
| Flutter SDK | 3.41.1 ou superior (canal stable) |
| Dart SDK | 3.11.0 ou superior (vem com o Flutter) |
| Android SDK | Plataforma 36, *build-tools* correspondentes |
| JDK | 17 |
| Para compilar para Android | Android Studio ou as *command-line tools* |

Confirmar o ambiente:

```powershell
flutter --version
flutter doctor
```

O desenvolvimento foi feito em **Windows 11 com PowerShell**; os comandos
abaixo estão nessa forma. O projecto não depende do sistema operativo: em Linux
e macOS os mesmos comandos funcionam numa shell POSIX, trocando apenas a
sintaxe de caminhos e de variáveis de ambiente.

---

## Instalação e configuração

```powershell
# 1. Obter o código
git clone <URL-do-repositorio>
cd db_konversor

# 2. Instalar as dependências
flutter pub get

# 3. Gerar os ficheiros de localização
flutter gen-l10n

# 4. Confirmar que está tudo bem
flutter analyze
flutter test
```

### Configuração local do Android

`android/local.properties` **não está no controlo de versões** (contém
caminhos da máquina). O Flutter cria-o automaticamente; se for preciso
escrevê-lo à mão:

```properties
sdk.dir=C:\\Users\\<utilizador>\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\Users\\<utilizador>\\flutter
```

---

## Executar em desenvolvimento

```powershell
# Listar os alvos disponíveis
flutter devices

# Executar
flutter run

# Num alvo específico
flutter run -d chrome
flutter run -d windows

# Forçar um idioma, para testar as traduções
# (editar temporariamente `locale:` em lib/main.dart)
```

Em execução: `r` recarrega a quente, `R` reinicia, `q` termina.

---

## Executar os testes

```powershell
# Todos os 146 testes
flutter test

# Um ficheiro
flutter test test/power_converter_service_test.dart

# Com cobertura
flutter test --coverage
```

### O que cada ficheiro de teste cobre

| Ficheiro | Cobertura |
|---|---|
| `power_converter_service_test.dart` | As 4 famílias de conversão, limites, entradas inválidas, varredura de 539 casos |
| `dbw_conversion_test.dart` | A unidade `dBW`: âncoras, desvio de 30 dB, impedância, inversas |
| `number_formatting_test.dart` | Formatação de apresentação; garantia de que não altera o valor interno |
| `conversion_history_test.dart` | Serialização, dados corrompidos, limite, **persistência entre reinícios** |
| `localization_test.dart` | 5 idiomas; todos os códigos de erro traduzidos; símbolos invariáveis |
| `converter_screen_widget_test.dart` | Interface: arranque, entrada, inversão, diálogos, histórico, privacidade, tablet, francês em ecrã estreito |
| `version_consistency_test.dart` | A versão no ecrã de abertura coincide com o `pubspec.yaml` |

### A regra dos valores de referência

[`test/reference_values.dart`](test/reference_values.dart) **não importa nada
de `lib/`**. Se os testes usassem as funções de produção para calcular o valor
esperado, reproduziriam os seus erros e passariam sempre. Em vez disso usa:

1. **Âncoras exactas** por definição (`0 dBm = 1 mW`, `0 dBW = 1 W`);
2. **Formas fechadas de um só passo** que eliminam algebricamente a raiz
   quadrada: `L_dBV = 10·log₁₀(P·R)` em vez de `20·log₁₀(√(P·R))`.

Foi a segunda estratégia que detectou um defeito real de **18,7 dB** na
versão anterior do código. Ver
[`docs/AUDITORIA_INICIAL.md`](docs/AUDITORIA_INICIAL.md).

### Verificação numérica independente

```powershell
# Gera a tabela de exemplos verificados usada na documentação
dart run docs/evidence/gerar_exemplos.dart

# Demonstra o defeito da raiz quadrada corrigido na auditoria
dart docs/evidence/verificacao_sqrt.dart
```

---

## Compilar para Android

```powershell
# Depuração
flutter build apk --debug

# Lançamento, APK
flutter build apk --release

# Lançamento, App Bundle (o formato da Google Play)
flutter build appbundle --release
```

### Assinatura de lançamento

> **A chave de assinatura não está neste repositório e não deve nunca estar.**

Sem `android/key.properties`, a compilação de `release` **não falha**: usa a
chave de depuração e imprime um aviso de que o pacote não serve para
publicar. Para gerar um pacote publicável:

**1. Criar a chave** (acção irreversível — guardar com cópia de segurança; se
for perdida, a aplicação publicada nunca mais poderá ser actualizada):

```powershell
keytool -genkey -v -keystore $env:USERPROFILE\db-konversor-upload.jks `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**2. Criar `android/key.properties`** (já está no `.gitignore`):

```properties
storeFile=C:/Users/<utilizador>/db-konversor-upload.jks
storePassword=<password>
keyAlias=upload
keyPassword=<password>
```

**3. Compilar:**

```powershell
flutter build appbundle --release
```

O pacote fica em `build/app/outputs/bundle/release/app-release.aab`.

> Gerar um App Bundle **não** significa que a aplicação esteja pronta ou
> aprovada para publicação. Ver [Limitações conhecidas](#limitações-conhecidas).

---

## Traduções

Para alterar um texto, editar o ficheiro ARB do idioma — **nunca** o código
gerado em `lib/l10n/generated/`.

```powershell
# 1. Editar lib/l10n/app_pt.arb (modelo) e as traduções
# 2. Gerar
flutter gen-l10n

# 3. Confirmar que nada ficou por traduzir ({} = tudo traduzido)
Get-Content l10n_untranslated.json

# 4. Testar
flutter test test/localization_test.dart
```

Para **acrescentar um idioma**, o procedimento completo está em
[`docs/GUIA_LOCALIZACAO.md`](docs/GUIA_LOCALIZACAO.md), secção 4.

**Regra importante:** os símbolos técnicos (`dB`, `dBm`, `dBW`, `dBV`, `dBu`,
`W`, `mW`, `V`, `Ω`) **não se traduzem** em nenhum idioma. Há testes que o
verificam.

---

## Política de Privacidade

A aplicação **não recolhe dados pessoais**. O histórico de conversões é
guardado **apenas no dispositivo** e pode ser apagado pelo utilizador. A
versão de lançamento **não declara a permissão `android.permission.INTERNET`**,
pelo que o próprio Android impede qualquer transmissão de dados.

| Documento | Conteúdo |
|---|---|
| [`docs/privacy/POLITICA_PRIVACIDADE_PT.md`](docs/privacy/POLITICA_PRIVACIDADE_PT.md) | Política (pt) |
| [`docs/privacy/PRIVACY_POLICY_EN.md`](docs/privacy/PRIVACY_POLICY_EN.md) | Política (en) |
| [`docs/privacy/POLITIQUE_CONFIDENTIALITE_FR.md`](docs/privacy/POLITIQUE_CONFIDENTIALITE_FR.md) | Política (fr) |
| [`docs/privacy/POLITICA_PRIVACIDAD_ES.md`](docs/privacy/POLITICA_PRIVACIDAD_ES.md) | Política (es) |
| [`docs/privacy/PRIVACY_POLICY_ZH_CN.md`](docs/privacy/PRIVACY_POLICY_ZH_CN.md) | Política (zh) |
| [`docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`](docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md) | Auditoria técnica, com as evidências |
| [`docs/privacy/GUIA_DATA_SAFETY.md`](docs/privacy/GUIA_DATA_SAFETY.md) | Respostas preparadas para a Play Console |

A mesma política está **dentro da aplicação**, nos cinco idiomas, acessível
pelo menu lateral.

**A URL pública exigida pela Google Play ainda não existe** e não foi
inventada em nenhum documento.

---

## Documentação de auditoria

Em Outubro de 2026 o projecto passou por uma auditoria técnica completa. Os
documentos são parte do repositório, não anexos:

| Documento | Conteúdo |
|---|---|
| [`docs/AUDITORIA_INICIAL.md`](docs/AUDITORIA_INICIAL.md) | Estado inicial e defeitos encontrados, incluindo um erro matemático de 18,7 dB |
| [`docs/MATRIZ_CONVERSOES.md`](docs/MATRIZ_CONVERSOES.md) | As 49 conversões, fórmulas, limites e exemplos verificados |
| [`docs/RELATORIO_ALTERACOES.md`](docs/RELATORIO_ALTERACOES.md) | Cada alteração, com justificação técnica e testes associados |
| [`docs/GUIA_LOCALIZACAO.md`](docs/GUIA_LOCALIZACAO.md) | Arquitectura de tradução e como acrescentar idiomas |
| [`docs/RELATORIO_FINAL_AUDITORIA.md`](docs/RELATORIO_FINAL_AUDITORIA.md) | Relatório final, com o que ficou pendente |
| [`docs/evidence/`](docs/evidence/) | Scripts de verificação numérica e saídas registadas |
| [`docs/store/`](docs/store/) | Fichas da loja nos 5 idiomas, estratégia ASO, plano de capturas |
| [`docs/content/`](docs/content/) | 8 artigos técnicos com exemplos verificados |

---

## Contribuir

Ver [`CONTRIBUTING.md`](CONTRIBUTING.md).

Em resumo, para qualquer alteração que toque na matemática:

1. **Escrever primeiro o teste que falha**, com o valor esperado deduzido
   independentemente da implementação.
2. Corrigir.
3. `flutter analyze` e `flutter test` têm de passar.
4. Comentar **porque** a alteração foi necessária, não o que o código faz.

---

## Licença

**Ainda não definida.** Todos os direitos reservados à KUNDIAMA Tecnologia e
Inovação.

Não existe ficheiro `LICENSE` neste repositório. Até que o proprietário
escolha uma licença, **não é concedida** permissão de uso, modificação ou
redistribuição, e o projecto **não pode ser descrito como *open source***.

Decisão pendente registada em
[`docs/RELATORIO_FINAL_AUDITORIA.md`](docs/RELATORIO_FINAL_AUDITORIA.md).

---

## Contactos

**KUNDIAMA Tecnologia e Inovação**

- E-mail: diassilua.simao@gmail.com
- Telefone: 945560400 / 952142799 (Angola, +244)

São os mesmos contactos apresentados no ecrã de Ajuda da aplicação.

---

## Limitações conhecidas

Lista honesta do que **não** está feito. Nenhum destes pontos é um defeito
oculto.

### Acções externas pendentes

| # | Pendente | Depende de |
|---|---|---|
| 1 | **Chave de assinatura de lançamento** não existe | Proprietário (acção irreversível) |
| 2 | **URL pública da Política de Privacidade** não existe | Alojamento web |
| 3 | **Formulário *Data safety*** não submetido | Play Console |
| 4 | **Capturas de ecrã** não geradas | Emulador ou dispositivo Android |
| 5 | ***Feature graphic*** (1024 × 500) não criado | Design |
| 6 | **Licença** não escolhida | Decisão jurídica |
| 7 | **Projecto Firebase** `db-konversor` pode continuar activo | Consola do Firebase |

### Verificações que exigem dispositivo real

| Verificação | Porquê não foi feita |
|---|---|
| Execução em Android real | Não há emulador nem dispositivo neste ambiente de desenvolvimento |
| Persistência do histórico após reinício da aplicação | Verificada em teste automatizado, **não** em Android real |
| Acessibilidade com o TalkBack | Exige dispositivo |
| Caracteres chineses em dispositivos sem fontes CJK | Exige dispositivo |
| Comportamento em modo de voo | Confirmação empírica da ausência de rede |

### Limitações técnicas

| Limitação | Detalhe |
|---|---|
| Tradução chinesa | Completa, mas **sem revisão por falante nativo** |
| Separador decimal nos resultados | Sempre ponto, em todos os idiomas. Decisão deliberada, justificada na secção 9 de [`docs/GUIA_LOCALIZACAO.md`](docs/GUIA_LOCALIZACAO.md) |
| Redução de código (R8) | Desactivada de propósito; activá-la exige validação em dispositivo |
| Modelo físico | Assume carga **resistiva pura** e valores **eficazes (RMS)**. Cargas reactivas exigem o factor de potência |
| Plataformas além do Android | `ios/`, `web/`, `windows/`, `linux/`, `macos/` existem por omissão do Flutter, mas **não foram auditadas nem testadas** |
| Controlo de versões | O projecto **não estava** sob Git no momento da auditoria |

### O que já está verificado

| Verificação | Resultado | Data |
|---|---|---|
| `flutter analyze` | Sem problemas | 2026-10-17 |
| `flutter test` | 146 testes, todos aprovados | 2026-10-17 |
| `flutter build apk --debug` | Com êxito | 2026-10-17 |
| `flutter build appbundle --release` | Com êxito, 45,0 MB | 2026-10-17 |
| Permissões do pacote de lançamento | Nenhuma permissão de acesso a dados | 2026-10-17 |
| Chaves de tradução por traduzir | Zero, nos 5 idiomas | 2026-10-17 |
