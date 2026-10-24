<#
.SYNOPSIS
    Executa toda a cadeia de validacao do dB Konversor e registra o resultado.

.DESCRIPTION
    Corre, pela ordem correcta: resolucao de dependencias, geracao das
    localizacoes, analise estatica, testes, verificacao dos limites das fichas
    da loja, verificacao numerica independente e, opcionalmente, as
    compilacoes Android.

    Escreve um relatorio em docs/evidence/validacao_<data>.txt, para que o
    resultado fique registado com data e ambiente em vez de depender da
    memoria de quem executou.

    Codigo de saida 0 se tudo passou; 1 se alguma etapa falhou.

.PARAMETER ComCompilacao
    Inclui `flutter build apk --debug` e `flutter build appbundle --release`.
    Demora varios minutos.

.PARAMETER SemRelatorio
    Nao escreve o ficheiro de relatorio; so imprime no terminal.

.EXAMPLE
    ./scripts/validar.ps1

.EXAMPLE
    ./scripts/validar.ps1 -ComCompilacao
#>

param(
    [switch]$ComCompilacao,
    [switch]$SemRelatorio
)

# Nao se usa $ErrorActionPreference = "Stop" de proposito: queremos que TODAS
# as etapas corram, para que o relatorio mostre o estado completo, e nao so a
# primeira falha.

$raiz = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $raiz

$inicio = Get-Date
$linhas = [System.Collections.Generic.List[string]]::new()
$etapas = [System.Collections.Generic.List[object]]::new()

function Registar($texto) {
    Write-Host $texto
    $linhas.Add($texto)
}

function Titulo($texto) {
    Registar ""
    Registar ("=" * 72)
    Registar $texto
    Registar ("=" * 72)
}

function Executar {
    param(
        [string]$Nome,
        [string]$Comando,
        [scriptblock]$Accao,
        [switch]$NaoCritico
    )

    Titulo "ETAPA: $Nome"
    Registar "Comando: $Comando"
    Registar ""

    $saida = & $Accao 2>&1 | Out-String
    $codigo = $LASTEXITCODE
    if ($null -eq $codigo) { $codigo = 0 }

    # Mostra apenas as ultimas linhas, para o relatorio nao ficar ilegivel.
    $resumo = ($saida -split "`n" | Where-Object { $_.Trim() -ne "" } | Select-Object -Last 12) -join "`n"
    Registar $resumo

    $estado = if ($codigo -eq 0) { "APROVADO" } elseif ($NaoCritico) { "AVISO" } else { "FALHOU" }

    $etapas.Add([pscustomobject]@{
        Nome    = $Nome
        Comando = $Comando
        Codigo  = $codigo
        Estado  = $estado
    })

    Registar ""
    Registar "-> $Nome : $estado (codigo $codigo)"
}

# ----------------------------------------------------------------- ambiente
Titulo "dB Konversor - validacao completa"
Registar "Data      : $($inicio.ToString('yyyy-MM-dd HH:mm:ss'))"
Registar "Directorio: $raiz"
Registar "Sistema   : $([System.Environment]::OSVersion.VersionString)"

$versaoFlutter = (flutter --version 2>&1 | Select-Object -First 1)
Registar "Flutter   : $versaoFlutter"

# ------------------------------------------------------------------ etapas
Executar -Nome "Dependencias" -Comando "flutter pub get" -Accao {
    flutter pub get
}

Executar -Nome "Geracao das localizacoes" -Comando "flutter gen-l10n" -Accao {
    flutter gen-l10n
}

Titulo "ETAPA: Chaves de traducao por traduzir"
Registar "Ficheiro: l10n_untranslated.json"
if (Test-Path "l10n_untranslated.json") {
    $naoTraduzidas = (Get-Content -Raw "l10n_untranslated.json").Trim()
    Registar "Conteudo: $naoTraduzidas"
    $estadoL10n = if ($naoTraduzidas -eq "{}") { "APROVADO" } else { "FALHOU" }
    Registar ""
    Registar "-> Traducoes completas : $estadoL10n"
    $etapas.Add([pscustomobject]@{
        Nome = "Traducoes completas"; Comando = "l10n_untranslated.json"
        Codigo = $(if ($estadoL10n -eq "APROVADO") { 0 } else { 1 }); Estado = $estadoL10n
    })
} else {
    Registar "Ficheiro nao encontrado (a geracao pode nao o ter produzido)."
    $etapas.Add([pscustomobject]@{
        Nome = "Traducoes completas"; Comando = "l10n_untranslated.json"
        Codigo = 1; Estado = "AVISO"
    })
}

Executar -Nome "Analise estatica" -Comando "flutter analyze" -Accao {
    flutter analyze
}

Executar -Nome "Testes automatizados" -Comando "flutter test" -Accao {
    flutter test
}

Executar -Nome "Limites das fichas da loja" -Comando "python docs/store/verificar_limites.py" -Accao {
    python docs/store/verificar_limites.py
}

Executar -Nome "Exemplos numericos verificados" -Comando "dart run docs/evidence/gerar_exemplos.dart" -Accao {
    dart run docs/evidence/gerar_exemplos.dart
}

if ($ComCompilacao) {
    Executar -Nome "Compilacao Android (depuracao)" -Comando "flutter build apk --debug" -Accao {
        flutter build apk --debug
    }

    Executar -Nome "Compilacao Android (lancamento)" -Comando "flutter build appbundle --release" -Accao {
        flutter build appbundle --release
    }

    # A assinatura de lancamento e uma verificacao a parte: a compilacao pode
    # ter exito e ainda assim produzir um pacote nao publicavel.
    Titulo "ETAPA: Assinatura de lancamento"
    if (Test-Path "android/key.properties") {
        Registar "android/key.properties existe: o pacote de lancamento esta assinado"
        Registar "com a chave de producao."
        $etapas.Add([pscustomobject]@{
            Nome = "Assinatura de lancamento"; Comando = "android/key.properties"
            Codigo = 0; Estado = "APROVADO"
        })
    } else {
        Registar "android/key.properties NAO existe."
        Registar ""
        Registar "O pacote de lancamento foi assinado com a chave de DEPURACAO e"
        Registar "NAO pode ser publicado na Google Play. Isto e esperado enquanto a"
        Registar "chave de assinatura nao for criada pelo proprietario."
        Registar "Procedimento: README.md, seccao 'Assinatura de lancamento'."
        $etapas.Add([pscustomobject]@{
            Nome = "Assinatura de lancamento"; Comando = "android/key.properties"
            Codigo = 0; Estado = "PENDENTE"
        })
    }
} else {
    Registar ""
    Registar "Compilacoes Android saltadas. Usar -ComCompilacao para as incluir."
}

# ----------------------------------------------------------- nao executaveis
Titulo "VERIFICACOES QUE ESTE SCRIPT NAO PODE FAZER"
Registar "Nao sao falhas: dependem de dispositivos ou de accoes externas."
Registar ""

# Deteccao de dispositivo Android.
#
# NAO se procura a palavra "android" na saida de texto de `flutter devices`:
# essa saida inclui URL de ajuda como "developer.android.com", o que produz um
# falso positivo e faria o relatorio afirmar que ha um dispositivo quando nao
# ha. Usa-se a saida em JSON e verifica-se o campo `targetPlatform`, que e
# dado estruturado.
$temAndroid = $false
try {
    $json = (flutter devices --machine 2>$null | Out-String)
    if ($json.Trim().StartsWith("[")) {
        $lista = $json | ConvertFrom-Json
        foreach ($d in $lista) {
            if ($d.targetPlatform -and $d.targetPlatform.StartsWith("android")) {
                $temAndroid = $true
            }
        }
    }
}
catch {
    # Na duvida, assume-se que NAO ha dispositivo: e a afirmacao conservadora.
    $temAndroid = $false
}

if ($temAndroid) {
    Registar "  Dispositivo Android DETECTADO. Passam a ser possiveis:"
    Registar "    - capturas de ecra reais (docs/store/screenshots/capturar.ps1)"
    Registar "    - teste em modo de voo"
    Registar "    - verificacao da persistencia do historico em Android real"
    Registar "    - teste de acessibilidade com o TalkBack"
} else {
    Registar "  NAO EXECUTADO - nenhum dispositivo nem emulador Android disponivel:"
    Registar "    - capturas de ecra reais"
    Registar "    - teste em modo de voo"
    Registar "    - persistencia do historico em Android real"
    Registar "    - acessibilidade com o TalkBack"
    Registar "    - caracteres chineses em dispositivos sem fontes CJK"
}

Registar ""
Registar "  PENDENTE DE VALIDACAO EXTERNA (sempre, independentemente do ambiente):"
Registar "    - URL publica da Politica de Privacidade"
Registar "    - submissao do formulario Data safety na Play Console"
Registar "    - revisao da traducao chinesa por falante nativo"
Registar "    - escolha da licenca do projecto"
Registar "    - feature graphic de 1024x500"

# ------------------------------------------------------------------ resumo
Titulo "RESUMO"

foreach ($etapa in $etapas) {
    $cor = switch ($etapa.Estado) {
        "APROVADO" { "Green" }
        "FALHOU"   { "Red" }
        default    { "Yellow" }
    }
    $linha = ("  {0,-34} {1}" -f $etapa.Nome, $etapa.Estado)
    Write-Host $linha -ForegroundColor $cor
    $linhas.Add($linha)
}

$falhas = ($etapas | Where-Object { $_.Estado -eq "FALHOU" }).Count
$duracao = [math]::Round(((Get-Date) - $inicio).TotalSeconds, 1)

Registar ""
Registar "Etapas: $($etapas.Count)  |  Falhas: $falhas  |  Duracao: ${duracao}s"

if ($falhas -gt 0) {
    Registar ""
    Registar "RESULTADO: $falhas etapa(s) FALHARAM. Nao declarar sucesso."
} else {
    Registar ""
    Registar "RESULTADO: todas as etapas executaveis passaram."
    Registar "Isto NAO significa que a aplicacao esteja pronta para publicacao:"
    Registar "ver as verificacoes pendentes acima e docs/RELATORIO_FINAL_AUDITORIA.md."
}

# ---------------------------------------------------------------- relatorio
if (-not $SemRelatorio) {
    $destino = Join-Path $raiz "docs/evidence"
    New-Item -ItemType Directory -Force -Path $destino | Out-Null
    $ficheiro = Join-Path $destino ("validacao_" + $inicio.ToString("yyyy-MM-dd_HHmm") + ".txt")
    $linhas -join "`r`n" | Out-File -FilePath $ficheiro -Encoding utf8
    Write-Host ""
    Write-Host "Relatorio escrito em: $ficheiro" -ForegroundColor Cyan
}

exit $(if ($falhas -gt 0) { 1 } else { 0 })
