# Plano de Capturas de Ecrã — dB Konversor

**Data:** 2026-10-17

---

> ## ESTADO: NENHUMA CAPTURA FOI GERADA
>
> **Não existe nenhum ficheiro de imagem nesta pasta.**
>
> ### 2026-10-17 — sem alvo Android
>
> ```
> > flutter devices
> Found 3 connected devices:
>   Windows (desktop) • windows • windows-x64
>   Chrome (web)      • chrome  • web-javascript
>   Edge (web)        • edge    • web-javascript
>
> > flutter emulators
> No emulators available.
> ```
>
> ### 2026-10-19 — dispositivo real ligado, mas desligou-se
>
> Um telefone Android (**25028RN03A**, Android 15, 720 × 1640, 320 dpi) foi
> ligado por USB durante a sessão. Permitiu verificar, **em hardware real**:
>
> | Verificação | Resultado |
> |---|---|
> | `flutter build apk --release` | **APROVADO** — 53,1 MB |
> | `adb install -r app-release.apk` | **APROVADO** — «Success» |
> | Arranque da aplicação | **APROVADO** — processo a correr, PID 17813 |
> | Ausência de falhas | **APROVADO** — nenhum `FATAL` nem `AndroidRuntime` no `logcat` |
>
> Isto confirma em hardware real que o bloqueador **B1** está resolvido.
>
> **A ligação USB caiu antes das capturas.** A única imagem obtida foi feita
> com o ecrã do telefone apagado e saiu completamente preta, pelo que foi
> **apagada em vez de ser aproveitada** — uma imagem preta não demonstra nada
> sobre a interface.
>
> Registo completo em
> [`../../evidence/execucao_em_dispositivo_real.txt`](../../evidence/execucao_em_dispositivo_real.txt).
>
> **Nada foi inventado.** O plano, as especificações e o script estão prontos;
> falta a execução, que depende de um dispositivo ligado de forma estável.

---

## 0. Defeito corrigido na ferramenta de captura

A tentativa de 2026-10-19 revelou um defeito real no script
[`capturar.ps1`](capturar.ps1), já corrigido, que vale a pena conhecer porque
afecta qualquer captura feita em PowerShell:

> `adb exec-out screencap -p > ficheiro.png` **corrompe o PNG em PowerShell.**
> O operador `>` trata a saída como texto e acrescenta um BOM. O ficheiro
> gerado começava por `ef bb bf ef bf bd 50 4e` em vez da assinatura válida
> `89 50 4e 47`.

A forma correcta, agora implementada no script, é gravar no dispositivo e
trazer o ficheiro com `adb pull`, que copia os bytes sem interpretação:

```powershell
adb shell screencap -p /sdcard/temp.png
adb pull /sdcard/temp.png destino.png
adb shell rm /sdcard/temp.png
```

O script passou também a **verificar a assinatura PNG** de cada ficheiro
gerado (apagando os inválidos) e a **acordar o ecrã** antes de capturar, para
não produzir imagens pretas.

> **Nota para quem usar Git Bash:** o Git Bash converte `/sdcard/...` num
> caminho do Windows, e o `adb` falha. É preciso `export MSYS_NO_PATHCONV=1`.
> Em PowerShell o problema não existe.

---

## 1. Requisitos da Google Play

Consultar sempre os requisitos actuais em
<https://support.google.com/googleplay/android-developer/answer/9866151>
antes da submissão, porque a Google altera-os periodicamente. Os valores
abaixo eram os praticados em 2026-10-17.

### Capturas de ecrã de telefone

| Requisito | Valor |
|---|---|
| Quantidade | Mínimo **2**, máximo 8. **Recomendado: 6** |
| Formato | PNG de 24 bits (sem canal alfa) ou JPEG |
| Lado menor | Mínimo 320 px |
| Lado maior | Máximo 3840 px |
| Proporção | Entre 16:9 e 9:16 |
| Tamanho | Máximo 8 MB por ficheiro |

### Capturas de tablet

| Requisito | Valor |
|---|---|
| Tablet de 7 polegadas | Mínimo 2 para ser classificada como compatível |
| Tablet de 10 polegadas | Mínimo 2 |
| Mesmas regras | Formato, lado mínimo/máximo e tamanho iguais aos do telefone |

**[Importante]** Sem capturas de tablet, a Google Play pode marcar a aplicação
como «não optimizada para tablets», o que reduz a visibilidade nesses
dispositivos. Como os testes de widget confirmam que a disposição em tablet
funciona sem transbordo, vale a pena fornecê-las.

### Feature graphic — material DISTINTO das capturas

| Requisito | Valor |
|---|---|
| Dimensões | **Exactamente 1024 × 500 px** |
| Formato | PNG de 24 bits (sem alfa) ou JPEG |
| Conteúdo | Imagem promocional, **não** uma captura de ecrã |
| Texto | Deve ser legível em miniatura; evitar texto nas bordas |
| Obrigatório | **Sim**, para a ficha da loja |

> **Não confundir:** as capturas de ecrã mostram a aplicação real. O *feature
> graphic* é uma peça gráfica promocional (banner), com o logótipo e uma
> mensagem. São materiais diferentes, com requisitos diferentes. Usar uma
> captura redimensionada como *feature graphic* fica mal e pode ser rejeitado.

### Ícone da loja

| Requisito | Valor | Estado |
|---|---|---|
| Dimensões | 512 × 512 px, PNG de 32 bits com alfa | `assets/icons/app_icon.png` existe (1,9 MB) — **verificar e redimensionar para 512 × 512** |

---

## 2. Dispositivos a usar

| Classe | Dispositivo / AVD sugerido | Resolução | DPI | Conteúdo |
|---|---|---|---|---|
| Telefone pequeno | Pixel 4a | 1080 × 2340 | 440 | 6 capturas |
| Telefone grande | Pixel 8 Pro | 1344 × 2992 | 489 | 6 capturas (opcional) |
| Tablet 7" | Nexus 7 (2013) | 1200 × 1920 | 320 | 2 capturas |
| Tablet 10" | Pixel Tablet | 1600 × 2560 | 276 | 2 capturas |

**Orientação:** vertical para todas. A orientação horizontal **não** é
necessária para a ficha; os testes de widget já confirmam que não há transbordo
em horizontal, mas a loja mostra capturas verticais para aplicações deste tipo.

---

## 3. As seis capturas, em ordem

A ordem é a da ficha e está justificada em
[`../ASO_ESTRATEGIA_GLOBAL.md`](../ASO_ESTRATEGIA_GLOBAL.md), secção 5. As duas
primeiras são as que aparecem sem o utilizador deslizar.

### Captura 1 — Conversor com um resultado real

| | |
|---|---|
| **Estado a preparar** | Valor `30`, entrada `dBm`, saída `W`. Resultado apresentado: `1` |
| **Porque este caso** | 30 dBm = 1 W é uma igualdade exacta e memorável, que um engenheiro reconhece de imediato como correcta |
| **Verificado** | Sim — ver `../../evidence/exemplos_verificados.txt` |
| **Texto sobreposto** | «Converte decibéis num instante» |

### Captura 2 — Diálogo da fórmula aberto

| | |
|---|---|
| **Estado a preparar** | A partir da captura 1, tocar em `FÓRMULA` |
| **Conteúdo visível** | `mW = 10^(dBm / 10)  \|  W = mW / 1000` |
| **Porque** | É o diferenciador principal da aplicação |
| **Texto sobreposto** | «Vê a fórmula, não só o número» |

### Captura 3 — Conversão com impedância

| | |
|---|---|
| **Estado a preparar** | Valor `0`, entrada `dBm`, saída `dBV`, impedância `50` |
| **Resultado esperado** | `-13.0103` |
| **Verificado** | Sim — 0 dBm em 50 Ω = −13,0102999566 dBV |
| **Porque** | Prova a competência técnica: o campo de impedância aparece **só** nesta família de conversões |
| **Texto sobreposto** | «Impedância só quando é precisa» |

### Captura 4 — Menu lateral com as unidades

| | |
|---|---|
| **Estado a preparar** | Abrir o menu lateral (ícone de menu) |
| **Conteúdo visível** | As 7 unidades com a descrição de cada uma |
| **Nota** | Num telefone pequeno pode ser preciso deslizar para mostrar as 7; preferir o enquadramento que mostre `dBm`, `dBW`, `dBu` e `dBV` |
| **Texto sobreposto** | «dBm, dBW, dBV, dBu, W, mW, dB» |

### Captura 5 — Histórico com entradas reais

| | |
|---|---|
| **Estado a preparar** | **Fazer 4 ou 5 conversões reais antes**, para que o histórico tenha conteúdo autêntico. Sugestão: `30 dBm → W`, `1 W → dBm`, `0 dBW → dBm`, `0 dBu → dBV`, `-100 dBm → dBV` (50 Ω) |
| **Porque assim** | O histórico está vazio numa instalação nova. **Não** alterar o código para o pré-preencher: isso recriaria exactamente o defeito F1 que esta auditoria corrigiu |
| **Texto sobreposto** | «O teu histórico, no teu telemóvel» |

### Captura 6 — Disposição em tablet

| | |
|---|---|
| **Estado a preparar** | Conversor no tablet de 10", com um resultado visível |
| **Porque** | Sinaliza suporte de tablet, que a Google valoriza na visibilidade |
| **Texto sobreposto** | «Sem anúncios. Sem Internet.» |

---

## 4. Procedimento de captura

### 4.1 Criar um emulador, se não existir

```powershell
# Listar as imagens de sistema instaladas
& "$env:LOCALAPPDATA\Android\sdk\cmdline-tools\latest\bin\sdkmanager.bat" --list | Select-String "system-images"

# Instalar uma imagem (exemplo: Android 14, x86_64)
& "$env:LOCALAPPDATA\Android\sdk\cmdline-tools\latest\bin\sdkmanager.bat" "system-images;android-34;google_apis;x86_64"

# Criar o AVD de telefone
& "$env:LOCALAPPDATA\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd `
    -n dbk_phone -k "system-images;android-34;google_apis;x86_64" -d pixel_4a

# Criar o AVD de tablet de 10"
& "$env:LOCALAPPDATA\Android\sdk\cmdline-tools\latest\bin\avdmanager.bat" create avd `
    -n dbk_tablet10 -k "system-images;android-34;google_apis;x86_64" -d "pixel_tablet"

# Confirmar
flutter emulators
```

Alternativa mais simples: criar os AVD pelo **Device Manager** do Android
Studio.

### 4.2 Capturar

O script [`capturar.ps1`](capturar.ps1) automatiza o arranque do emulador, a
instalação da aplicação e a captura. Uso:

```powershell
# Capturas de telefone, em português
./docs/store/screenshots/capturar.ps1 -Emulador dbk_phone -Idioma pt -Classe phone

# Capturas de tablet
./docs/store/screenshots/capturar.ps1 -Emulador dbk_tablet10 -Idioma pt -Classe tablet10
```

O script **pára e espera** por cada estado a preparar na aplicação, porque a
navegação tem de ser feita à mão: automatizá-la exigiria testes de integração
que, neste caso, dariam mais trabalho do que seis toques no ecrã.

### 4.3 Captura manual, se preferir

```powershell
# Arrancar o emulador
flutter emulators --launch dbk_phone

# Instalar a versão de lançamento (aspecto final, sem marca de depuração)
flutter build apk --release
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Mudar o idioma do emulador, para capturar noutra língua
# (Definições → Sistema → Idiomas, ou:)
adb shell "setprop persist.sys.locale fr-FR; stop; start"

# Capturar
adb exec-out screencap -p > docs/store/screenshots/generated/pt_phone_01_conversor.png
```

> **Usar a versão `--release`, não `--debug`.** A compilação de depuração
> mostra a faixa «DEBUG» e tem desempenho de animações diferente.

---

## 5. Convenção de nomes dos ficheiros

```
<idioma>_<classe>_<numero>_<descricao>.png
```

Exemplos:

```
pt_phone_01_conversor.png
pt_phone_02_formula.png
pt_phone_03_impedancia.png
pt_phone_04_unidades.png
pt_phone_05_historico.png
pt_phone_06_sem_anuncios.png
en_phone_01_converter.png
pt_tablet10_01_conversor.png
```

Os ficheiros gerados vão para `generated/`, que está no `.gitignore`: são
artefactos binários pesados, que não devem engrossar o repositório. Devem ser
guardados pelo proprietário e carregados directamente na Play Console.

---

## 6. Idiomas a capturar

| Idioma | Capturas | Justificação |
|---|---|---|
| Português | 6 (telefone) + 2 (tablet 10") + 2 (tablet 7") | Mercado de origem |
| Inglês | 6 (telefone) | Maior alcance; é a ficha por omissão |
| Francês | 6 (telefone) | **Prioritário para verificação de layout:** é o idioma com os textos mais longos |
| Espanhol | 6 (telefone) | Mercado grande |
| Chinês | 2 (telefone) | **Verificação importante:** confirmar que os caracteres chineses aparecem e não como quadrados vazios (ver `../../GUIA_LOCALIZACAO.md`, secção 7) |

**Mínimo viável para publicar:** 6 capturas de telefone em português + 2 de
tablet. As restantes podem ser acrescentadas depois; a Google Play usa as
capturas do idioma por omissão quando um idioma não tem as suas.

---

## 7. Regras de honestidade

Estas regras não são estéticas, são de conformidade. A Google remove fichas
com material enganoso.

| Regra | Porquê |
|---|---|
| Capturas da aplicação **realmente executada** | Uma maqueta apresentada como produto é material enganoso |
| **Nunca** editar os números dos resultados | Qualquer pessoa pode instalar a aplicação e verificar. Além disso, todos os valores propostos neste plano foram verificados em `../../evidence/exemplos_verificados.txt` |
| Não mostrar funcionalidades que não existem | A ficha só declara as 13 funcionalidades verificadas no código |
| Não usar dados pessoais reais nas capturas | O histórico deve conter conversões técnicas, não informação de pessoas |
| O texto sobreposto não pode contradizer a aplicação | Se diz «7 unidades», têm de existir 7 |
| Não imitar a identidade visual de outra aplicação | — |

---

## 8. Lista de verificação antes de carregar na Play Console

- [ ] 6 capturas de telefone no idioma por omissão (pt)
- [ ] 2 capturas de tablet de 10"
- [ ] 2 capturas de tablet de 7"
- [ ] *Feature graphic* de 1024 × 500 px criado (**material distinto**)
- [ ] Ícone de 512 × 512 px verificado
- [ ] Todos os PNG sem canal alfa (requisito da Google para capturas)
- [ ] Nenhum ficheiro acima de 8 MB
- [ ] Nenhuma faixa «DEBUG» visível
- [ ] Nenhuma barra de notificações com informação pessoal (nome de rede, hora
      com fuso que revele localização, notificações de outras aplicações)
- [ ] Os resultados numéricos coincidem com
      `../../evidence/exemplos_verificados.txt`
- [ ] As capturas em chinês mostram os caracteres correctamente
- [ ] As capturas em francês não mostram texto cortado

---

## 9. O que está pendente, em resumo

| Item | Estado | Depende de |
|---|---|---|
| Capturas de telefone | **NÃO GERADAS** | Emulador ou dispositivo Android |
| Capturas de tablet | **NÃO GERADAS** | Emulador de tablet |
| *Feature graphic* | **NÃO CRIADO** | Decisão de design do proprietário |
| Ícone de 512 × 512 | A verificar | Redimensionar o existente |
| Verificação dos caracteres chineses | **PENDENTE** | Execução em dispositivo |
| Script de captura | **Pronto** — [`capturar.ps1`](capturar.ps1) | — |
| Plano e especificações | **Prontos** — este documento | — |
