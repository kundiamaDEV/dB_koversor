# Guia da declaração *Data safety* — Google Play

**Aplicação:** dB Konversor (`ao.kundiama.dbkonversor`)
**Versão a que se refere:** 1.0.0 (versionCode 1)
**Data:** 2026-10-17
**Base factual:** [`RELATORIO_AUDITORIA_PRIVACIDADE.md`](RELATORIO_AUDITORIA_PRIVACIDADE.md)

---

> ## ESTADO: RESPOSTAS PREPARADAS, FORMULÁRIO NÃO SUBMETIDO
>
> Este documento contém as respostas a introduzir no formulário *Data safety*
> da Google Play Console. **O formulário NÃO foi preenchido nem submetido**, e
> não foi aprovado por ninguém. Preencher o formulário exige acesso à Play
> Console, que é uma acção externa do proprietário.
>
> As respostas abaixo são verdadeiras para a versão auditada. Se a aplicação
> mudar, têm de ser revistas antes de serem submetidas.

---

## 1. Conceito que determina todas as respostas

A Google Play define dois termos de forma muito precisa, e é essencial não os
confundir:

| Termo da Google | Definição | Aplica-se ao dB Konversor? |
|---|---|---|
| **Collected** (recolhido) | Dados **transmitidos para fora do dispositivo** | **NÃO** |
| **Shared** (partilhado) | Dados transmitidos a **terceiros** | **NÃO** |

**Consequência decisiva:** o histórico de conversões é guardado no
dispositivo, mas **nunca é transmitido**. Pela definição da Google, **não é
«recolhido»**. Por isso a resposta à primeira pergunta do formulário é *No*.

A documentação da Google é explícita neste ponto: dados processados
exclusivamente no dispositivo, que não saem dele, não se declaram como
recolhidos.

> **Atenção ao erro mais comum:** declarar o histórico como «recolhido» por
> excesso de zelo não é a opção segura — é uma declaração **incorrecta**, que
> cria uma etiqueta de privacidade enganosa na ficha da loja e obriga a
> responder a perguntas de finalidade e de partilha que não se aplicam.

---

## 2. Respostas ao formulário

### Secção: *Data collection and security*

| Pergunta | Resposta | Fundamento |
|---|---|---|
| Does your app collect or share any of the required user data types? | **No** | Nenhum dado é transmitido para fora do dispositivo. A versão publicada **não tem** `android.permission.INTERNET`, pelo que o Android bloqueia qualquer transmissão. Evidência: manifesto fundido da variante `release`. |

Ao responder *No*, o formulário **não** apresenta as secções seguintes sobre
tipos de dados, finalidades e partilha. As respostas abaixo ficam preparadas
para o caso de a Google pedir esclarecimentos ou de uma versão futura passar a
transmitir dados.

### Se fosse necessário detalhar (não é, nesta versão)

| Tipo de dados | Recolhido | Partilhado | Observação |
|---|---|---|---|
| Localização | Não | Não | Nenhuma permissão de localização |
| Informação pessoal (nome, e-mail, ID) | Não | Não | A aplicação não pede nada |
| Informação financeira | Não | Não | Sem compras nem pagamentos |
| Saúde e fitness | Não | Não | — |
| Mensagens | Não | Não | — |
| Fotografias e vídeos | Não | Não | Sem acesso a multimédia |
| Ficheiros áudio | Não | Não | Sem microfone |
| Ficheiros e documentos | Não | Não | Sem acesso a armazenamento externo |
| Calendário | Não | Não | — |
| Contactos | Não | Não | — |
| Actividade na aplicação (interacções, pesquisas) | Não | Não | **O histórico de conversões fica no dispositivo e nunca é transmitido** |
| Navegação na Web | Não | Não | Sem navegador nem rede |
| Identificadores do dispositivo | Não | Não | Sem ID de publicidade |
| Diagnóstico, registos de falhas, desempenho | Não | Não | **Sem Crashlytics nem qualquer ferramenta de relato de erros** |

### Secção: *Security practices*

| Pergunta | Resposta | Fundamento |
|---|---|---|
| Is all of the user data collected by your app encrypted in transit? | **Not applicable** (ou deixar sem resposta se o formulário o permitir, dado que nada é recolhido) | Não há dados em trânsito, porque não há trânsito. Declarar «encriptado em trânsito» seria afirmar a existência de uma transmissão que não existe. |
| Do you provide a way for users to request that their data be deleted? | **Yes** | O utilizador apaga o histórico dentro da aplicação (histórico → *Limpar*, com confirmação) e a desinstalação elimina tudo. Não há dados do nosso lado para pedir que sejam apagados. |
| Has your app been independently validated against a global security standard? | **No** | Não foi submetida a nenhuma certificação externa (ex.: MASVS). Responder *Yes* sem certificação seria falso. |

### Secção: *Privacy policy*

| Campo | Valor |
|---|---|
| Privacy policy URL | **PENDENTE — ver secção 4.** A URL ainda não existe e não pode ser inventada. |

### Secção: *Data types — ads*

| Pergunta | Resposta |
|---|---|
| Does your app contain ads? | **No** |
| Is your app primarily directed at children under 13? | **No** — é uma ferramenta técnica para estudantes, professores e profissionais; não é dirigida principalmente a crianças |

---

## 3. Dados que a aplicação guarda localmente (para referência interna)

Esta tabela **não** se declara à Google como recolha, pelos motivos da secção
1, mas a sua existência está descrita na Política de Privacidade, porque o
utilizador tem direito a saber o que a aplicação guarda.

| Dado | Finalidade | Localização | Encriptação | Eliminação |
|---|---|---|---|---|
| Valor de entrada, unidades, resultado, data/hora | Permitir ao utilizador consultar as conversões recentes | `SharedPreferences`, área privada da aplicação (chave `conversion_history_v1`) | Ao nível do sistema: Android encripta o armazenamento do dispositivo por omissão desde a versão 10. A aplicação **não** acrescenta encriptação própria. | Pelo utilizador, em qualquer momento, na aplicação; ou por desinstalação |

**Sobre a encriptação, com rigor:** não se declara que a aplicação encripta os
dados. O que é verdade é que o Android encripta o armazenamento do dispositivo
por omissão nas versões recentes, e que o isolamento por aplicação impede o
acesso por outras aplicações. Essas são garantias do **sistema operativo**, e
não uma funcionalidade implementada por nós. Atribuir a nós uma encriptação
que não implementámos seria uma declaração incorrecta.

---

## 4. Passos externos que faltam (acções do proprietário)

Nenhum destes passos foi executado por esta auditoria.

### 4.1 Publicar a Política de Privacidade numa URL pública

A Google Play **exige** uma URL acessível publicamente, sem autenticação, que
apresente a política. Opções, da mais simples à mais trabalhosa:

| Opção | Como | Nota |
|---|---|---|
| **GitHub Pages** | Activar Pages no repositório e publicar o conteúdo de `POLITICA_PRIVACIDADE_PT.md` | Gratuito. Exige que o repositório seja público — o que levanta a questão da licença (ver `../RELATORIO_FINAL_AUDITORIA.md`) |
| **Página no sítio da KUNDIAMA** | Publicar em `kundiama.ao` ou domínio equivalente | Preferível: fica sob o domínio da organização, o que é mais credível |
| **Documento publicado** | Google Docs ou Notion com partilha pública | Aceito pela Google, mas menos profissional e sujeito a alterações de ligação |

Requisitos da Google para essa página:

- [ ] Acessível sem iniciar sessão;
- [ ] Refere **explicitamente** a aplicação pelo nome (dB Konversor);
- [ ] Identifica a entidade responsável (KUNDIAMA Tecnologia e Inovação);
- [ ] Inclui um contacto de privacidade;
- [ ] Descreve o tratamento de dados, a conservação e a eliminação;
- [ ] Não é um ficheiro para descarregar (PDF não é recomendado), mas uma página web.

**Depois de publicada:** actualizar a secção 12 das **cinco** políticas em
`docs/privacy/` com a URL real, e preencher o campo na Play Console.

### 4.2 Preencher o formulário na Play Console

1. Play Console → a aplicação → **Policy and programmes** → **App content**
2. **Data safety** → *Start* / *Manage*
3. Responder conforme a secção 2 deste documento
4. Colar a URL da política
5. Rever o resumo que a Google apresenta e confirmar que corresponde a este
   documento
6. **Submeter** e aguardar a validação

### 4.3 Verificações complementares recomendadas antes de submeter

- [ ] Instalar o `.aab` num dispositivo real (via `bundletool` ou um canal de
      teste interno) e confirmar que todas as funcionalidades funcionam **com o
      modo de voo activo** — confirmação empírica de que nada depende da rede.
- [ ] Confirmar na ficha da aplicação, na secção de permissões, que não aparece
      nenhuma permissão sensível.
- [ ] Reler a Política de Privacidade e confirmar que descreve a versão que vai
      ser publicada, e não uma versão anterior.

---

## 5. Quando é obrigatório revisitar este documento

A declaração *Data safety* tem de ser actualizada **antes** de publicar uma
versão que faça qualquer uma destas coisas:

| Alteração | Consequência na declaração |
|---|---|
| Acrescentar `android.permission.INTERNET` | A resposta a «collect or share» deixa de poder ser automaticamente *No*; é preciso justificar o que é transmitido |
| Acrescentar publicidade (AdMob ou outra) | Passa a haver recolha de identificadores de publicidade e partilha com terceiros |
| Acrescentar análise de utilização (Analytics) | Passa a haver recolha de «App activity» e «Device IDs» |
| Acrescentar relato de falhas (Crashlytics) | Passa a haver recolha de «Crash logs» e «Diagnostics» |
| Acrescentar sincronização na nuvem do histórico | O histórico passa a ser dado **recolhido** |
| Acrescentar conta de utilizador | Passa a haver recolha de informação pessoal |
| Acrescentar qualquer SDK de terceiros | Exige auditar o que esse SDK recolhe por si próprio |

**Regra prática:** sempre que `pubspec.yaml` ganhar uma dependência nova,
reler `RELATORIO_AUDITORIA_PRIVACIDADE.md` e verificar se continua verdadeiro.

---

## 6. Questões pendentes e limitações

| Questão | Estado |
|---|---|
| URL pública da política | **Pendente** — não existe; não foi inventada |
| Submissão do formulário *Data safety* | **Não executada** — exige a Play Console |
| Confirmação empírica em modo de voo | **Não executada** — não há dispositivo nem emulador disponível neste ambiente |
| Inspecção do `.aab` com `bundletool` | **Não executada** — recomendada antes da publicação |
| Eliminação do projecto Firebase `db-konversor` | **Não executada** — acção na consola do Firebase. Os ficheiros locais foram removidos, mas o projecto remoto pode continuar a existir |
| Certificação de segurança independente | Não existe; a resposta ao formulário reflecte isso |

---

## 7. Resumo numa frase

> O dB Konversor **não recolhe nem partilha dados**; guarda um histórico de
> conversões **apenas no dispositivo**, que o utilizador pode apagar; a versão
> publicada **não tem permissão de acesso à rede**; e falta publicar a URL da
> política e submeter o formulário na Play Console.
