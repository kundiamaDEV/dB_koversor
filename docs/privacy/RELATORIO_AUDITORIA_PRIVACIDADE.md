# Relatório de Auditoria de Privacidade — dB Konversor

**Aplicação:** dB Konversor
**Identificador Android:** `ao.kundiama.dbkonversor`
**Versão auditada:** 1.0.0 (versionCode 1)
**Responsável:** KUNDIAMA Tecnologia e Inovação
**Data da auditoria:** 2026-10-17
**Auditor:** auditoria técnica ao código-fonte e ao pacote compilado

---

## 1. Âmbito e método

Esta auditoria não se baseia em declarações nem em pressupostos sobre o que a
aplicação faz. Baseia-se na inspecção de:

| Fonte inspeccionada | Para determinar |
|---|---|
| `pubspec.yaml` e `pubspec.lock` | Dependências directas e **transitivas** |
| `.flutter-plugins-dependencies` | Que plugins têm código nativo Android |
| `GeneratedPluginRegistrant.java` | Que plugins são efectivamente registados no arranque |
| Todo o código Dart em `lib/` | Chamadas de rede, acesso a ficheiros, recolha de dados |
| `android/app/src/main/AndroidManifest.xml` | Permissões declaradas na origem |
| **Manifesto fundido da variante `release`** | Permissões que realmente entram no pacote publicado |
| `android/app/build.gradle.kts` | Plugins Gradle (ex.: Google Services) |
| Ficheiros de configuração na raiz | Artefactos de serviços externos |

> **Princípio aplicado:** não se conclui que a aplicação não recolhe dados só
> porque `firebase_core` foi removido do `pubspec.yaml`. Um SDK pode continuar
> presente por via transitiva, por código nativo ou por um plugin Gradle. Cada
> uma dessas vias foi verificada separadamente.

---

## 2. Resultado da auditoria

### 2.1 Dependências directas

| Pacote | Função | Recolhe dados? | Acede à rede? |
|---|---|---|---|
| `flutter` (SDK) | Framework | Não | Não |
| `flutter_localizations` (SDK) | Traduções dos widgets do sistema | Não | Não |
| `cupertino_icons` | Tipo de letra de ícones | Não | Não |
| `intl` | Formatação sensível ao idioma | Não | Não |
| `shared_preferences` | Armazenamento local de preferências | Não — **escreve apenas no dispositivo** | Não |

Em `dev_dependencies` (não entram no pacote publicado): `flutter_test`,
`flutter_lints`, `flutter_launcher_icons`.

### 2.2 Dependências transitivas relevantes

A lista completa do `pubspec.lock` tem 57 pacotes. Foram examinados todos;
os que merecem nota:

| Pacote transitivo | Origem | Avaliação |
|---|---|---|
| `shared_preferences_android` | `shared_preferences` | **É o único plugin com código nativo Android.** Implementa o armazenamento local. Não comunica com a rede. |
| `shared_preferences_foundation`, `_linux`, `_web`, `_windows` | `shared_preferences` | Implementações de **outras plataformas**. Não são compiladas para o pacote Android. |
| `path_provider_linux`, `path_provider_windows`, `path_provider_platform_interface` | `shared_preferences_linux/_windows` | Idem: só para ambiente de secretária. |
| `xdg_directories`, `posix`, `ffi` | `path_provider_linux` | Idem. |
| `archive`, `image`, `xml`, `yaml`, `petitparser`, `json_annotation`, `checked_yaml`, `cli_util`, `args` | `flutter_launcher_icons` (**dev**) | Ferramenta de geração de ícones, executada na máquina de desenvolvimento. **Não entra no pacote.** |
| `leak_tracker*`, `fake_async`, `test_api`, `matcher`, `vm_service` | `flutter_test` (**dev**) | Infra-estrutura de testes. Não entra no pacote. |

**Nenhum SDK de publicidade, análise de utilização, rastreio, notificações
push, telemetria ou relato de erros foi encontrado.**

### 2.3 Plugins nativos registados

Conteúdo efectivo de `GeneratedPluginRegistrant.java` (gerado pelo Flutter a
partir dos plugins instalados):

```java
flutterEngine.getPlugins().add(
    new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
```

**Um único plugin nativo.** No estado inicial da auditoria este ficheiro estava
vazio; passou a registar o `SharedPreferencesPlugin` por causa do histórico
local introduzido nesta auditoria. Nenhum outro código nativo é carregado.

### 2.4 Firebase — estado verificado

| Verificação | Resultado |
|---|---|
| `firebase_core` em `pubspec.yaml` | **Ausente** |
| Qualquer pacote `firebase_*` em `pubspec.lock` | **Ausente** |
| Plugin Gradle `com.google.gms.google-services` | **Não aplicado** em nenhum ficheiro Gradle |
| `lib/firebase_options.dart` | **Não existe** |
| Chamadas a `Firebase.initializeApp` em `lib/` | **Nenhuma** |
| `firebase.json` na raiz | Existia — **removido nesta auditoria** |
| `android/app/google-services.json` | Existia — **removido nesta auditoria** |

**Conclusão:** o Firebase **não estava activo** em tempo de execução. Os dois
ficheiros de configuração que permaneciam eram inertes — sem o plugin Gradle
aplicado e sem SDK instalado, nunca eram lidos. Não houve, por esta via,
recolha nem transmissão de dados.

**Contudo**, esses ficheiros continham identificadores do projecto
(`project_id`, `project_number`, `mobilesdk_app_id`, `storage_bucket`) e uma
**chave de API**. O risco era de **exposição da credencial** ao publicar o
repositório no GitHub, e não de recolha de dados. Foram removidos e o
`.gitignore` foi reforçado para impedir que voltem.

> **Acção recomendada ao proprietário (não executada, é externa):** o projecto
> Firebase `db-konversor` já não é usado por esta aplicação. Recomenda-se
> eliminá-lo ou desactivá-lo na consola do Firebase, o que torna a chave
> exposta irrelevante. Enquanto o projecto existir, a chave que esteve nesse
> ficheiro deve ser considerada potencialmente conhecida.

### 2.5 Acesso à rede — evidência decisiva

Foram verificadas três coisas independentes.

**(a) Nenhuma chamada de rede no código Dart.** Não há `HttpClient`, `http`,
`dio`, `WebSocket`, `Socket` nem `fetch` em `lib/`. A aplicação não importa
`dart:io` para rede nem nenhum pacote de rede.

**(b) A permissão de Internet não está no manifesto de origem.** Existe apenas
em `android/app/src/debug/AndroidManifest.xml` e
`android/app/src/profile/AndroidManifest.xml` — variantes que **não** entram no
pacote publicado. O Flutter inclui-a nessas variantes para permitir a
recarga a quente durante o desenvolvimento.

**(c) Confirmação no manifesto fundido do pacote de lançamento.** Esta é a
prova que conta, porque é o que a Google Play recebe. Lido de
`build/app/intermediates/packaged_manifests/release/processReleaseManifestForPackage/AndroidManifest.xml`
após `flutter build appbundle --release`:

| Variante | Permissões declaradas |
|---|---|
| **`release` (publicada)** | `ao.kundiama.dbkonversor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` |
| `debug` (desenvolvimento) | `android.permission.INTERNET` **+** `ao.kundiama.dbkonversor.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` |

A única permissão na versão publicada é
`DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. É uma permissão **auto-definida**,
gerada automaticamente pelas bibliotecas AndroidX, de nível de assinatura, que
serve para garantir que receptores de transmissão internos não ficam expostos a
outras aplicações. **Não dá acesso a dados do utilizador, à rede nem a
hardware.** É uma medida de segurança, não de recolha.

**Consequência técnica:** sem `android.permission.INTERNET`, o sistema Android
**bloqueia** qualquer tentativa de abrir uma conexão de rede. A aplicação
publicada é, por construção do sistema operativo, incapaz de transmitir dados.

---

## 3. Classificação dos dados

### 3.1 Dados que a aplicação recolhe directamente

**Nenhum.** A aplicação não pede, não gera e não transmite nenhum dado
pessoal. Não há conta de utilizador, autenticação, formulário, nem
identificador de dispositivo ou de publicidade.

### 3.2 Dados transmitidos a terceiros

**Nenhum,** por três razões cumulativas: não existem SDKs de terceiros que
recolham dados; não existe código de rede; e a versão publicada não tem
permissão de acesso à rede.

**Ressalva que deve constar da política:** a **distribuição** pela Google Play
implica que a Google recolha os seus próprios dados de instalação e de
dispositivo, segundo as políticas da Google. Isso é inerente à loja e está
fora do controlo da KUNDIAMA. Não é recolha feita pela aplicação, mas seria
desonesto dizer ao utilizador que «absolutamente nenhum dado é recolhido por
ninguém».

### 3.3 Dados guardados apenas no dispositivo

Uma única categoria:

| Dado | Conteúdo | Onde | Quando |
|---|---|---|---|
| Histórico de conversões | Valor introduzido, símbolo da unidade de entrada, resultado, símbolo da unidade de saída, data e hora em UTC | Armazenamento privado da aplicação, via `SharedPreferences` (chave `conversion_history_v1`) | A cada conversão bem-sucedida |

Características verificadas no código
(`lib/features/history/conversion_history_store.dart`):

- Limitado a **50 entradas**; as mais antigas são descartadas.
- Gravado num ficheiro XML privado da aplicação, na área de dados privados do
  Android. Noutras aplicações, **não é legível**: o Android isola o
  armazenamento por aplicação.
- **Não é enviado para nenhum sítio** — não há código que o leia para
  transmissão.
- **Apagável pelo utilizador** em qualquer momento, no painel de histórico,
  com confirmação.
- **Eliminado pela desinstalação** da aplicação, como todos os dados privados.

**Nota de interpretação para a declaração *Data safety*:** estes dados **não
são «recolhidos»** no sentido da Google Play. A Google define recolha como a
transmissão de dados do dispositivo para fora dele. Dados que ficam no
dispositivo e nunca são transmitidos **não** se declaram como recolhidos. Ver
[`GUIA_DATA_SAFETY.md`](GUIA_DATA_SAFETY.md).

### 3.4 Permissões e respectiva finalidade

| Permissão | Variante | Finalidade | Dados a que dá acesso |
|---|---|---|---|
| `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION` | release e debug | Auto-protecção de receptores internos do AndroidX | Nenhum |
| `android.permission.INTERNET` | **apenas debug/profile** | Recarga a quente e depuração durante o desenvolvimento | Não aplicável ao pacote publicado |

A aplicação **não** pede: localização, câmara, microfone, contactos,
armazenamento externo, telefone, SMS, calendário, sensores corporais,
identificador de publicidade, nem notificações.

### 3.5 Serviços externos encontrados

| Serviço | Estado |
|---|---|
| Firebase | Removido; estava inerte. Ver 2.4 |
| Google Analytics / Firebase Analytics | Não encontrado |
| Crashlytics ou outro relato de erros | Não encontrado |
| AdMob ou qualquer rede de publicidade | Não encontrado |
| Notificações push | Não encontrado |
| Compras na aplicação | Não encontrado |
| Autenticação de terceiros | Não encontrado |
| Mapas, pagamentos, redes sociais | Não encontrado |

---

## 4. Incertezas e limites desta auditoria

Honestidade sobre o que **não** foi possível verificar:

| Incerteza | Porquê | Como resolver |
|---|---|---|
| Comportamento em execução num dispositivo Android real | **Não há emulador nem dispositivo disponível** neste ambiente (`flutter emulators` → «No emulators available») | Executar em dispositivo com o modo de voo activo e confirmar que tudo funciona; inspeccionar o tráfego de rede com as ferramentas do Android Studio |
| Conteúdo exacto do `.aab` final (APK fundido) | O pacote foi gerado, mas não foi descompilado para inspecção byte a byte | `bundletool` para extrair APKs e inspeccionar o manifesto final e as bibliotecas nativas incluídas |
| Dados recolhidos pela própria Google Play | Fora do controlo e da visibilidade do projecto | Declarar a ressalva na política, como foi feito |
| Comportamento de versões futuras | Esta auditoria descreve a versão 1.0.0 | Reauditar a cada alteração de dependências; a política tem de ser actualizada ao mesmo tempo |
| Bibliotecas nativas do próprio motor Flutter | Não foram auditadas linha a linha; é o motor do framework | Confiança na plataforma, como em qualquer projecto Flutter; o motor não recolhe dados de utilizador por omissão |

---

## 5. Conclusão

Para a versão 1.0.0, com base nas evidências acima:

1. A aplicação **não recolhe** dados pessoais.
2. A aplicação **não transmite** dados para fora do dispositivo, e a versão
   publicada **não tem permissão técnica** para o fazer.
3. A aplicação **guarda** um histórico de conversões **exclusivamente no
   dispositivo**, apagável pelo utilizador.
4. **Não existem** SDKs de terceiros que recolham dados.
5. O Firebase **não estava activo**; os seus ficheiros residuais foram
   removidos e o risco era de exposição de credencial, não de recolha.
6. A afirmação «funciona totalmente offline» é **tecnicamente sustentável**
   para a versão de lançamento, com a ressalva de que a confirmação empírica
   num dispositivo real está pendente (secção 4).

Estas conclusões sustentam o texto da Política de Privacidade e as respostas
preparadas para a declaração *Data safety*. Se qualquer dependência for
acrescentada no futuro — em especial uma que peça `android.permission.INTERNET`
— **esta auditoria, a política e a declaração têm de ser revistas em
conjunto**.

---

## 6. Documentos relacionados

| Documento | Conteúdo |
|---|---|
| [`POLITICA_PRIVACIDADE_PT.md`](POLITICA_PRIVACIDADE_PT.md) | Política em português |
| [`PRIVACY_POLICY_EN.md`](PRIVACY_POLICY_EN.md) | Política em inglês |
| [`POLITIQUE_CONFIDENTIALITE_FR.md`](POLITIQUE_CONFIDENTIALITE_FR.md) | Política em francês |
| [`POLITICA_PRIVACIDAD_ES.md`](POLITICA_PRIVACIDAD_ES.md) | Política em espanhol |
| [`PRIVACY_POLICY_ZH_CN.md`](PRIVACY_POLICY_ZH_CN.md) | Política em chinês simplificado |
| [`GUIA_DATA_SAFETY.md`](GUIA_DATA_SAFETY.md) | Respostas a introduzir na Play Console |
| [`../AUDITORIA_INICIAL.md`](../AUDITORIA_INICIAL.md) | Estado inicial, defeitos P1 a P3 |
| [`../RELATORIO_ALTERACOES.md`](../RELATORIO_ALTERACOES.md) | O que foi alterado |

A mesma política está **dentro da aplicação**, em
`lib/features/privacy/privacy_policy_screen.dart`, traduzida nos cinco idiomas
através dos ficheiros ARB. O texto da aplicação e o destes documentos têm de
ser mantidos coerentes.
