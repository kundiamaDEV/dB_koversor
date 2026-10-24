<#
.SYNOPSIS
    Captura as imagens da ficha da Google Play a partir da aplicacao real.

.DESCRIPTION
    Arranca o emulador indicado, compila e instala a versao de lancamento do
    dB Konversor, define o idioma do sistema e guia a captura das seis imagens
    previstas em PLANO_CAPTURAS.md.

    PORQUE A NAVEGACAO NAO E AUTOMATICA
    O script para e espera por cada ecra a preparar. Automatizar a navegacao
    exigiria um teste de integracao com `integration_test`, que para seis
    toques daria mais trabalho a manter do que resolve. O que o script
    automatiza e o que e repetitivo e sujeito a erro: arranque, instalacao,
    mudanca de idioma, nomes dos ficheiros e verificacao das dimensoes.

    REGRA IMPORTANTE
    As capturas mostram a aplicacao realmente executada, com os resultados que
    ela produz. Nunca editar os numeros de uma captura.

.PARAMETER Emulador
    Nome do AVD, como aparece em `flutter emulators`. Se omitido, usa o
    dispositivo Android ja ligado.

.PARAMETER Idioma
    Codigo do idioma a capturar: pt, en, fr, es ou zh.

.PARAMETER Classe
    Classe de dispositivo, usada no nome dos ficheiros: phone, tablet7 ou
    tablet10.

.PARAMETER SaltarInstalacao
    Nao recompila nem reinstala. Util para capturar noutro idioma logo depois.

.EXAMPLE
    ./capturar.ps1 -Emulador dbk_phone -Idioma pt -Classe phone

.EXAMPLE
    ./capturar.ps1 -Idioma fr -Classe phone -SaltarInstalacao
#>

param(
    [string]$Emulador = "",

    [ValidateSet("pt", "en", "fr", "es", "zh")]
    [string]$Idioma = "pt",

    [ValidateSet("phone", "tablet7", "tablet10")]
    [string]$Classe = "phone",

    [switch]$SaltarInstalacao
)

$ErrorActionPreference = "Stop"

# Raiz do projecto: tres niveis acima de docs/store/screenshots/
$raiz = Resolve-Path (Join-Path $PSScriptRoot "../../..")
$destino = Join-Path $PSScriptRoot "generated"

# Codigos de local completos, como o Android os espera.
$locais = @{
    "pt" = "pt-PT"
    "en" = "en-US"
    "fr" = "fr-FR"
    "es" = "es-ES"
    "zh" = "zh-CN"
}

# Ecras a capturar, na ordem da ficha da loja.
# A descricao e o que fica no nome do ficheiro.
$ecras = @(
    @{
        N = "01"
        Nome = "conversor"
        Preparar = "Valor '30', entrada 'dBm', saida 'W'. O resultado deve mostrar 1."
        Esperado = "resultado = 1"
    },
    @{
        N = "02"
        Nome = "formula"
        Preparar = "A partir do ecra anterior, tocar no botao FORMULA."
        Esperado = "dialogo com 'mW = 10^(dBm / 10)  |  W = mW / 1000'"
    },
    @{
        N = "03"
        Nome = "impedancia"
        Preparar = "Fechar o dialogo. Valor '0', entrada 'dBm', saida 'dBV', impedancia '50'."
        Esperado = "resultado = -13.0103 e campo de impedancia visivel"
    },
    @{
        N = "04"
        Nome = "unidades"
        Preparar = "Abrir o menu lateral (icone de menu, canto superior esquerdo)."
        Esperado = "lista das 7 unidades com as descricoes"
    },
    @{
        N = "05"
        Nome = "historico"
        Preparar = "Fechar o menu. FAZER 5 CONVERSOES REAIS (30 dBm->W, 1 W->dBm, 0 dBW->dBm, 0 dBu->dBV, -100 dBm->dBV a 50 ohm). Depois abrir o historico (botao do relogio)."
        Esperado = "historico com 5 entradas reais, nao fabricadas"
    },
    @{
        N = "06"
        Nome = "sem_anuncios"
        Preparar = "Fechar o historico. Deixar o conversor com um resultado visivel."
        Esperado = "conversor limpo, com resultado"
    }
)

function Escrever-Titulo($texto) {
    Write-Host ""
    Write-Host ("=" * 70) -ForegroundColor Cyan
    Write-Host $texto -ForegroundColor Cyan
    Write-Host ("=" * 70) -ForegroundColor Cyan
}

function Obter-Adb {
    $caminho = Join-Path $env:LOCALAPPDATA "Android\sdk\platform-tools\adb.exe"
    if (Test-Path $caminho) { return $caminho }

    $noPath = Get-Command adb -ErrorAction SilentlyContinue
    if ($noPath) { return $noPath.Source }

    throw "adb nao encontrado. Instalar as platform-tools do Android SDK."
}

Escrever-Titulo "dB Konversor - captura de imagens da loja"
Write-Host "Idioma : $Idioma ($($locais[$Idioma]))"
Write-Host "Classe : $Classe"
Write-Host "Destino: $destino"

$adb = Obter-Adb
New-Item -ItemType Directory -Force -Path $destino | Out-Null

# ---------------------------------------------------------------- emulador
if ($Emulador -ne "") {
    Escrever-Titulo "A arrancar o emulador '$Emulador'"
    flutter emulators --launch $Emulador
    Write-Host "A aguardar que o dispositivo fique disponivel..."
    & $adb wait-for-device
    # O `wait-for-device` volta assim que o adb responde, mas o sistema pode
    # ainda estar a arrancar. Espera-se que o boot termine.
    do {
        Start-Sleep -Seconds 2
        $pronto = (& $adb shell getprop sys.boot_completed) -replace '\s', ''
    } while ($pronto -ne "1")
    Write-Host "Emulador pronto." -ForegroundColor Green
}

$dispositivos = & $adb devices | Select-String -Pattern "device$"
if (-not $dispositivos) {
    throw "Nenhum dispositivo Android ligado. Usar -Emulador <nome> ou ligar um telefone."
}

# ---------------------------------------------------------------- idioma
Escrever-Titulo "A definir o idioma do sistema: $($locais[$Idioma])"
Write-Host "Nota: em alguns emuladores esta propriedade exige permissoes de root."
Write-Host "Se falhar, mudar o idioma a mao em Definicoes > Sistema > Idiomas."
try {
    & $adb shell "setprop persist.sys.locale $($locais[$Idioma])" 2>$null
    Write-Host "Propriedade definida. A reiniciar a interface..."
    & $adb shell "stop; start" 2>$null
    Start-Sleep -Seconds 8
}
catch {
    Write-Host "Nao foi possivel definir o idioma automaticamente." -ForegroundColor Yellow
    Read-Host "Mudar o idioma a mao no emulador e premir Enter"
}

# ---------------------------------------------------------------- instalacao
if (-not $SaltarInstalacao) {
    Escrever-Titulo "A compilar a versao de LANCAMENTO"
    Write-Host "Usa-se --release e nao --debug: a versao de depuracao mostra a"
    Write-Host "faixa DEBUG, que nao pode aparecer nas capturas."

    Push-Location $raiz
    try {
        flutter build apk --release
        if ($LASTEXITCODE -ne 0) { throw "A compilacao falhou." }

        $apk = Join-Path $raiz "build\app\outputs\flutter-apk\app-release.apk"
        if (-not (Test-Path $apk)) { throw "APK nao encontrado em $apk" }

        Write-Host "A instalar..."
        & $adb install -r $apk
        if ($LASTEXITCODE -ne 0) { throw "A instalacao falhou." }
    }
    finally {
        Pop-Location
    }
}

# O ecra tem de estar aceso: uma captura com o ecra apagado produz uma imagem
# completamente preta, que parece uma captura valida mas nao mostra nada.
Escrever-Titulo "A acordar o ecra"
& $adb shell input keyevent KEYCODE_WAKEUP 2>$null
Start-Sleep -Seconds 1
$estado = (& $adb shell dumpsys power 2>$null | Select-String "mWakefulness=") -join " "
Write-Host "Estado: $estado"
Write-Host "Se o dispositivo tiver bloqueio de ecra, desbloqueie-o a mao agora." -ForegroundColor Yellow

Escrever-Titulo "A abrir a aplicacao"
& $adb shell monkey -p ao.kundiama.dbkonversor -c android.intent.category.LAUNCHER 1 | Out-Null
Write-Host "A aguardar o ecra de abertura (3 segundos de splash)..."
Start-Sleep -Seconds 6

# ---------------------------------------------------------------- capturas
Escrever-Titulo "Captura das $($ecras.Count) imagens"
Write-Host "Para cada imagem: preparar o ecra no emulador e premir Enter."
Write-Host "Escrever 's' para saltar uma imagem." -ForegroundColor Yellow

$capturadas = 0

foreach ($ecra in $ecras) {
    Write-Host ""
    Write-Host "--- Imagem $($ecra.N): $($ecra.Nome) ---" -ForegroundColor Green
    Write-Host "PREPARAR : $($ecra.Preparar)"
    Write-Host "ESPERADO : $($ecra.Esperado)"

    $resposta = Read-Host "Enter para capturar, 's' para saltar"
    if ($resposta -eq "s") {
        Write-Host "Saltada." -ForegroundColor Yellow
        continue
    }

    $ficheiro = Join-Path $destino "$($Idioma)_$($Classe)_$($ecra.N)_$($ecra.Nome).png"

    # CAPTURA EM DOIS PASSOS -- NAO USAR `adb exec-out screencap -p > ficheiro`
    #
    # Em PowerShell, o operador `>` trata a saida como TEXTO: aplica a
    # codificacao de saida e acrescenta um BOM. Isso CORROMPE o PNG, que fica
    # com `EF BB BF` antes da assinatura e deixa de ser uma imagem valida.
    # Verificado neste projecto em 2026-10-19: o ficheiro resultante comecava
    # por `ef bb bf ef bf bd 50 4e` em vez de `89 50 4e 47`.
    #
    # A alternativa fiavel e gravar no dispositivo e trazer o ficheiro com
    # `adb pull`, que copia os bytes sem interpretacao.
    $remoto = "/sdcard/dbk_captura_temp.png"
    & $adb shell screencap -p $remoto
    & $adb pull $remoto $ficheiro 2>&1 | Out-Null
    & $adb shell rm $remoto

    # Confirma que o ficheiro e mesmo um PNG: os primeiros bytes tem de ser
    # a assinatura 89 50 4E 47. Se a captura falhar ou for corrompida, e
    # melhor nao guardar nada do que guardar um ficheiro invalido.
    $valido = $false
    if ((Test-Path $ficheiro) -and ((Get-Item $ficheiro).Length -gt 1000)) {
        $bytes = Get-Content -Path $ficheiro -AsByteStream -TotalCount 4
        if ($bytes.Length -eq 4 -and
            $bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50 -and
            $bytes[2] -eq 0x4E -and $bytes[3] -eq 0x47) {
            $valido = $true
        }
    }

    if ($valido) {
        $tamanhoKb = [math]::Round((Get-Item $ficheiro).Length / 1KB, 1)
        Write-Host "Guardada: $(Split-Path -Leaf $ficheiro) ($tamanhoKb KB)" -ForegroundColor Green
        $capturadas++
    }
    else {
        Write-Host "FALHOU: ficheiro ausente, vazio ou nao e um PNG valido." -ForegroundColor Red
        if (Test-Path $ficheiro) { Remove-Item $ficheiro }
    }
}

# ---------------------------------------------------------------- resumo
Escrever-Titulo "Resumo"
Write-Host "Capturadas: $capturadas de $($ecras.Count)"

$todas = Get-ChildItem -Path $destino -Filter "*.png" -ErrorAction SilentlyContinue
if ($todas) {
    Write-Host ""
    Write-Host "Ficheiros em generated/:"
    $todas | ForEach-Object {
        $kb = [math]::Round($_.Length / 1KB, 1)
        Write-Host ("  {0,-44} {1,8} KB" -f $_.Name, $kb)
    }

    $grandes = $todas | Where-Object { $_.Length -gt 8MB }
    if ($grandes) {
        Write-Host ""
        Write-Host "AVISO: estes ficheiros excedem o limite de 8 MB da Google Play:" -ForegroundColor Red
        $grandes | ForEach-Object { Write-Host "  $($_.Name)" -ForegroundColor Red }
    }
}

Write-Host ""
Write-Host "A FAZER A MAO ANTES DE CARREGAR NA PLAY CONSOLE:" -ForegroundColor Yellow
Write-Host "  1. Confirmar que nenhuma captura mostra a faixa DEBUG."
Write-Host "  2. Confirmar que os resultados coincidem com"
Write-Host "     docs/evidence/exemplos_verificados.txt."
Write-Host "  3. Confirmar que a barra de notificacoes nao mostra informacao pessoal."
Write-Host "  4. Remover o canal alfa dos PNG, se existir."
Write-Host "  5. Criar o feature graphic de 1024x500 (material DISTINTO das capturas)."
Write-Host "  6. Ver a lista completa em PLANO_CAPTURAS.md, seccao 8."
Write-Host ""
