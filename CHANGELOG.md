# Registo de alterações

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/).
Versões segundo [SemVer](https://semver.org/lang/pt-BR/).

> **Nota sobre o histórico.** O projecto **não estava sob controlo de versões**
> no momento da auditoria de Outubro de 2026, pelo que não existe histórico de
> commits anterior a esta data. As entradas abaixo foram reconstruídas a partir
> da inspecção do código e estão documentadas em
> [`docs/RELATORIO_ALTERACOES.md`](docs/RELATORIO_ALTERACOES.md).

---

## [Não publicado] — auditoria técnica de 2026-10-17

Auditoria completa: correcção matemática, internacionalização, privacidade e
preparação para publicação. **Nenhuma versão foi publicada na Google Play.**

### Corrigido

- **CRÍTICO — raiz quadrada divergente (M1).** A conversão de potência para
  nível de tensão usava uma raiz quadrada escrita à mão (Newton–Raphson com 20
  iterações fixas), que divergia em potências baixas. Erro medido em 50 Ω:
  0,010 dB a −90 dBm, **1,671 dB** a −100 dBm, **9,005 dB** a −110 dBm,
  **18,659 dB** a −120 dBm e **28,623 dB** a −130 dBm. A gama afectada é a da
  sensibilidade de receptores, o caso de uso mais comum do público-alvo.
  Substituída por `dart:math.sqrt`. Evidência reproduzível em
  [`docs/evidence/`](docs/evidence/).
- **BLOQUEADOR — `MainActivity.kt` continha um script PowerShell (B1).** O
  script de migração do pacote tinha sido gravado sobre o seu próprio destino,
  pelo que a classe declarada no manifesto não existia e **a compilação Android
  falhava**. Reescrito em Kotlin.
- **BLOQUEADOR — assinatura de lançamento (B2).** A variante `release` usava a
  chave de **depuração**, o que leva à rejeição pela Google Play. Passou a ler
  a configuração de `android/key.properties` (fora do controlo de versões),
  degradando com aviso explícito quando o ficheiro não existe.
- **Nome da aplicação (B3).** `android:label` era `db_konversor`, o nome
  técnico do projecto, que apareceria assim no dispositivo. Corrigido para
  `dB Konversor`.
- **Mensagens de erro referiam a unidade interna (M3).** Converter `0 W → dBm`
  dizia «O valor em **mW** deve ser maior que zero» — uma unidade que o
  utilizador nunca introduziu, porque mW é só o pivô interno de cálculo. As
  mensagens passaram a nomear a unidade escolhida.
- **Fórmula apresentada estava incompleta (M4).** `W → dBm` mostrava apenas
  `dBm = 10 × log10(mW)`, escondendo o passo `mW = W × 1000`. Passa a mostrar
  a cadeia completa de passos.
- **Dois formatadores numéricos divergentes (M6).** Existiam duas
  implementações com limiares diferentes e nenhum teste; a usada pela
  interface não limpava a mantissa em notação científica (`1.0000e-9`).
  Unificadas numa só, com 14 testes.
- **Histórico fabricado (F1, M7).** O painel de histórico mostrava a conversão
  corrente e **duas entradas fixas escritas no código**, com datas inventadas
  (`21/04/2026`) e uma delas **matematicamente errada**
  (`0.775 dBu → 0.614 dBV`, quando o valor correcto é −1,452 dBV). Substituído
  por histórico real e persistido.
- **Dupla invocação do cálculo (F6).** Cada mudança de unidade calculava e
  notificava duas vezes.
- **Linguagem de protótipo nos textos (M5).** Textos visíveis referiam «MVP»,
  e a descrição do `dB` estava desactualizada.

### Adicionado

- **Unidade `dBW`** (potência referenciada a 1 W; `dBm = dBW + 30`), com
  conversões para `W`, `mW`, `dBm`, `dBV`, `dBu` e `dB`, e **24 testes**
  próprios. O conversor passa de 6 para 7 unidades e de 36 para 49
  combinações.
- **Internacionalização completa** em português, inglês, francês, espanhol e
  chinês simplificado, com o sistema oficial do Flutter (ARB). **103 chaves**
  por idioma, zero por traduzir.
- **Histórico de conversões real e persistente:** últimas 50 conversões,
  guardadas no dispositivo com `shared_preferences`, com data e opção de
  limpar (com confirmação). Nada sai do dispositivo.
- **Página de Política de Privacidade dentro da aplicação** (bloqueador B4),
  nos cinco idiomas, acessível pelo menu lateral e consultável sem ligação à
  Internet.
- **146 testes automatizados**, onde antes não havia nenhum. Os valores de
  referência são deduzidos **independentemente** da implementação testada —
  por âncoras exactas de definição e por formas fechadas de um só passo que
  eliminam a raiz quadrada.
- **Códigos de erro traduzíveis** (`ConversionError`): a camada de cálculo
  deixou de conter texto para o utilizador. O `switch` de tradução não tem
  `default`, pelo que o analisador impede que um erro novo chegue sem
  tradução.
- **Acessibilidade:** descrições (`tooltip`) nos quatro botões só com ícone, e
  rótulo semântico no campo de resultado.
- **Robustez de layout** para textos traduzidos mais longos, verificada em
  telemóvel de 320 dp, tablet de 10", orientação horizontal, francês em ecrã
  estreito e ampliação de texto a 1,5×.
- **Documentação:** auditoria inicial, matriz das 49 conversões, relatório de
  alterações, guia de localização, auditoria de privacidade, políticas de
  privacidade nos 5 idiomas, guia da declaração *Data safety*, fichas da loja
  nos 5 idiomas, estratégia ASO, plano e script de capturas de ecrã, 8 artigos
  técnicos com exemplos verificados, plano editorial, README, guia de
  contribuição e política de segurança.

### Alterado

- `.gitignore` reforçado com uma secção dedicada a segredos:
  `key.properties`, `*.jks`, `*.keystore`, `local.properties`,
  `google-services.json`, `firebase.json` e credenciais de serviços. **Posto
  em vigor antes de existir qualquer chave de assinatura.**
- Formatação de apresentação: valores ≥ 10⁶ passam a usar notação científica.
- `analysis_options.yaml` exclui `docs/`, que contém scripts de demonstração
  numérica destinados a imprimir no terminal.
- Redução de código (R8) explicitamente desactivada, com justificação:
  activá-la sem validação em dispositivo é um risco desnecessário, porque um
  erro de regras R8 só se manifesta em execução na versão de lançamento.

### Removido

- **Artefactos do Firebase:** `firebase.json` e
  `android/app/google-services.json`. Confirmado que estavam **inertes** — o
  plugin Gradle não estava aplicado e nenhum pacote Firebase constava do
  `pubspec.lock`, pelo que não havia recolha de dados por esta via. O risco
  era de **exposição da chave de API** ao publicar o repositório.
- **Código morto (F3):** `lib/app/app.dart` (que declarava um **segundo**
  `DbKonversorApp`), `lib/app/app_theme.dart`, `lib/app/app_colors.dart` (tema
  claro, incompatível com a interface escura real),
  `lib/core/constants/app_strings.dart` e cinco widgets não utilizados em
  `lib/features/widgets/`.
- **Resíduos de edição:** `lib/main.dart.bak`, `pubspec.yaml.bak`.

### Segurança

- A versão de lançamento **não declara `android.permission.INTERNET`**,
  verificado no manifesto fundido do pacote. Sem essa permissão, o Android
  impede qualquer transmissão de dados.
- Auditoria completa das dependências, incluindo transitivas: **um único
  plugin nativo** (`shared_preferences_android`). Nenhum SDK de publicidade,
  análise, rastreio ou relato de erros.

### Pendente (acções externas)

Não executadas por esta auditoria, por exigirem acesso ou decisão do
proprietário:

1. Gerar a chave de assinatura de lançamento (acção irreversível)
2. Publicar a Política de Privacidade numa URL pública
3. Submeter a declaração *Data safety* na Play Console
4. Gerar as capturas de ecrã (não há emulador nem dispositivo disponível)
5. Criar o *feature graphic* de 1024 × 500
6. Escolher a licença do projecto
7. Inicializar o repositório Git
8. Eliminar ou desactivar o projecto Firebase `db-konversor`
9. Revisão da tradução chinesa por falante nativo
10. Testar com o TalkBack num dispositivo real

Lista completa, com dependências, em
[`docs/RELATORIO_FINAL_AUDITORIA.md`](docs/RELATORIO_FINAL_AUDITORIA.md).

---

## [1.0.0] — estado anterior à auditoria

Versão de desenvolvimento, **nunca publicada**. Registada aqui para que o
ponto de partida fique documentado.

### Existia

- Conversor com 6 unidades (`W`, `mW`, `dB`, `dBm`, `dBu`, `dBV`)
- Ecrã de abertura com animações e logótipo
- Campo de impedância e campo de referência contextuais
- Diálogo de fórmula e diálogo de ajuda
- Menu lateral de consulta de unidades
- Identificador `ao.kundiama.dbkonversor` e ícone configurado

### Não existia

- Testes automatizados
- Internacionalização
- Política de Privacidade
- Histórico real (era fabricado)
- Unidade `dBW`
- Capacidade de compilar para Android (ver B1)
- Configuração de assinatura válida (ver B2)
