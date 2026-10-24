# Política de Segurança

**Projecto:** dB Konversor
**Responsável:** KUNDIAMA Tecnologia e Inovação
**Última actualização:** 2026-10-17

---

## Versões suportadas

| Versão | Suporte |
|---|---|
| 1.0.0 (em preparação) | Em desenvolvimento activo |

A aplicação ainda não foi publicada na Google Play. Depois da publicação, o
suporte de segurança aplica-se à versão mais recente disponível na loja.

---

## Comunicar uma vulnerabilidade

**Não abra um *issue* público** para uma vulnerabilidade de segurança. Um
*issue* é visível a todos, incluindo a quem a pudesse explorar.

Comunique em privado:

- **E-mail:** diassilua.simao@gmail.com
- **Assunto:** `[SEGURANCA] dB Konversor — <resumo breve>`

### O que incluir

1. Descrição da vulnerabilidade e do seu impacto
2. Passos para a reproduzir
3. Versão da aplicação e do Android
4. Se aplicável, uma proposta de correcção

### O que esperar

| Prazo | Acção |
|---|---|
| 5 dias úteis | Confirmação de recepção |
| 15 dias úteis | Avaliação inicial e classificação de gravidade |
| Conforme a gravidade | Correcção e publicação de uma versão nova |

Pedimos que aguarde a correcção antes de divulgar publicamente. Se preferir,
o seu contributo será reconhecido nas notas da versão.

---

## Superfície de ataque desta aplicação

Uma avaliação honesta, baseada na auditoria de
[`docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md`](docs/privacy/RELATORIO_AUDITORIA_PRIVACIDADE.md).

### O que reduz o risco

| Característica | Consequência para a segurança |
|---|---|
| **Sem permissão de rede** na versão de lançamento | O Android impede qualquer comunicação. Não há superfície de ataque remota: nem servidor, nem API, nem canal de dados |
| **Sem autenticação nem contas** | Não há credenciais para roubar, nem sessões para sequestrar |
| **Sem SDKs de terceiros** | Um único plugin nativo (`shared_preferences_android`). Nenhum código de publicidade, análise ou rastreio |
| **Sem entrada de dados externos** | A aplicação não lê ficheiros, não recebe *intents* com dados, não processa URLs nem códigos QR |
| **Dados locais sem informação pessoal** | O histórico contém números e símbolos de unidades |

### O que permanece como risco

| Risco | Avaliação |
|---|---|
| **Acesso físico ao dispositivo** | Quem tenha o dispositivo desbloqueado vê o histórico de conversões. O conteúdo não é sensível (números e unidades), mas é informação do utilizador |
| **Dispositivo desbloqueado (*root*)** | O isolamento de aplicações do Android pode ser contornado com privilégios elevados. Aplica-se a qualquer aplicação |
| **Cadeia de fornecimento** | A aplicação depende do Flutter e de `shared_preferences`. Um comprometimento dessas dependências afectaria a aplicação |
| **Distribuição fora da Google Play** | Um APK obtido de outra origem pode ter sido modificado. Instale apenas pela Google Play |
| **Chave de assinatura** | Se a chave de assinatura for comprometida, terceiros podem assinar pacotes em nome da KUNDIAMA. Ver abaixo |

---

## Gestão da chave de assinatura

A chave de assinatura é o activo de segurança mais importante deste projecto,
por duas razões: **se for comprometida**, terceiros podem distribuir pacotes
que o Android aceita como legítimos; **se for perdida**, a aplicação publicada
nunca mais pode ser actualizada.

### Regras em vigor

- `android/key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.pem` e `*.pepk`
  estão no [`.gitignore`](.gitignore), numa secção com um aviso explícito de
  que **nunca deve ser removida**.
- Estas regras foram postas em vigor **antes** de existir qualquer chave, para
  que não houvesse uma janela em que uma chave pudesse ser confirmada por
  engano.
- A configuração de assinatura em `android/app/build.gradle.kts` **lê** o
  ficheiro de propriedades; não contém nenhuma password.

### Recomendações ao proprietário

- Guardar a chave e as passwords num gestor de segredos, com cópia de
  segurança em local separado do computador de desenvolvimento.
- Considerar o *Play App Signing*, em que a Google guarda a chave de assinatura
  da aplicação e o desenvolvedor usa uma chave de carregamento substituível.
  Isto mitiga o risco de perda definitiva.
- Nunca enviar a chave por e-mail nem por aplicações de mensagens.

---

## Se encontrar um segredo no repositório

Se encontrar uma credencial confirmada no histórico — uma chave de API, uma
password, um *keystore*:

1. **Não a publique** no *issue* nem em nenhum canal público.
2. Comunique em privado, pelo endereço acima.
3. O procedimento correcto é, nesta ordem:
   - **revogar ou rotar** a credencial no serviço de origem — este passo é o
     que de facto resolve o problema;
   - remover o ficheiro do repositório e reforçar o `.gitignore`;
   - só depois, se necessário, reescrever o histórico.

> **Porque a rotação vem primeiro.** Remover um ficheiro do histórico do Git
> **não** torna a credencial segura: pode já ter sido copiada, indexada ou
> estar em *forks* e caches. A única medida eficaz é invalidar a credencial no
> serviço que a emitiu.

### Incidente conhecido e já tratado

A auditoria de Outubro de 2026 encontrou `firebase.json` e
`android/app/google-services.json` no directório do projecto, contendo
identificadores do projecto Firebase e uma **chave de API**.

| Aspecto | Estado |
|---|---|
| Exposição em repositório público | **Não ocorreu** — o projecto não estava sob controlo de versões, pelo que os ficheiros nunca foram confirmados nem publicados |
| Recolha de dados por essa via | **Não ocorreu** — o plugin Gradle do Google Services não estava aplicado e nenhum pacote Firebase constava do `pubspec.lock`. Os ficheiros estavam inertes em tempo de execução |
| Ficheiros | **Removidos** |
| Prevenção | **Regras acrescentadas ao `.gitignore`** |
| Rotação da credencial | **PENDENTE** — acção do proprietário na consola do Firebase |

**Recomendação que continua em aberto:** eliminar ou desactivar o projecto
Firebase `db-konversor`, que já não é usado por esta aplicação. Enquanto o
projecto existir, a chave que esteve nesse ficheiro deve ser considerada
potencialmente conhecida.

O valor da chave **não** é reproduzido em nenhum documento desta auditoria.

---

## Privacidade e segurança dos dados

A aplicação guarda um único tipo de dado: o histórico de conversões, no
armazenamento privado da aplicação.

| Aspecto | Estado |
|---|---|
| Encriptação acrescentada pela aplicação | **Nenhuma** |
| Encriptação do sistema | O Android encripta o armazenamento do dispositivo por omissão nas versões recentes |
| Isolamento | O Android impede o acesso por outras aplicações |
| Transmissão | **Nenhuma** — não há permissão de rede |

> **Declaração honesta:** não afirmamos que a aplicação encripta os dados.
> Afirmamos que o Android encripta o armazenamento e isola as aplicações. São
> garantias do **sistema operativo**, não funcionalidades que tenhamos
> implementado. Atribuir a nós uma encriptação inexistente seria uma
> declaração falsa.

Como o histórico contém apenas números e símbolos de unidades, o impacto de um
acesso indevido é baixo. Ainda assim, o utilizador pode apagá-lo em qualquer
momento na aplicação.

---

## O que esta política não cobre

- **Vulnerabilidades do Flutter ou do Dart.** Comunique-as ao projecto Flutter.
- **Vulnerabilidades do Android.** Comunique-as à Google.
- **Vulnerabilidades do `shared_preferences`.** Comunique-as ao repositório
  desse pacote. Informe-nos também, para que possamos avaliar o impacto.
- **Erros de cálculo.** São defeitos de correcção, não de segurança: abra um
  *issue* público com o modelo apropriado. Um resultado errado é grave para
  este produto, mas não é uma vulnerabilidade.
