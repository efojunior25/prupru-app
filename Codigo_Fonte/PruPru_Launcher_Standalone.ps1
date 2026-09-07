Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$AppVersion = "1.4.0"
$UpdateRepo = "efojunior25/prupru-app"

# ------------------------------------------------------------------
# Idioma da interface - detecta pelo idioma do Windows na primeira
# vez, depois respeita a escolha manual salva em lang.txt.
# NAO traduz o conteudo interno dos relatorios de cada ferramenta,
# apenas a janela principal (titulo, botoes, avisos, rodape).
# ------------------------------------------------------------------
$langFilePath = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$SupportedLangs = @("pt", "en", "es")
$Lang = $null
if (Test-Path $langFilePath) {
    $saved = (Get-Content -Path $langFilePath -Raw -ErrorAction SilentlyContinue)
    if ($saved) { $saved = $saved.Trim() }
    if ($SupportedLangs -contains $saved) { $Lang = $saved }
}
if (-not $Lang) {
    $winLang = (Get-Culture).TwoLetterISOLanguageName
    $Lang = switch ($winLang) {
        "pt" { "pt" }
        "es" { "es" }
        default { "en" }
    }
}

function Set-PruPruLang($newLang) {
    New-Item -ItemType Directory -Path (Split-Path $langFilePath) -Force | Out-Null
    Set-Content -Path $langFilePath -Value $newLang -Encoding UTF8
    Start-Process -FilePath $exePath
    [System.Windows.Forms.Application]::Exit()
}

$Strings = @{
    pt = @{
        Subtitle          = "Conectividade Agil - Inteligencia Urbana - Eficiencia Tecnologica"
        SectionDiag       = "DIAGNOSTICO (somente leitura)"
        SectionOtim       = "OTIMIZACAO"
        SectionFoco       = "FOCO NO JOGO"
        SectionTurbo      = "TURBO DE REDE"
        SectionStream     = "MODO STREAMING"
        SectionExtras     = "PRIVACIDADE, TWEAKS E APLICATIVOS"
        BtnTweaks         = "Tweaks de Privacidade e Desempenho"
        BtnApps           = "Instalador de Aplicativos (precisa de internet)"
        BtnDiagnostico    = "Diagnostico do PC"
        BtnSaudeDisco     = "Saude do Disco"
        BtnScanner        = "Scanner de Seguranca"
        BtnTeste          = "Teste de Integridade Rapido"
        BtnBackup         = "Backup de Configuracoes"
        BtnDrivers        = "Verificador de Drivers"
        BtnOtimizador     = "Otimizador de Sistema"
        BtnReverter       = "Reverter Otimizacao"
        BtnLimpar         = "Limpar Espaco em Disco"
        BtnGerenciador    = "Gerenciador de Inicializacao"
        BtnDesinstalador  = "Desinstalador de Bloatware Guiado"
        BtnFocoOn         = "Ativar Foco no Jogo"
        BtnFocoOff        = "Desativar Foco no Jogo"
        BtnTurboOn        = "Ativar Turbo de Rede"
        BtnTurboOff       = "Desativar Turbo de Rede"
        BtnStreamOn       = "Ativar Modo Streaming"
        BtnStreamOff      = "Desativar Modo Streaming"
        LinkCheckUpdate   = "Verificar atualizacoes"
        LinkHistory       = "Ver historico de execucoes"
        LinkLang          = "Idioma"
        HistoryHeader     = "PruPru Digital Services - Historico de execucoes`r`n(nenhuma ferramenta rodada ainda)"
        ReminderNoHistory = "Ainda nao ha historico de manutencao. Que tal rodar um Diagnostico?"
        ReminderToday     = "Ultima manutencao: hoje."
        ReminderDaysAgo   = "Ultima manutencao: ha {0} dia(s)."
        ReminderOverdue   = "Ja faz {0} dias desde a ultima manutencao - que tal rodar um Diagnostico?"
        MsgFileNotFound   = "Arquivo nao encontrado:`n{0}"
        MsgUpdateTitle    = "PruPru Digital Services - Atualizacao"
        MsgUpdateAvailable= "Nova versao disponivel: v{0} (voce tem v{1}).`n`nAtualizar agora?"
        MsgAlreadyLatest  = "Voce ja esta na versao mais recente (v{0})."
        MsgUpdateCheckFailed = "Nao foi possivel verificar atualizacoes agora (sem internet ou servidor indisponivel)."
        MsgUpdateDownloadFailed = "Nao foi possivel baixar a atualizacao agora. Tente novamente mais tarde."
        MsgUpdateIntegrityFailed = "O arquivo baixado nao passou na verificacao de integridade e foi descartado por seguranca. Tente novamente mais tarde."
    }
    en = @{
        Subtitle          = "Agile Connectivity - Urban Intelligence - Technological Efficiency"
        SectionDiag       = "DIAGNOSTICS (read-only)"
        SectionOtim       = "OPTIMIZATION"
        SectionFoco       = "GAME FOCUS"
        SectionTurbo      = "NETWORK TURBO"
        SectionStream     = "STREAMING MODE"
        SectionExtras     = "PRIVACY, TWEAKS AND APPS"
        BtnTweaks         = "Privacy and Performance Tweaks"
        BtnApps           = "App Installer (needs internet)"
        BtnDiagnostico    = "PC Diagnostics"
        BtnSaudeDisco     = "Disk Health"
        BtnScanner        = "Security Scanner"
        BtnTeste          = "Quick Integrity Test"
        BtnBackup         = "Settings Backup"
        BtnDrivers        = "Driver Checker"
        BtnOtimizador     = "System Optimizer"
        BtnReverter       = "Revert Optimization"
        BtnLimpar         = "Free Up Disk Space"
        BtnGerenciador    = "Startup Manager"
        BtnDesinstalador  = "Guided Bloatware Uninstaller"
        BtnFocoOn         = "Enable Game Focus"
        BtnFocoOff        = "Disable Game Focus"
        BtnTurboOn        = "Enable Network Turbo"
        BtnTurboOff       = "Disable Network Turbo"
        BtnStreamOn       = "Enable Streaming Mode"
        BtnStreamOff      = "Disable Streaming Mode"
        LinkCheckUpdate   = "Check for updates"
        LinkHistory       = "View execution history"
        LinkLang          = "Language"
        HistoryHeader     = "PruPru Digital Services - Execution history`r`n(no tool run yet)"
        ReminderNoHistory = "No maintenance history yet. How about running a Diagnostic?"
        ReminderToday     = "Last maintenance: today."
        ReminderDaysAgo   = "Last maintenance: {0} day(s) ago."
        ReminderOverdue   = "It's been {0} days since the last maintenance - how about running a Diagnostic?"
        MsgFileNotFound   = "File not found:`n{0}"
        MsgUpdateTitle    = "PruPru Digital Services - Update"
        MsgUpdateAvailable= "New version available: v{0} (you have v{1}).`n`nUpdate now?"
        MsgAlreadyLatest  = "You're already on the latest version (v{0})."
        MsgUpdateCheckFailed = "Couldn't check for updates right now (no internet or server unavailable)."
        MsgUpdateDownloadFailed = "Couldn't download the update right now. Please try again later."
        MsgUpdateIntegrityFailed = "The downloaded file failed the integrity check and was discarded for safety. Please try again later."
    }
    es = @{
        Subtitle          = "Conectividad Agil - Inteligencia Urbana - Eficiencia Tecnologica"
        SectionDiag       = "DIAGNOSTICO (solo lectura)"
        SectionOtim       = "OPTIMIZACION"
        SectionFoco       = "ENFOQUE EN EL JUEGO"
        SectionTurbo      = "TURBO DE RED"
        SectionStream     = "MODO STREAMING"
        SectionExtras     = "PRIVACIDAD, AJUSTES Y APLICACIONES"
        BtnTweaks         = "Ajustes de Privacidad y Rendimiento"
        BtnApps           = "Instalador de Aplicaciones (necesita internet)"
        BtnDiagnostico    = "Diagnostico del PC"
        BtnSaudeDisco     = "Salud del Disco"
        BtnScanner        = "Escaner de Seguridad"
        BtnTeste          = "Prueba de Integridad Rapida"
        BtnBackup         = "Copia de Seguridad de Configuracion"
        BtnDrivers        = "Verificador de Controladores"
        BtnOtimizador     = "Optimizador del Sistema"
        BtnReverter       = "Revertir Optimizacion"
        BtnLimpar         = "Liberar Espacio en Disco"
        BtnGerenciador    = "Administrador de Inicio"
        BtnDesinstalador  = "Desinstalador Guiado de Bloatware"
        BtnFocoOn         = "Activar Enfoque en el Juego"
        BtnFocoOff        = "Desactivar Enfoque en el Juego"
        BtnTurboOn        = "Activar Turbo de Red"
        BtnTurboOff       = "Desactivar Turbo de Red"
        BtnStreamOn       = "Activar Modo Streaming"
        BtnStreamOff      = "Desactivar Modo Streaming"
        LinkCheckUpdate   = "Buscar actualizaciones"
        LinkHistory       = "Ver historial de ejecuciones"
        LinkLang          = "Idioma"
        HistoryHeader     = "PruPru Digital Services - Historial de ejecuciones`r`n(ninguna herramienta ejecutada todavia)"
        ReminderNoHistory = "Todavia no hay historial de mantenimiento. Que tal ejecutar un Diagnostico?"
        ReminderToday     = "Ultimo mantenimiento: hoy."
        ReminderDaysAgo   = "Ultimo mantenimiento: hace {0} dia(s)."
        ReminderOverdue   = "Ya pasaron {0} dias desde el ultimo mantenimiento - que tal ejecutar un Diagnostico?"
        MsgFileNotFound   = "Archivo no encontrado:`n{0}"
        MsgUpdateTitle    = "PruPru Digital Services - Actualizacion"
        MsgUpdateAvailable= "Nueva version disponible: v{0} (tienes v{1}).`n`nActualizar ahora?"
        MsgAlreadyLatest  = "Ya tienes la version mas reciente (v{0})."
        MsgUpdateCheckFailed = "No se pudo buscar actualizaciones ahora (sin internet o servidor no disponible)."
        MsgUpdateDownloadFailed = "No se pudo descargar la actualizacion ahora. Intenta de nuevo mas tarde."
        MsgUpdateIntegrityFailed = "El archivo descargado no paso la verificacion de integridad y fue descartado por seguridad. Intenta de nuevo mas tarde."
    }
}
$L = $Strings[$Lang]

try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 } catch { }

$exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName

# ------------------------------------------------------------------
# Atualizacao automatica (GitHub Releases) - falha silenciosa, nunca
# impede o app de abrir se nao houver internet.
# ------------------------------------------------------------------
function Do-Update($DownloadUrl, $ExpectedSha256) {
    try {
        $newExePath = Join-Path $env:TEMP "PruPru_new.exe"
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $newExePath -UseBasicParsing -TimeoutSec 30

        if ($ExpectedSha256) {
            $actualHash = (Get-FileHash -Path $newExePath -Algorithm SHA256).Hash
            if ($actualHash.ToLower() -ne $ExpectedSha256.ToLower()) {
                Remove-Item -Path $newExePath -Force -ErrorAction SilentlyContinue
                [System.Windows.Forms.MessageBox]::Show($L.MsgUpdateIntegrityFailed, "PruPru Digital Services", 'OK', 'Warning') | Out-Null
                return
            }
        }

        $updaterLines = @(
            '@echo off',
            'title PruPru Digital Services - Atualizando...',
            'echo Atualizando o PruPru Digital Services, aguarde...',
            'timeout /t 2 /nobreak',
            ('copy /y "{0}" "{1}"' -f $newExePath, $exePath),
            'echo Atualizacao concluida. Abrindo o PruPru...',
            'timeout /t 1 /nobreak',
            ('start "" "{0}"' -f $exePath),
            'exit'
        )
        $updaterPath = Join-Path $env:TEMP "PruPru_updater.bat"
        Set-Content -Path $updaterPath -Value $updaterLines -Encoding ASCII
        Start-Process -FilePath $updaterPath
        [System.Windows.Forms.Application]::Exit()
    } catch {
        [System.Windows.Forms.MessageBox]::Show($L.MsgUpdateDownloadFailed, "PruPru Digital Services", 'OK', 'Warning') | Out-Null
    }
}

function Check-ForUpdate([switch]$Silent) {
    try {
        $api = "https://api.github.com/repos/$UpdateRepo/releases/latest"
        $headers = @{ 'User-Agent' = 'PruPru-App' }
        $release = Invoke-RestMethod -Uri $api -Headers $headers -TimeoutSec 5 -ErrorAction Stop
        $latestVersion = ($release.tag_name -replace '^v','')
        if ([version]$latestVersion -gt [version]$AppVersion) {
            $asset = $release.assets | Where-Object { $_.name -eq 'PruPru.exe' } | Select-Object -First 1
            if ($asset) {
                $result = [System.Windows.Forms.MessageBox]::Show(
                    ($L.MsgUpdateAvailable -f $latestVersion, $AppVersion),
                    $L.MsgUpdateTitle,
                    'YesNo', 'Information')
                if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                    $expectedHash = $null
                    if ($asset.digest -and $asset.digest -like 'sha256:*') {
                        $expectedHash = $asset.digest.Substring(7)
                    }
                    Do-Update $asset.browser_download_url $expectedHash
                }
                return
            }
        }
        if (-not $Silent) {
            [System.Windows.Forms.MessageBox]::Show(($L.MsgAlreadyLatest -f $AppVersion), "PruPru Digital Services", 'OK', 'Information') | Out-Null
        }
    } catch {
        if (-not $Silent) {
            [System.Windows.Forms.MessageBox]::Show($L.MsgUpdateCheckFailed, "PruPru Digital Services", 'OK', 'Warning') | Out-Null
        }
    }
}

# ------------------------------------------------------------------
# Scripts embutidos (extraidos para uma pasta temporaria ao iniciar)
# ------------------------------------------------------------------
$Scripts = @{}
$Scripts['PruPru_BackupConfig.bat'] = @'
@echo off
title PruPru Digital Services - Backup de Configuracoes
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Backup de Configuracoes (SOMENTE LEITURA)
:: Salva um registro do que esta configurado agora (energia,
:: DNS, servicos, TCP). Nao restaura nada sozinho -- e um
:: registro de consulta.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Settings Backup
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SETTINGS BACKUP
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Copia de Seguridad de Configuracion
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - COPIA DE SEGURIDAD DE CONFIGURACION
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Backup de Configuracoes
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - BACKUP DE CONFIGURACOES
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_BackupConfig.ps1"

echo.
pause
'@

$Scripts['PruPru_BackupConfig.ps1'] = @'
# PruPru Digital Services - Backup de Configuracoes (somente leitura)
# Tira uma "foto" do que esta configurado agora, antes de qualquer
# ajuste. Nao restaura nada sozinho -- e um registro para consulta,
# e para reforcar transparencia com o cliente sobre o que foi mexido.

$ErrorActionPreference = 'SilentlyContinue'

# Evita mojibake ao capturar saida de comandos nativos (powercfg, netsh)
try {
    chcp 65001 | Out-Null
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
} catch { }

$report = @()
function Add-Line($text) { $script:report += $text }

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        HtmlLang = "pt-BR"; Title = "Backup de Configuracoes"
        Generated = "{0} - Gerado em {1} - Relatorio informativo, nada foi alterado"
        Passo1 = "[1/5] Plano de energia..."; Passo2 = "[2/5] DNS dos adaptadores..."
        Passo3 = "[3/5] Servicos (SysMain / DiagTrack)..."; Passo4 = "[4/5] Valores de registro (multimidia/agendador)..."
        Passo5 = "[5/5] Parametros globais de TCP..."
        SecEnergia = "PLANO DE ENERGIA"; SecDns = "DNS POR ADAPTADOR"; SecServicos = "SERVICOS"
        SecRegistro = "REGISTRO: PRIORIDADE DE JOGOS/MULTIMIDIA"; SecTcp = "TCP (saida bruta do Windows, netsh int tcp show global)"
        DnsAuto = "(automatico / DHCP)"; DnsErro = "Nao foi possivel ler (sem permissao ou nenhum adaptador ativo)."
        ServicoLinha = "{0} -> Status: {1} | Inicializacao: {2}"; ServicoAusente = "{0} -> nao encontrado neste Windows"
        RegDefinido = "{0} = {1} (0x{2})"; RegPadrao = "{0} = nao definido (usando padrao do Windows)"
        Concluido = "BACKUP CONCLUIDO"; ArquivoSalvo = "Arquivo salvo em:"
        Rodape1 = "Este arquivo e so um registro para consulta -- nao"
        Rodape2 = "restaura nada automaticamente. Para desfazer mudancas"
        Rodape3 = "reais, use o Reverter Otimizacao, Desativar Foco no"
        Rodape4 = "Jogo ou Desativar Turbo de Rede no painel."
    }
    en = @{
        HtmlLang = "en"; Title = "Settings Backup"
        Generated = "{0} - Generated on {1} - Informational report, nothing was changed"
        Passo1 = "[1/5] Power plan..."; Passo2 = "[2/5] Adapter DNS settings..."
        Passo3 = "[3/5] Services (SysMain / DiagTrack)..."; Passo4 = "[4/5] Registry values (multimedia/scheduler)..."
        Passo5 = "[5/5] Global TCP parameters..."
        SecEnergia = "POWER PLAN"; SecDns = "DNS PER ADAPTER"; SecServicos = "SERVICES"
        SecRegistro = "REGISTRY: GAMES/MULTIMEDIA PRIORITY"; SecTcp = "TCP (raw Windows output, netsh int tcp show global)"
        DnsAuto = "(automatic / DHCP)"; DnsErro = "Couldn't read it (no permission or no active adapter)."
        ServicoLinha = "{0} -> Status: {1} | Startup type: {2}"; ServicoAusente = "{0} -> not found on this Windows"
        RegDefinido = "{0} = {1} (0x{2})"; RegPadrao = "{0} = not set (using Windows default)"
        Concluido = "BACKUP COMPLETE"; ArquivoSalvo = "File saved to:"
        Rodape1 = "This file is just a reference record -- it doesn't"
        Rodape2 = "restore anything automatically. To undo real changes,"
        Rodape3 = "use Revert Optimization, Disable Game Focus or"
        Rodape4 = "Disable Network Turbo in the panel."
    }
    es = @{
        HtmlLang = "es"; Title = "Copia de Seguridad de Configuracion"
        Generated = "{0} - Generado el {1} - Informe informativo, no se cambio nada"
        Passo1 = "[1/5] Plan de energia..."; Passo2 = "[2/5] DNS de los adaptadores..."
        Passo3 = "[3/5] Servicios (SysMain / DiagTrack)..."; Passo4 = "[4/5] Valores del registro (multimedia/programador)..."
        Passo5 = "[5/5] Parametros globales de TCP..."
        SecEnergia = "PLAN DE ENERGIA"; SecDns = "DNS POR ADAPTADOR"; SecServicos = "SERVICIOS"
        SecRegistro = "REGISTRO: PRIORIDAD DE JUEGOS/MULTIMEDIA"; SecTcp = "TCP (salida en bruto de Windows, netsh int tcp show global)"
        DnsAuto = "(automatico / DHCP)"; DnsErro = "No se pudo leer (sin permiso o ningun adaptador activo)."
        ServicoLinha = "{0} -> Estado: {1} | Inicio: {2}"; ServicoAusente = "{0} -> no encontrado en este Windows"
        RegDefinido = "{0} = {1} (0x{2})"; RegPadrao = "{0} = no definido (usando el valor predeterminado de Windows)"
        Concluido = "COPIA DE SEGURIDAD COMPLETADA"; ArquivoSalvo = "Archivo guardado en:"
        Rodape1 = "Este archivo es solo un registro de consulta -- no"
        Rodape2 = "restaura nada automaticamente. Para deshacer cambios"
        Rodape3 = "reales, usa Revertir Optimizacion, Desactivar Enfoque"
        Rodape4 = "en el Juego o Desactivar Turbo de Red en el panel."
    }
}[$Lang2]

function ConvertTo-PruPruHtml($titulo, $lines) {
    function EscapeHtml($s) { $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }
    $bodyHtml = ($lines | ForEach-Object {
        $line = $_
        if ($line -match '^--(.+)--$') {
            "<h3>$(EscapeHtml $Matches[1].Trim())</h3>"
        } elseif ($line -match '\[(ALERTA|ATENCAO|WARNING|ATENCION)\]') {
            "<p class='alerta'>$(EscapeHtml $line)</p>"
        } elseif ($line -eq '') {
            "<div class='spacer'></div>"
        } else {
            "<p>$(EscapeHtml $line)</p>"
        }
    }) -join "`n"
    @"
<!DOCTYPE html>
<html lang="$($T.HtmlLang)">
<head>
<meta charset="UTF-8">
<title>$titulo - PruPru Digital Services</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700&family=Montserrat:wght@400;600&display=swap');
  body { font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; background:#F7F9FB; color:#0B1F3A; margin:0; padding:0; }
  .header { background:#00205A; color:#fff; padding:24px 32px; }
  .header h1 { margin:0; font-size:22px; font-family:'Space Grotesk', sans-serif; }
  .header p { margin:4px 0 0; font-size:13px; opacity:0.85; }
  .content { max-width:720px; margin:24px auto; background:#fff; border-radius:8px; padding:24px 32px; box-shadow:0 1px 4px rgba(0,32,90,0.08); }
  h3 { color:#00205A; font-family:'Space Grotesk', sans-serif; border-bottom:2px solid #349CFA; padding-bottom:6px; margin-top:28px; }
  p { margin:4px 0; font-size:14px; line-height:1.5; white-space:pre-wrap; }
  .alerta { color:#B00020; font-weight:600; background:#FDECEC; padding:6px 10px; border-radius:4px; }
  .spacer { height:8px; }
  .footer { text-align:center; color:#8a8f98; font-size:12px; margin:24px 0 40px; }
</style>
</head>
<body>
  <div class="header">
    <h1>PruPru Digital Services</h1>
    <p>$($T.Generated -f $titulo, (Get-Date -Format 'dd/MM/yyyy HH:mm'))</p>
  </div>
  <div class="content">
$bodyHtml
  </div>
  <div class="footer">prupru.org</div>
</body>
</html>
"@
}

Write-Host $T.Passo1
Add-Line "-- $($T.SecEnergia) --"
$scheme = powercfg /getactivescheme
Add-Line "$scheme"
Add-Line ""

Write-Host $T.Passo2
Add-Line "-- $($T.SecDns) --"
try {
    Get-DnsClientServerAddress -AddressFamily IPv4 -ErrorAction Stop | ForEach-Object {
        $servers = if ($_.ServerAddresses) { $_.ServerAddresses -join ', ' } else { $T.DnsAuto }
        Add-Line "$($_.InterfaceAlias): $servers"
    }
} catch {
    Add-Line $T.DnsErro
}
Add-Line ""

Write-Host $T.Passo3
Add-Line "-- $($T.SecServicos) --"
foreach ($svc in @('SysMain','DiagTrack')) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if ($s) {
        Add-Line ($T.ServicoLinha -f $svc, $s.Status, $s.StartType)
    } else {
        Add-Line ($T.ServicoAusente -f $svc)
    }
}
Add-Line ""

Write-Host $T.Passo4
Add-Line "-- $($T.SecRegistro) --"
$mmPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
foreach ($val in @('NetworkThrottlingIndex','SystemResponsiveness')) {
    $v = Get-ItemProperty -Path $mmPath -Name $val -ErrorAction SilentlyContinue
    if ($v) {
        Add-Line ($T.RegDefinido -f $val, $v.$val, ('{0:X}' -f $v.$val))
    } else {
        Add-Line ($T.RegPadrao -f $val)
    }
}
Add-Line ""

Write-Host $T.Passo5
Add-Line "-- $($T.SecTcp) --"
$tcpGlobal = netsh int tcp show global
Add-Line ($tcpGlobal -join "`r`n")
Add-Line ""

$desktopPath = [Environment]::GetFolderPath('Desktop')
$reportPath = Join-Path $desktopPath "PruPru_Backup_Config_$(Get-Date -Format 'yyyyMMdd_HHmm').html"
ConvertTo-PruPruHtml $T.Title $report | Out-File -FilePath $reportPath -Encoding UTF8
Start-Process $reportPath

Write-Host ""
Write-Host "=================================================="
Write-Host "  $($T.Concluido)"
Write-Host "  $($T.ArquivoSalvo)"
Write-Host "  $reportPath"
Write-Host "=================================================="
Write-Host ""
Write-Host $T.Rodape1
Write-Host $T.Rodape2
Write-Host $T.Rodape3
Write-Host $T.Rodape4
'@

$Scripts['PruPru_DesinstaladorGuiado.bat'] = @'
@echo off
title PruPru Digital Services - Desinstalador Guiado
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Desinstalador de Bloatware Guiado
:: Lista programas por tamanho e aciona o desinstalador OFICIAL
:: de cada um -- nunca apaga arquivos por conta propria.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Guided Uninstaller
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Desinstalador Guiado
) else (
    title PruPru Digital Services - Desinstalador Guiado
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_DesinstaladorGuiado.ps1"

pause
'@

$Scripts['PruPru_DesinstaladorGuiado.ps1'] = @'
# PruPru Digital Services - Desinstalador de Bloatware Guiado
# Lista os programas instalados ordenados por tamanho e deixa o
# usuario escolher o que desinstalar. NUNCA apaga arquivos por
# conta propria -- sempre aciona o desinstalador oficial do
# proprio programa (o mesmo que o Windows usaria).

$ErrorActionPreference = 'SilentlyContinue'

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        ColHeader = " #   TAMANHO     NOME"
        Banner1 = "PRUPRU DIGITAL SERVICES - DESINSTALADOR GUIADO"
        Banner2 = "Lista ordenada por espaco ocupado. Ao escolher um item, abrimos"
        Banner3 = "o desinstalador OFICIAL do proprio programa -- nada e apagado"
        Banner4 = "na forca. Voce confirma e conduz a desinstalacao normalmente."
        Nenhum = "Nenhum programa desinstalavel encontrado."
        Prompt = "Digite o numero do programa para desinstalar (ou 0 para sair)"
        Invalido = "Numero invalido."
        Escolheu = "Voce escolheu: {0}"
        ConfirmPrompt = "Abrir o desinstalador oficial deste programa agora? (S/N)"
        ConfirmRegex = '^[Ss]$'
        Cancelado = "Cancelado."
        Abrindo = "Abrindo desinstalador... siga as instrucoes na tela do proprio programa."
        Fechado = "Desinstalador foi fechado. Atualizando lista..."
        Falhou = "Nao foi possivel iniciar o desinstalador deste programa."
        Tchau = "Ate mais! prupru.org"
    }
    en = @{
        ColHeader = " #   SIZE        NAME"
        Banner1 = "PRUPRU DIGITAL SERVICES - GUIDED UNINSTALLER"
        Banner2 = "List sorted by space used. When you pick an item, we open"
        Banner3 = "that program's OFFICIAL uninstaller -- nothing is force-deleted."
        Banner4 = "You confirm and run the uninstall as usual."
        Nenhum = "No uninstallable programs found."
        Prompt = "Enter the program number to uninstall (or 0 to exit)"
        Invalido = "Invalid number."
        Escolheu = "You picked: {0}"
        ConfirmPrompt = "Open this program's official uninstaller now? (Y/N)"
        ConfirmRegex = '^[Yy]$'
        Cancelado = "Cancelled."
        Abrindo = "Opening uninstaller... follow the instructions on the program's own screen."
        Fechado = "Uninstaller was closed. Refreshing the list..."
        Falhou = "Couldn't start this program's uninstaller."
        Tchau = "See you later! prupru.org"
    }
    es = @{
        ColHeader = " #   TAMANO      NOMBRE"
        Banner1 = "PRUPRU DIGITAL SERVICES - DESINSTALADOR GUIADO"
        Banner2 = "Lista ordenada por espacio ocupado. Al elegir un elemento, abrimos"
        Banner3 = "el desinstalador OFICIAL del propio programa -- no se elimina nada"
        Banner4 = "a la fuerza. Tu confirmas y llevas adelante la desinstalacion."
        Nenhum = "No se encontraron programas desinstalables."
        Prompt = "Escribe el numero del programa a desinstalar (o 0 para salir)"
        Invalido = "Numero invalido."
        Escolheu = "Elegiste: {0}"
        ConfirmPrompt = "Abrir el desinstalador oficial de este programa ahora? (S/N)"
        ConfirmRegex = '^[Ss]$'
        Cancelado = "Cancelado."
        Abrindo = "Abriendo desinstalador... sigue las instrucciones en la pantalla del propio programa."
        Fechado = "El desinstalador se cerro. Actualizando la lista..."
        Falhou = "No se pudo iniciar el desinstalador de este programa."
        Tchau = "Hasta luego! prupru.org"
    }
}[$Lang2]

function Get-InstalledPrograms {
    $paths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'
    )
    $apps = foreach ($path in $paths) {
        Get-ItemProperty -Path $path -ErrorAction SilentlyContinue | Where-Object {
            $_.DisplayName -and
            -not $_.SystemComponent -and
            -not $_.ParentKeyName -and
            $_.UninstallString
        }
    }
    $apps |
        Group-Object DisplayName |
        ForEach-Object { $_.Group | Select-Object -First 1 } |
        Sort-Object -Property @{Expression = { [int64]($_.EstimatedSize) }; Descending = $true }
}

function Show-List($apps) {
    Write-Host ""
    Write-Host "===================================================================="
    Write-Host $T.ColHeader
    Write-Host "===================================================================="
    $i = 1
    foreach ($app in $apps) {
        $sizeText = if ($app.EstimatedSize) {
            $mb = [math]::Round($app.EstimatedSize / 1024, 0)
            if ($mb -ge 1024) { "{0:N1} GB" -f ($mb/1024) } else { "$mb MB" }
        } else { "?" }
        "{0,-4} {1,-11} {2}" -f $i, $sizeText, $app.DisplayName | Write-Host
        if ($app.Publisher) { Write-Host "              ($($app.Publisher))" -ForegroundColor DarkGray }
        $i++
    }
    Write-Host "===================================================================="
}

Write-Host "===================================================================="
Write-Host "  $($T.Banner1)"
Write-Host "  $($T.Banner2)"
Write-Host "  $($T.Banner3)"
Write-Host "  $($T.Banner4)"
Write-Host "===================================================================="

$running = $true
while ($running) {
    $apps = @(Get-InstalledPrograms)
    if ($apps.Count -eq 0) {
        Write-Host $T.Nenhum
        break
    }
    Show-List $apps
    Write-Host ""
    $choice = Read-Host $T.Prompt
    if ($choice -eq '0' -or $choice -eq '') { $running = $false; break }
    if ($choice -notmatch '^\d+$' -or [int]$choice -lt 1 -or [int]$choice -gt $apps.Count) {
        Write-Host $T.Invalido -ForegroundColor Red
        continue
    }
    $selected = $apps[[int]$choice - 1]
    Write-Host ""
    Write-Host ($T.Escolheu -f $selected.DisplayName) -ForegroundColor Yellow
    $confirm = Read-Host $T.ConfirmPrompt
    if ($confirm -notmatch $T.ConfirmRegex) {
        Write-Host $T.Cancelado
        continue
    }

    $uninstallCmd = $selected.UninstallString
    Write-Host $T.Abrindo
    try {
        Start-Process -FilePath "cmd.exe" -ArgumentList "/c", $uninstallCmd -Wait
        Write-Host $T.Fechado -ForegroundColor Green
    } catch {
        Write-Host $T.Falhou -ForegroundColor Red
    }
}

Write-Host ""
Write-Host $T.Tchau
'@

$Scripts['PruPru_Diagnostico.bat'] = @'
@echo off
title PruPru Digital Services - Diagnostico do PC
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Diagnostico do PC (SOMENTE LEITURA)
:: Nao altera nada. Gera um relatorio completo na Area de
:: Trabalho com specs, saude de disco, espaco livre, updates
:: pendentes e erros recentes.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - PC Diagnostics
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - PC DIAGNOSTICS
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Diagnostico del PC
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DIAGNOSTICO DEL PC
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Diagnostico do PC
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DIAGNOSTICO DO PC
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_Diagnostico.ps1"

echo.
pause
'@

$Scripts['PruPru_Diagnostico.ps1'] = @'
# PruPru Digital Services - Diagnostico do PC (somente leitura)
# Nao altera nada no sistema. Apenas coleta informacoes e gera um relatorio.

$ErrorActionPreference = 'SilentlyContinue'
$report = @()
$flags = @()

# Idioma - le a escolha salva pelo painel principal (mesmo arquivo usado
# pela janela do PruPru.exe). Sem arquivo -> portugues como padrao.
$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        HtmlLang = "pt-BR"; Title = "Diagnostico do PC"
        Generated = "{0} - Gerado em {1} - Relatorio informativo, nada foi alterado"
        SecSistema = "SISTEMA"; SecGPU = "PLACA DE VIDEO"; SecDiscos = "DISCOS"
        SecInit = "INICIALIZACAO"; SecUpdate = "WINDOWS UPDATE"; SecEventos = "EVENTOS CRITICOS (ultimos 7 dias, log Sistema)"
        SecResumo = "RESUMO / PONTOS DE ATENCAO"
        Computador = "Computador: {0} {1}"; Windows = "Windows: {0} (Build {1})"
        Ligado = "Ligado ha: {0}h {1}min"; Processador = "Processador: {0}"
        Ram = "RAM: {0} GB livres de {1} GB ({2}% em uso)"
        RamFlag = "RAM em uso muito alto ({0}%) - considere fechar programas ou aumentar a memoria."
        Gpu = "GPU: {0}"
        Disco = "{0} {1} GB livres de {2} GB ({3}% livre)"
        DiscoFlag = "Disco {0} com menos de 10% de espaco livre - risco de lentidao e falhas de atualizacao."
        DiscoFisico = "Disco fisico: {0} - Tipo: {1} - Saude: {2}"
        DiscoFisicoFlag = "Disco {0} reportando saude '{1}' - rode o PruPru_SaudeDisco.bat para detalhes."
        RegItens = "Itens no registro (Run): {0}"; StartupAtalhos = "Atalhos na pasta Startup: {0}"
        StartupFlag = "Muitos itens iniciando com o Windows ({0}) - rode o PruPru_GerenciadorInicializacao.bat para revisar."
        UpdatesPend = "Atualizacoes pendentes: {0}"
        UpdatesFlag = "{0} atualizacoes do Windows pendentes - instale para manter seguranca e estabilidade."
        UpdateFalhou = "Nao foi possivel verificar (servico do Windows Update pode estar desativado)."
        SemEventos = "Nenhum evento critico encontrado."
        EventosFlag = "Varios erros criticos nos ultimos 7 dias - pode indicar driver ou hardware com problema."
        ResumoOk = "Nenhum ponto critico encontrado. Sistema em condicao normal."
        ResumoFlag = "[ATENCAO] {0}"
        Passo1 = "[1/6] Coletando dados do sistema..."; Passo2 = "[2/6] Verificando GPU..."
        Passo3 = "[3/6] Verificando discos e espaco livre..."; Passo4 = "[4/6] Verificando itens de inicializacao..."
        Passo5 = "[5/6] Verificando atualizacoes pendentes do Windows..."; Passo6 = "[6/6] Verificando erros recentes no sistema..."
        Concluido = "DIAGNOSTICO CONCLUIDO"; Salvo = "Relatorio salvo em:"; Pontos = "Pontos de atencao encontrados:"
    }
    en = @{
        HtmlLang = "en"; Title = "PC Diagnostics"
        Generated = "{0} - Generated on {1} - Informational report, nothing was changed"
        SecSistema = "SYSTEM"; SecGPU = "GRAPHICS CARD"; SecDiscos = "DISKS"
        SecInit = "STARTUP"; SecUpdate = "WINDOWS UPDATE"; SecEventos = "CRITICAL EVENTS (last 7 days, System log)"
        SecResumo = "SUMMARY / POINTS OF ATTENTION"
        Computador = "Computer: {0} {1}"; Windows = "Windows: {0} (Build {1})"
        Ligado = "Uptime: {0}h {1}min"; Processador = "Processor: {0}"
        Ram = "RAM: {0} GB free of {1} GB ({2}% in use)"
        RamFlag = "RAM usage very high ({0}%) - consider closing programs or upgrading memory."
        Gpu = "GPU: {0}"
        Disco = "{0} {1} GB free of {2} GB ({3}% free)"
        DiscoFlag = "Disk {0} has less than 10% free space - risk of slowdowns and update failures."
        DiscoFisico = "Physical disk: {0} - Type: {1} - Health: {2}"
        DiscoFisicoFlag = "Disk {0} reporting health '{1}' - run PruPru_SaudeDisco.bat for details."
        RegItens = "Registry items (Run): {0}"; StartupAtalhos = "Startup folder shortcuts: {0}"
        StartupFlag = "Too many items starting with Windows ({0}) - run PruPru_GerenciadorInicializacao.bat to review."
        UpdatesPend = "Pending updates: {0}"
        UpdatesFlag = "{0} pending Windows updates - install them to keep security and stability."
        UpdateFalhou = "Could not check (Windows Update service might be disabled)."
        SemEventos = "No critical events found."
        EventosFlag = "Several critical errors in the last 7 days - may indicate a driver or hardware issue."
        ResumoOk = "No critical points found. System in normal condition."
        ResumoFlag = "[WARNING] {0}"
        Passo1 = "[1/6] Collecting system data..."; Passo2 = "[2/6] Checking GPU..."
        Passo3 = "[3/6] Checking disks and free space..."; Passo4 = "[4/6] Checking startup items..."
        Passo5 = "[5/6] Checking pending Windows updates..."; Passo6 = "[6/6] Checking recent system errors..."
        Concluido = "DIAGNOSTICS COMPLETE"; Salvo = "Report saved to:"; Pontos = "Points of attention found:"
    }
    es = @{
        HtmlLang = "es"; Title = "Diagnostico del PC"
        Generated = "{0} - Generado el {1} - Informe informativo, no se cambio nada"
        SecSistema = "SISTEMA"; SecGPU = "TARJETA GRAFICA"; SecDiscos = "DISCOS"
        SecInit = "INICIO"; SecUpdate = "WINDOWS UPDATE"; SecEventos = "EVENTOS CRITICOS (ultimos 7 dias, registro Sistema)"
        SecResumo = "RESUMEN / PUNTOS DE ATENCION"
        Computador = "Equipo: {0} {1}"; Windows = "Windows: {0} (Build {1})"
        Ligado = "Encendido hace: {0}h {1}min"; Processador = "Procesador: {0}"
        Ram = "RAM: {0} GB libres de {1} GB ({2}% en uso)"
        RamFlag = "Uso de RAM muy alto ({0}%) - considera cerrar programas o ampliar la memoria."
        Gpu = "GPU: {0}"
        Disco = "{0} {1} GB libres de {2} GB ({3}% libre)"
        DiscoFlag = "El disco {0} tiene menos del 10% de espacio libre - riesgo de lentitud y fallos de actualizacion."
        DiscoFisico = "Disco fisico: {0} - Tipo: {1} - Salud: {2}"
        DiscoFisicoFlag = "El disco {0} reporta salud '{1}' - ejecuta PruPru_SaudeDisco.bat para mas detalles."
        RegItens = "Elementos en el registro (Run): {0}"; StartupAtalhos = "Accesos directos en la carpeta Startup: {0}"
        StartupFlag = "Demasiados elementos inician con Windows ({0}) - ejecuta PruPru_GerenciadorInicializacao.bat para revisar."
        UpdatesPend = "Actualizaciones pendientes: {0}"
        UpdatesFlag = "{0} actualizaciones de Windows pendientes - instalalas para mantener seguridad y estabilidad."
        UpdateFalhou = "No se pudo verificar (el servicio de Windows Update podria estar desactivado)."
        SemEventos = "No se encontraron eventos criticos."
        EventosFlag = "Varios errores criticos en los ultimos 7 dias - puede indicar un problema de controlador o hardware."
        ResumoOk = "No se encontraron puntos criticos. Sistema en condicion normal."
        ResumoFlag = "[ATENCION] {0}"
        Passo1 = "[1/6] Recopilando datos del sistema..."; Passo2 = "[2/6] Verificando GPU..."
        Passo3 = "[3/6] Verificando discos y espacio libre..."; Passo4 = "[4/6] Verificando elementos de inicio..."
        Passo5 = "[5/6] Verificando actualizaciones pendientes de Windows..."; Passo6 = "[6/6] Verificando errores recientes del sistema..."
        Concluido = "DIAGNOSTICO COMPLETADO"; Salvo = "Informe guardado en:"; Pontos = "Puntos de atencion encontrados:"
    }
}[$Lang2]

function Add-Line($text) { $script:report += $text }

function ConvertTo-PruPruHtml($titulo, $lines) {
    function EscapeHtml($s) { $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }
    $bodyHtml = ($lines | ForEach-Object {
        $line = $_
        if ($line -match '^--(.+)--$') {
            "<h3>$(EscapeHtml $Matches[1].Trim())</h3>"
        } elseif ($line -match '\[(ALERTA|ATENCAO|WARNING|ATENCION)\]') {
            "<p class='alerta'>$(EscapeHtml $line)</p>"
        } elseif ($line -eq '') {
            "<div class='spacer'></div>"
        } else {
            "<p>$(EscapeHtml $line)</p>"
        }
    }) -join "`n"
    @"
<!DOCTYPE html>
<html lang="$($T.HtmlLang)">
<head>
<meta charset="UTF-8">
<title>$titulo - PruPru Digital Services</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700&family=Montserrat:wght@400;600&display=swap');
  body { font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; background:#F7F9FB; color:#0B1F3A; margin:0; padding:0; }
  .header { background:#00205A; color:#fff; padding:24px 32px; }
  .header h1 { margin:0; font-size:22px; font-family:'Space Grotesk', sans-serif; }
  .header p { margin:4px 0 0; font-size:13px; opacity:0.85; }
  .content { max-width:720px; margin:24px auto; background:#fff; border-radius:8px; padding:24px 32px; box-shadow:0 1px 4px rgba(0,32,90,0.08); }
  h3 { color:#00205A; font-family:'Space Grotesk', sans-serif; border-bottom:2px solid #349CFA; padding-bottom:6px; margin-top:28px; }
  p { margin:4px 0; font-size:14px; line-height:1.5; white-space:pre-wrap; }
  .alerta { color:#B00020; font-weight:600; background:#FDECEC; padding:6px 10px; border-radius:4px; }
  .spacer { height:8px; }
  .footer { text-align:center; color:#8a8f98; font-size:12px; margin:24px 0 40px; }
</style>
</head>
<body>
  <div class="header">
    <h1>PruPru Digital Services</h1>
    <p>$($T.Generated -f $titulo, (Get-Date -Format 'dd/MM/yyyy HH:mm'))</p>
  </div>
  <div class="content">
$bodyHtml
  </div>
  <div class="footer">prupru.org</div>
</body>
</html>
"@
}

Write-Host $T.Passo1
$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$uptime = (Get-Date) - $os.LastBootUpTime

Add-Line "-- $($T.SecSistema) --"
Add-Line ($T.Computador -f $cs.Manufacturer, $cs.Model)
Add-Line ($T.Windows -f $os.Caption, $os.BuildNumber)
Add-Line ($T.Ligado -f [math]::Floor($uptime.TotalHours), $uptime.Minutes)
Add-Line ($T.Processador -f $cpu.Name)
$ramTotalGB = [math]::Round($os.TotalVisibleMemorySize/1MB,1)
$ramFreeGB = [math]::Round($os.FreePhysicalMemory/1MB,1)
$ramPct = [math]::Round((($ramTotalGB-$ramFreeGB)/$ramTotalGB)*100,0)
Add-Line ($T.Ram -f $ramFreeGB, $ramTotalGB, $ramPct)
if ($ramPct -ge 90) { $flags += ($T.RamFlag -f $ramPct) }
Add-Line ""

Write-Host $T.Passo2
Add-Line "-- $($T.SecGPU) --"
Get-CimInstance Win32_VideoController | ForEach-Object { Add-Line ($T.Gpu -f $_.Name) }
Add-Line ""

Write-Host $T.Passo3
Add-Line "-- $($T.SecDiscos) --"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $totalGB = [math]::Round($_.Size/1GB,1)
    $freeGB = [math]::Round($_.FreeSpace/1GB,1)
    $pctFree = if ($totalGB -gt 0) { [math]::Round(($freeGB/$totalGB)*100,0) } else { 0 }
    Add-Line ($T.Disco -f $_.DeviceID, $freeGB, $totalGB, $pctFree)
    if ($pctFree -le 10) { $flags += ($T.DiscoFlag -f $_.DeviceID) }
}
Get-PhysicalDisk | ForEach-Object {
    Add-Line ($T.DiscoFisico -f $_.FriendlyName, $_.MediaType, $_.HealthStatus)
    if ($_.HealthStatus -ne 'Healthy' -and $_.HealthStatus) { $flags += ($T.DiscoFisicoFlag -f $_.FriendlyName, $_.HealthStatus) }
}
Add-Line ""

Write-Host $T.Passo4
Add-Line "-- $($T.SecInit) --"
$runCount = 0
foreach ($hive in @('HKCU:\Software\Microsoft\Windows\CurrentVersion\Run','HKLM:\Software\Microsoft\Windows\CurrentVersion\Run')) {
    if (Test-Path $hive) { $runCount += (Get-Item $hive).ValueCount }
}
$startupFolderCount = 0
foreach ($f in @("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup","$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp")) {
    if (Test-Path $f) { $startupFolderCount += (Get-ChildItem $f -File -ErrorAction SilentlyContinue).Count }
}
Add-Line ($T.RegItens -f $runCount)
Add-Line ($T.StartupAtalhos -f $startupFolderCount)
if (($runCount + $startupFolderCount) -ge 15) { $flags += ($T.StartupFlag -f ($runCount+$startupFolderCount)) }
Add-Line ""

Write-Host $T.Passo5
Add-Line "-- $($T.SecUpdate) --"
try {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $result = $updateSearcher.Search("IsInstalled=0 and IsHidden=0")
    Add-Line ($T.UpdatesPend -f $result.Updates.Count)
    if ($result.Updates.Count -ge 5) { $flags += ($T.UpdatesFlag -f $result.Updates.Count) }
} catch {
    Add-Line $T.UpdateFalhou
}
Add-Line ""

Write-Host $T.Passo6
Add-Line "-- $($T.SecEventos) --"
try {
    $events = Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddDays(-7)} -MaxEvents 15 -ErrorAction Stop
    if ($events) {
        foreach ($e in $events) { Add-Line "$($e.TimeCreated.ToString('dd/MM HH:mm')) - $($e.ProviderName): $($e.Message.Split("`n")[0])" }
        if ($events.Count -ge 10) { $flags += $T.EventosFlag }
    } else {
        Add-Line $T.SemEventos
    }
} catch {
    Add-Line $T.SemEventos
}
Add-Line ""

Add-Line "-- $($T.SecResumo) --"
if ($flags.Count -eq 0) {
    Add-Line $T.ResumoOk
} else {
    foreach ($f in $flags) { Add-Line ($T.ResumoFlag -f $f) }
}

$desktopPath = [Environment]::GetFolderPath('Desktop')
$reportPath = Join-Path $desktopPath "PruPru_Diagnostico_$(Get-Date -Format 'yyyyMMdd_HHmm').html"
ConvertTo-PruPruHtml $T.Title $report | Out-File -FilePath $reportPath -Encoding UTF8
Start-Process $reportPath

Write-Host ""
Write-Host "=================================================="
Write-Host "  $($T.Concluido)"
Write-Host "  $($T.Salvo)"
Write-Host "  $reportPath"
Write-Host "=================================================="
if ($flags.Count -gt 0) {
    Write-Host ""
    Write-Host $T.Pontos -ForegroundColor Yellow
    foreach ($f in $flags) { Write-Host " - $f" -ForegroundColor Yellow }
}
'@

$Scripts['PruPru_FocoJogo_OFF.bat'] = @'
@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Foco no Jogo - DESATIVAR
:: Desfaz exatamente o que o PruPru_FocoJogo_ON.bat fez.
:: So remove as regras de firewall criadas por ele (prefixo
:: "PruPru Foco -"), nao mexe em nenhuma regra sua.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Game Focus (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - GAME FOCUS (OFF)"
    set "T_STEP1=[1/2] Restoring Steam's normal priority..."
    set "T_STEP2=[2/2] Removing browser blocks..."
    set "T_DONE=GAME FOCUS DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Enfoque en el Juego (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - ENFOQUE EN EL JUEGO (OFF)"
    set "T_STEP1=[1/2] Restaurando la prioridad normal de Steam..."
    set "T_STEP2=[2/2] Quitando los bloqueos de navegador..."
    set "T_DONE=ENFOQUE EN EL JUEGO DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Foco no Jogo (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - FOCO NO JOGO (OFF)"
    set "T_STEP1=[1/2] Voltando prioridade da Steam ao normal..."
    set "T_STEP2=[2/2] Removendo bloqueios de navegador..."
    set "T_DONE=FOCO NO JOGO DESATIVADO - TUDO NORMAL DE NOVO"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.

echo %T_STEP1%
powershell -NoProfile -Command "Get-Process steam,steamwebhelper -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'Normal' }" >nul 2>&1

echo %T_STEP2%
netsh advfirewall firewall delete rule name="PruPru Foco - Block Chrome" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Chrome x86" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Edge" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Firefox" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Brave" >nul 2>&1

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
'@

$Scripts['PruPru_FocoJogo_ON.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Foco no Jogo - ATIVAR
:: Da prioridade de CPU pra Steam e bloqueia SO os navegadores
:: (Chrome/Edge/Firefox/Brave) por app especifico. Nao mexe em
:: nenhuma outra porta, programa ou servico do sistema.
:: Para desfazer: rode PruPru_FocoJogo_OFF.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Game Focus (ENABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - GAME FOCUS (ON)"
    set "T_WHAT=What's going to happen:"
    set "T_ITEM1=- Steam's priority is raised to High (reversible)"
    set "T_ITEM2=- Chrome, Edge, Firefox and Brave lose internet access"
    set "T_ITEM3=  while the mode is active (only these 4 apps)"
    set "T_ITEM4=- NO other port, program or service is affected"
    set "T_ITEM5=  (Windows Update, Discord, antivirus etc keep working)"
    set "T_CONFIRM=Enable Game Focus now? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/2] Adjusting Steam's priority..."
    set "T_STEP1_DONE=      Done (if Steam isn't open, this is skipped)."
    set "T_STEP2=[2/2] Blocking browser internet access..."
    set "T_DONE_STEP=      Done."
    set "T_ACTIVE=GAME FOCUS IS ON"
    set "T_REVERT=To go back to normal, run PruPru_FocoJogo_OFF.bat"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Enfoque en el Juego (ACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - ENFOQUE EN EL JUEGO (ON)"
    set "T_WHAT=Lo que va a pasar:"
    set "T_ITEM1=- La prioridad de Steam sube a Alta (reversible)"
    set "T_ITEM2=- Chrome, Edge, Firefox y Brave se quedan sin internet"
    set "T_ITEM3=  mientras el modo este activo (solo esas 4 apps)"
    set "T_ITEM4=- NINGUN otro puerto, programa o servicio se ve afectado"
    set "T_ITEM5=  (Windows Update, Discord, antivirus etc siguen funcionando)"
    set "T_CONFIRM=Activar el Enfoque en el Juego ahora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/2] Ajustando la prioridad de Steam..."
    set "T_STEP1_DONE=      Completado (si Steam no esta abierto, esto se omite)."
    set "T_STEP2=[2/2] Bloqueando el acceso a internet de los navegadores..."
    set "T_DONE_STEP=      Completado."
    set "T_ACTIVE=ENFOQUE EN EL JUEGO ACTIVO"
    set "T_REVERT=Para volver a la normalidad, ejecuta PruPru_FocoJogo_OFF.bat"
) else (
    title PruPru Digital Services - Foco no Jogo (ATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - FOCO NO JOGO (ON)"
    set "T_WHAT=O que vai acontecer:"
    set "T_ITEM1=- Prioridade da Steam sobe para Alta (reversivel)"
    set "T_ITEM2=- Chrome, Edge, Firefox e Brave ficam sem internet"
    set "T_ITEM3=  enquanto o modo estiver ativo (so esses 4 apps)"
    set "T_ITEM4=- NENHUMA outra porta, programa ou servico e afetado"
    set "T_ITEM5=  (Windows Update, Discord, antivirus etc continuam OK)"
    set "T_CONFIRM=Ativar o Foco no Jogo agora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/2] Ajustando prioridade da Steam..."
    set "T_STEP1_DONE=      Concluido (se a Steam nao estiver aberta, isso e ignorado)."
    set "T_STEP2=[2/2] Bloqueando internet dos navegadores..."
    set "T_DONE_STEP=      Concluido."
    set "T_ACTIVE=FOCO NO JOGO ATIVO"
    set "T_REVERT=Para voltar ao normal, rode PruPru_FocoJogo_OFF.bat"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo   %T_ITEM5%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
powershell -NoProfile -Command "Get-Process steam,steamwebhelper -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1
echo %T_STEP1_DONE%

echo %T_STEP2%
netsh advfirewall firewall add rule name="PruPru Foco - Block Chrome" dir=out action=block program="C:\Program Files\Google\Chrome\Application\chrome.exe" enable=yes >nul 2>&1
netsh advfirewall firewall add rule name="PruPru Foco - Block Chrome x86" dir=out action=block program="C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" enable=yes >nul 2>&1
netsh advfirewall firewall add rule name="PruPru Foco - Block Edge" dir=out action=block program="C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" enable=yes >nul 2>&1
netsh advfirewall firewall add rule name="PruPru Foco - Block Firefox" dir=out action=block program="C:\Program Files\Mozilla Firefox\firefox.exe" enable=yes >nul 2>&1
netsh advfirewall firewall add rule name="PruPru Foco - Block Brave" dir=out action=block program="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" enable=yes >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_ACTIVE%
echo   %T_REVERT%
echo ==================================================
pause
'@

$Scripts['PruPru_GerenciadorInicializacao.bat'] = @'
@echo off
title PruPru Digital Services - Gerenciador de Inicializacao
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Gerenciador de Inicializacao
:: Ativa/desativa itens de inicializacao SEM apagar nada -- os
:: itens desativados vao para um "cofre" e podem ser reativados
:: a qualquer momento pelo mesmo menu.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Startup Manager
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Administrador de Inicio
) else (
    title PruPru Digital Services - Gerenciador de Inicializacao
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_GerenciadorInicializacao.ps1"

pause
'@

$Scripts['PruPru_GerenciadorInicializacao.ps1'] = @'
# PruPru Digital Services - Gerenciador de Inicializacao
# Ativa/desativa itens de inicializacao SEM apagar nada.
# Itens desativados sao guardados num "cofre" e podem ser
# reativados a qualquer momento pelo mesmo menu.

$ErrorActionPreference = 'SilentlyContinue'

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        Ativo = "ATIVO"; Desativado = "DESATIVADO"; Registro = "Registro"
        Atalho = "Atalho"; AtalhoDe = "Atalho ({0})"; Usuario = "Usuario"; Todos = "Todos"
        Banner1 = "PRUPRU DIGITAL SERVICES - GERENCIADOR DE INICIALIZACAO"
        Banner2 = "Nada e apagado. Itens desativados vao para um cofre e podem"
        Banner3 = "ser reativados aqui a qualquer momento."
        ColHeader = " #   STATUS       TIPO              NOME"
        Nenhum = "Nenhum item de inicializacao encontrado."
        Prompt = "Digite o numero para ativar/desativar (ou 0 para sair)"
        Invalido = "Numero invalido."
        Desativou = "'{0}' desativado (movido para o cofre PruPru, nao foi apagado)."
        Reativou = "'{0}' reativado."
        Tchau = "Ate mais! prupru.org"
    }
    en = @{
        Ativo = "ACTIVE"; Desativado = "DISABLED"; Registro = "Registry"
        Atalho = "Shortcut"; AtalhoDe = "Shortcut ({0})"; Usuario = "User"; Todos = "All users"
        Banner1 = "PRUPRU DIGITAL SERVICES - STARTUP MANAGER"
        Banner2 = "Nothing is deleted. Disabled items go into a vault and can"
        Banner3 = "be re-enabled here at any time."
        ColHeader = " #   STATUS       TYPE              NAME"
        Nenhum = "No startup items found."
        Prompt = "Enter the number to enable/disable it (or 0 to exit)"
        Invalido = "Invalid number."
        Desativou = "'{0}' disabled (moved to the PruPru vault, not deleted)."
        Reativou = "'{0}' re-enabled."
        Tchau = "See you later! prupru.org"
    }
    es = @{
        Ativo = "ACTIVO"; Desativado = "DESACTIVADO"; Registro = "Registro"
        Atalho = "Acceso directo"; AtalhoDe = "Acceso directo ({0})"; Usuario = "Usuario"; Todos = "Todos"
        Banner1 = "PRUPRU DIGITAL SERVICES - ADMINISTRADOR DE INICIO"
        Banner2 = "No se elimina nada. Los elementos desactivados van a una boveda"
        Banner3 = "y se pueden reactivar aqui en cualquier momento."
        ColHeader = " #   ESTADO       TIPO              NOMBRE"
        Nenhum = "No se encontraron elementos de inicio."
        Prompt = "Escribe el numero para activar/desactivar (o 0 para salir)"
        Invalido = "Numero invalido."
        Desativou = "'{0}' desactivado (movido a la boveda de PruPru, no se elimino)."
        Reativou = "'{0}' reactivado."
        Tchau = "Hasta luego! prupru.org"
    }
}[$Lang2]

$disabledRegRoot = 'HKCU:\Software\PruPru\DisabledStartup'
$disabledRegHKCU = "$disabledRegRoot\FromHKCU"
$disabledRegHKLM = "$disabledRegRoot\FromHKLM"
$disabledFolder = "$env:ProgramData\PruPru\DisabledStartup"

foreach ($p in @($disabledRegHKCU, $disabledRegHKLM)) {
    if (-not (Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
}
if (-not (Test-Path $disabledFolder)) { New-Item -ItemType Directory -Path $disabledFolder -Force | Out-Null }

# Chaves internas ficam em ingles estavel ('User'/'All'), independente
# do idioma da interface - so a exibicao (Show-Items) e traduzida.
$startupFolders = @{
    'User' = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    'All'  = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
}

function Get-Items {
    $items = @()
    $i = 1

    # Ativos - registro
    foreach ($hive in @('HKCU','HKLM')) {
        $path = if ($hive -eq 'HKCU') { 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' } else { 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' }
        if (Test-Path $path) {
            $key = Get-Item $path
            foreach ($name in $key.GetValueNames()) {
                if ($name -eq '') { continue }
                $kind = $key.GetValueKind($name)
                $items += [PSCustomObject]@{ Index=$i; Status='ACTIVE'; Tipo='Registry'; Escopo=$null; Hive=$hive; Nome=$name; Dado=$key.GetValue($name, $null, 'DoNotExpandEnvironmentNames'); Kind=$kind; Local=$path }
                $i++
            }
        }
    }

    # Ativos - pasta Startup
    foreach ($label in $startupFolders.Keys) {
        $folder = $startupFolders[$label]
        if (Test-Path $folder) {
            Get-ChildItem $folder -File | ForEach-Object {
                $items += [PSCustomObject]@{ Index=$i; Status='ACTIVE'; Tipo='Shortcut'; Escopo=$label; Hive=$null; Nome=$_.Name; Dado=$_.FullName; Local=$folder }
                $i++
            }
        }
    }

    # Desativados - registro
    foreach ($hive in @('HKCU','HKLM')) {
        $path = if ($hive -eq 'HKCU') { $disabledRegHKCU } else { $disabledRegHKLM }
        if (Test-Path $path) {
            $key = Get-Item $path
            foreach ($name in $key.GetValueNames()) {
                if ($name -eq '') { continue }
                $kind = $key.GetValueKind($name)
                $items += [PSCustomObject]@{ Index=$i; Status='DISABLED'; Tipo='Registry'; Escopo=$null; Hive=$hive; Nome=$name; Dado=$key.GetValue($name, $null, 'DoNotExpandEnvironmentNames'); Kind=$kind; Local=$path }
                $i++
            }
        }
    }

    # Desativados - atalhos
    if (Test-Path $disabledFolder) {
        Get-ChildItem $disabledFolder -File -Filter '*.origin' | ForEach-Object {
            $originalFile = $_.FullName -replace '\.origin$',''
            if (Test-Path $originalFile) {
                $items += [PSCustomObject]@{ Index=$i; Status='DISABLED'; Tipo='Shortcut'; Escopo=$null; Hive=$null; Nome=(Split-Path $originalFile -Leaf); Dado=$originalFile; Local=$disabledFolder }
                $i++
            }
        }
    }

    return $items
}

function Get-StatusLabel($status) { if ($status -eq 'ACTIVE') { $T.Ativo } else { $T.Desativado } }
function Get-TipoLabel($it) {
    if ($it.Tipo -eq 'Registry') { return $T.Registro }
    if ($it.Escopo -eq 'User') { return ($T.AtalhoDe -f $T.Usuario) }
    if ($it.Escopo -eq 'All') { return ($T.AtalhoDe -f $T.Todos) }
    return $T.Atalho
}

function Show-Items($items) {
    Write-Host ""
    Write-Host "===================================================================="
    Write-Host $T.ColHeader
    Write-Host "===================================================================="
    foreach ($it in $items) {
        $color = if ($it.Status -eq 'ACTIVE') { 'White' } else { 'DarkGray' }
        "{0,-4} {1,-12} {2,-17} {3}" -f $it.Index, (Get-StatusLabel $it.Status), (Get-TipoLabel $it), $it.Nome | Write-Host -ForegroundColor $color
    }
    Write-Host "===================================================================="
}

function Disable-Item($it) {
    if ($it.Tipo -eq 'Registry') {
        $destPath = if ($it.Hive -eq 'HKCU') { $disabledRegHKCU } else { $disabledRegHKLM }
        New-ItemProperty -Path $destPath -Name $it.Nome -Value $it.Dado -PropertyType $it.Kind -Force | Out-Null
        Remove-ItemProperty -Path $it.Local -Name $it.Nome -Force
        Write-Host ($T.Desativou -f $it.Nome) -ForegroundColor Yellow
    } else {
        $destFile = Join-Path $disabledFolder $it.Nome
        Move-Item -Path $it.Dado -Destination $destFile -Force
        Set-Content -Path "$destFile.origin" -Value $it.Local
        Write-Host ($T.Desativou -f $it.Nome) -ForegroundColor Yellow
    }
}

function Enable-Item($it) {
    if ($it.Tipo -eq 'Registry') {
        $destPath = if ($it.Hive -eq 'HKCU') { 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' } else { 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' }
        New-ItemProperty -Path $destPath -Name $it.Nome -Value $it.Dado -PropertyType $it.Kind -Force | Out-Null
        Remove-ItemProperty -Path $it.Local -Name $it.Nome -Force
        Write-Host ($T.Reativou -f $it.Nome) -ForegroundColor Green
    } else {
        $origin = Get-Content "$($it.Dado).origin"
        Move-Item -Path $it.Dado -Destination (Join-Path $origin (Split-Path $it.Dado -Leaf)) -Force
        Remove-Item "$($it.Dado).origin" -Force
        Write-Host ($T.Reativou -f $it.Nome) -ForegroundColor Green
    }
}

Write-Host "===================================================================="
Write-Host "  $($T.Banner1)"
Write-Host "  $($T.Banner2)"
Write-Host "  $($T.Banner3)"
Write-Host "===================================================================="

$running = $true
while ($running) {
    $items = Get-Items
    if ($items.Count -eq 0) {
        Write-Host $T.Nenhum
        break
    }
    Show-Items $items
    Write-Host ""
    $choice = Read-Host $T.Prompt
    if ($choice -eq '0' -or $choice -eq '') { $running = $false; break }
    $selected = $items | Where-Object { $_.Index -eq [int]$choice }
    if (-not $selected) {
        Write-Host $T.Invalido -ForegroundColor Red
        continue
    }
    if ($selected.Status -eq 'ACTIVE') {
        Disable-Item $selected
    } else {
        Enable-Item $selected
    }
}

Write-Host ""
Write-Host $T.Tchau
'@

$Scripts['PruPru_LimparEspaco.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Limpar Espaco em Disco
:: Remove apenas arquivos temporarios/cache reconstruiveis.
:: Mostra quanto espaco foi liberado no final.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Free Up Disk Space
    set "T_HEADER=PRUPRU DIGITAL SERVICES - FREE UP DISK SPACE"
    set "T_INTRO1=What will be cleaned (everything is automatically rebuilt"
    set "T_INTRO2=by Windows when needed, no personal files touched):"
    set "T_ITEM1=- User and Windows temporary files"
    set "T_ITEM2=- Thumbnail cache"
    set "T_ITEM3=- Already-installed update cache"
    set "T_CONFIRM_PROMPT=Continue? (Y/N): "
    set "T_CONFIRM_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/4] Cleaning user temporary files..."
    set "T_STEP2=[2/4] Cleaning Windows temporary files..."
    set "T_STEP3=[3/4] Cleaning thumbnail cache..."
    set "T_STEP4=[4/4] Cleaning already-installed update cache..."
    set "T_DONE_STEP=      Done."
    set "T_RECYCLE_PROMPT=Also empty the Recycle Bin? (Y/N): "
    set "T_RECYCLE_YES=Y"
    set "T_RECYCLE_DONE=      Recycle Bin emptied."
    set "T_FINISHED=CLEANUP COMPLETE"
    set "T_FREED_LABEL=Space freed: approximately"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Liberar Espacio en Disco
    set "T_HEADER=PRUPRU DIGITAL SERVICES - LIBERAR ESPACIO EN DISCO"
    set "T_INTRO1=Lo que se va a limpiar (todo se reconstruye automaticamente"
    set "T_INTRO2=por Windows cuando sea necesario, ningun archivo personal):"
    set "T_ITEM1=- Temporales del usuario y de Windows"
    set "T_ITEM2=- Cache de miniaturas"
    set "T_ITEM3=- Cache de actualizaciones ya instaladas"
    set "T_CONFIRM_PROMPT=Continuar? (S/N): "
    set "T_CONFIRM_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/4] Limpiando temporales del usuario..."
    set "T_STEP2=[2/4] Limpiando temporales de Windows..."
    set "T_STEP3=[3/4] Limpiando cache de miniaturas..."
    set "T_STEP4=[4/4] Limpiando cache de actualizaciones ya instaladas..."
    set "T_DONE_STEP=      Completado."
    set "T_RECYCLE_PROMPT=Vaciar tambien la Papelera de reciclaje? (S/N): "
    set "T_RECYCLE_YES=S"
    set "T_RECYCLE_DONE=      Papelera vaciada."
    set "T_FINISHED=LIMPIEZA COMPLETADA"
    set "T_FREED_LABEL=Espacio liberado: aproximadamente"
) else (
    title PruPru Digital Services - Limpar Espaco em Disco
    set "T_HEADER=PRUPRU DIGITAL SERVICES - LIMPAR ESPACO EM DISCO"
    set "T_INTRO1=O que vai ser limpo (tudo reconstruido automaticamente"
    set "T_INTRO2=pelo Windows quando necessario, nada de arquivo pessoal):"
    set "T_ITEM1=- Temporarios do usuario e do Windows"
    set "T_ITEM2=- Cache de miniaturas (thumbnails)"
    set "T_ITEM3=- Cache de atualizacoes ja instaladas"
    set "T_CONFIRM_PROMPT=Continuar? (S/N): "
    set "T_CONFIRM_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/4] Limpando temporarios do usuario..."
    set "T_STEP2=[2/4] Limpando temporarios do Windows..."
    set "T_STEP3=[3/4] Limpando cache de miniaturas..."
    set "T_STEP4=[4/4] Limpando cache de atualizacoes ja instaladas..."
    set "T_DONE_STEP=      Concluido."
    set "T_RECYCLE_PROMPT=Esvaziar tambem a Lixeira? (S/N): "
    set "T_RECYCLE_YES=S"
    set "T_RECYCLE_DONE=      Lixeira esvaziada."
    set "T_FINISHED=LIMPEZA CONCLUIDA"
    set "T_FREED_LABEL=Espaco liberado: aproximadamente"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.
echo %T_INTRO1%
echo %T_INTRO2%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo.
set /p CONFIRMA="%T_CONFIRM_PROMPT%"
if /i not "%CONFIRMA%"=="%T_CONFIRM_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

for /f "usebackq delims=" %%f in (`powershell -NoProfile -Command "(Get-PSDrive C).Free"`) do set FREE_BEFORE=%%f

echo.
echo %T_STEP1%
del /q /f /s "%temp%\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP2%
del /q /f /s "%SYSTEMROOT%\Temp\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
taskkill /f /im explorer.exe >nul 2>&1
del /q /f /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo %T_DONE_STEP%

echo %T_STEP4%
net stop wuauserv >nul 2>&1
del /q /f /s "%SYSTEMROOT%\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1
echo %T_DONE_STEP%

echo.
set /p LIXEIRA="%T_RECYCLE_PROMPT%"
if /i "%LIXEIRA%"=="%T_RECYCLE_YES%" (
    powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
    echo %T_RECYCLE_DONE%
)

for /f "usebackq delims=" %%f in (`powershell -NoProfile -Command "(Get-PSDrive C).Free"`) do set FREE_AFTER=%%f
for /f "usebackq delims=" %%g in (`powershell -NoProfile -Command "[math]::Round((%FREE_AFTER% - %FREE_BEFORE%)/1MB,0)"`) do set FREED_MB=%%g

echo.
echo ==================================================
echo   %T_FINISHED%
echo   !T_FREED_LABEL! %FREED_MB% MB
echo ==================================================
pause
'@

$Scripts['PruPru_ModoStreaming_OFF.bat'] = @'
@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Modo Streaming - DESATIVAR
:: Reverte exatamente o que o PruPru_ModoStreaming_ON.bat fez.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Streaming Mode (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - STREAMING MODE (OFF)"
    set "T_STEP1=[1/2] Restoring OBS/Streamlabs normal priority..."
    set "T_STEP2=[2/2] Re-enabling Xbox Game Bar (background recording)..."
    set "T_DONE=STREAMING MODE DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Modo Streaming (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (OFF)"
    set "T_STEP1=[1/2] Restaurando la prioridad normal de OBS/Streamlabs..."
    set "T_STEP2=[2/2] Reactivando Xbox Game Bar (grabacion en segundo plano)..."
    set "T_DONE=MODO STREAMING DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Modo Streaming (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (OFF)"
    set "T_STEP1=[1/2] Voltando prioridade do OBS/Streamlabs ao normal..."
    set "T_STEP2=[2/2] Reativando Xbox Game Bar (gravacao em segundo plano)..."
    set "T_DONE=MODO STREAMING DESATIVADO - TUDO NORMAL DE NOVO"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.

echo %T_STEP1%
powershell -NoProfile -Command "Get-Process obs64,obs32,'streamlabs-obs' -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'Normal' }" >nul 2>&1

echo %T_STEP2%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
'@

$Scripts['PruPru_ModoStreaming_ON.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Modo Streaming - ATIVAR
:: Da prioridade alta para o OBS/Streamlabs e libera recursos
:: do codificador desativando a gravacao em segundo plano do
:: Xbox Game Bar. NAO bloqueia navegador (chat/alertas precisam
:: dele). Para desfazer: PruPru_ModoStreaming_OFF.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Streaming Mode (ENABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - STREAMING MODE (ON)"
    set "T_WHAT=What's going to happen:"
    set "T_ITEM1=- OBS Studio / Streamlabs priority is raised to High"
    set "T_ITEM2=  (reversible, only if it's open)"
    set "T_ITEM3=- Xbox Game Bar's background recording is disabled"
    set "T_ITEM4=  (frees up part of the video encoder for your stream)"
    set "T_ITEM5=- NO browser is blocked - chat and alerts keep"
    set "T_ITEM6=  working normally"
    set "T_CONFIRM=Enable Streaming Mode now? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/2] Adjusting OBS/Streamlabs priority..."
    set "T_STEP1_DONE=      Done (if none is open, this is skipped)."
    set "T_STEP2=[2/2] Freeing up encoder resources (Xbox Game Bar)..."
    set "T_DONE_STEP=      Done."
    set "T_ACTIVE=STREAMING MODE IS ON"
    set "T_REVERT=To go back to normal, run PruPru_ModoStreaming_OFF.bat"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Modo Streaming (ACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (ON)"
    set "T_WHAT=Lo que va a pasar:"
    set "T_ITEM1=- La prioridad de OBS Studio / Streamlabs sube a Alta"
    set "T_ITEM2=  (reversible, solo si esta abierto)"
    set "T_ITEM3=- Se desactiva la grabacion en segundo plano de Xbox Game Bar"
    set "T_ITEM4=  (libera parte del codificador de video para tu directo)"
    set "T_ITEM5=- NINGUN navegador es bloqueado - el chat y las alertas"
    set "T_ITEM6=  siguen funcionando con normalidad"
    set "T_CONFIRM=Activar el Modo Streaming ahora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/2] Ajustando la prioridad de OBS/Streamlabs..."
    set "T_STEP1_DONE=      Completado (si ninguno esta abierto, esto se omite)."
    set "T_STEP2=[2/2] Liberando recursos del codificador (Xbox Game Bar)..."
    set "T_DONE_STEP=      Completado."
    set "T_ACTIVE=MODO STREAMING ACTIVO"
    set "T_REVERT=Para volver a la normalidad, ejecuta PruPru_ModoStreaming_OFF.bat"
) else (
    title PruPru Digital Services - Modo Streaming (ATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (ON)"
    set "T_WHAT=O que vai acontecer:"
    set "T_ITEM1=- Prioridade do OBS Studio / Streamlabs sobe para Alta"
    set "T_ITEM2=  (reversivel, so se estiver aberto)"
    set "T_ITEM3=- Gravacao em segundo plano do Xbox Game Bar e desativada"
    set "T_ITEM4=  (libera parte do codificador de video para sua live)"
    set "T_ITEM5=- NADA de navegador e bloqueado - chat e alertas continuam"
    set "T_ITEM6=  funcionando normalmente"
    set "T_CONFIRM=Ativar o Modo Streaming agora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/2] Ajustando prioridade do OBS/Streamlabs..."
    set "T_STEP1_DONE=      Concluido (se nenhum estiver aberto, isso e ignorado)."
    set "T_STEP2=[2/2] Liberando recursos do codificador (Xbox Game Bar)..."
    set "T_DONE_STEP=      Concluido."
    set "T_ACTIVE=MODO STREAMING ATIVO"
    set "T_REVERT=Para voltar ao normal, rode PruPru_ModoStreaming_OFF.bat"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo   %T_ITEM5%
echo   %T_ITEM6%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
powershell -NoProfile -Command "Get-Process obs64,obs32,'streamlabs-obs' -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1
echo %T_STEP1_DONE%

echo %T_STEP2%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_ACTIVE%
echo   %T_REVERT%
echo ==================================================
pause
'@

$Scripts['PruPru_Otimizador.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Otimizador de Sistema
:: Conecta seu PC ao melhor desempenho possivel, sem enrolacao.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - System Optimizer
    set "T_TITLE=System Optimizer"
    set "T_WHAT=What this script does:"
    set "T_ITEM1=- Creates a restore point before any change"
    set "T_ITEM2=- Cleans temporary files (safe and reversible)"
    set "T_ITEM3=- Sets the power plan to Balanced"
    set "T_ITEM4=- Disables telemetry (DiagTrack) - optional, reversible"
    set "T_ITEM5=- Adjusts SuperFetch/SysMain automatically based on your disk"
    set "T_ITEM6=- Does NOT close any of your programs, does NOT touch your browser,"
    set "T_ITEM7=  does NOT restart the PC without your confirmation"
    set "T_CONFIRM=Continue? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Operation cancelled. Nothing was changed."
    set "T_STEP1=[1/7] Creating restore point..."
    set "T_STEP1_DONE1=      Done (or a recent point already existed - Windows only allows"
    set "T_STEP1_DONE2=      one per day). If something goes wrong, restore from here."
    set "T_STEP2=[2/7] Cleaning temporary files..."
    set "T_STEP3=[3/7] Flushing DNS cache..."
    set "T_STEP4=[4/7] Setting power plan to Balanced..."
    set "T_STEP5=[5/7] Checking disk type before touching SysMain..."
    set "T_SSD_FOUND=      SSD detected - disabling SysMain ^(no benefit on SSD^)..."
    set "T_HDD_FOUND=      HDD or unrecognized disk - keeping SysMain enabled ^(helps on HDD^)."
    set "T_STEP6=[6/7] Disabling Windows telemetry ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Done. This only reduces data sent to Microsoft, doesn't affect games."
    set "T_STEP7=[7/7] Checking system file integrity..."
    set "T_STEP7_NOTE=      This may take a few minutes."
    set "T_DONE_STEP=      Done."
    set "T_FINISHED=OPTIMIZATION COMPLETE"
    set "T_RECOMMEND1=We recommend restarting the PC to apply everything."
    set "T_RECOMMEND2=To undo the changes, use PruPru_Reverter.bat"
    set "T_RECOMMEND3=or restore the point created in step 1."
    set "T_REBOOT_PROMPT=Restart now? (Y/N): "
    set "T_REBOOTING=Restarting in 10 seconds... ^(close this window to cancel with "shutdown /a"^)"
    set "T_LATER=OK, restart whenever you want to apply 100%% of the changes."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Optimizador del Sistema
    set "T_TITLE=Optimizador del Sistema"
    set "T_WHAT=Lo que hace este script:"
    set "T_ITEM1=- Crea un punto de restauracion antes de cualquier cambio"
    set "T_ITEM2=- Limpia archivos temporales (seguro y reversible)"
    set "T_ITEM3=- Ajusta el plan de energia a Equilibrado"
    set "T_ITEM4=- Desactiva la telemetria (DiagTrack) - opcional, reversible"
    set "T_ITEM5=- Ajusta SuperFetch/SysMain automaticamente segun tu disco"
    set "T_ITEM6=- NO cierra ninguno de tus programas, NO toca tu navegador,"
    set "T_ITEM7=  NO reinicia el PC sin tu confirmacion"
    set "T_CONFIRM=Deseas continuar? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Operacion cancelada. No se cambio nada."
    set "T_STEP1=[1/7] Creando punto de restauracion..."
    set "T_STEP1_DONE1=      Completado (o ya existia un punto reciente - Windows solo permite"
    set "T_STEP1_DONE2=      uno por dia). Si algo sale mal, restaura desde aqui."
    set "T_STEP2=[2/7] Limpiando archivos temporales..."
    set "T_STEP3=[3/7] Limpiando cache de DNS..."
    set "T_STEP4=[4/7] Ajustando el plan de energia a Equilibrado..."
    set "T_STEP5=[5/7] Verificando el tipo de disco antes de tocar SysMain..."
    set "T_SSD_FOUND=      Disco SSD detectado - desactivando SysMain ^(no aporta beneficio en SSD^)..."
    set "T_HDD_FOUND=      Disco HDD o no identificado - manteniendo SysMain activo ^(ayuda en HDD^)."
    set "T_STEP6=[6/7] Desactivando la telemetria de Windows ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Completado. Esto solo reduce los datos enviados a Microsoft, no afecta juegos."
    set "T_STEP7=[7/7] Verificando la integridad de los archivos del sistema..."
    set "T_STEP7_NOTE=      Esto puede tardar unos minutos."
    set "T_DONE_STEP=      Completado."
    set "T_FINISHED=OPTIMIZACION COMPLETADA"
    set "T_RECOMMEND1=Te recomendamos reiniciar el PC para aplicar todo."
    set "T_RECOMMEND2=Para deshacer los cambios, usa PruPru_Reverter.bat"
    set "T_RECOMMEND3=o restaura el punto creado en el paso 1."
    set "T_REBOOT_PROMPT=Reiniciar ahora? (S/N): "
    set "T_REBOOTING=Reiniciando en 10 segundos... ^(cierra esta ventana para cancelar con "shutdown /a"^)"
    set "T_LATER=Ok, reinicia cuando quieras para aplicar el 100%% de los cambios."
) else (
    title PruPru Digital Services - Otimizador de Sistema
    set "T_TITLE=Otimizador de Sistema"
    set "T_WHAT=O que este script faz:"
    set "T_ITEM1=- Cria um ponto de restauracao antes de qualquer alteracao"
    set "T_ITEM2=- Limpa arquivos temporarios (seguro e reversivel)"
    set "T_ITEM3=- Ajusta o plano de energia para Equilibrado"
    set "T_ITEM4=- Desativa telemetria (DiagTrack) - opcional, reversivel"
    set "T_ITEM5=- Ajusta SuperFetch/SysMain automaticamente conforme seu disco"
    set "T_ITEM6=- NAO fecha nenhum programa seu, NAO mexe no navegador,"
    set "T_ITEM7=  NAO reinicia o PC sem sua confirmacao"
    set "T_CONFIRM=Deseja continuar? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Operacao cancelada. Nada foi alterado."
    set "T_STEP1=[1/7] Criando ponto de restauracao..."
    set "T_STEP1_DONE1=      Concluido (ou ja existia um ponto recente - o Windows so permite"
    set "T_STEP1_DONE2=      um por dia). Se algo der errado, restaure o sistema por aqui."
    set "T_STEP2=[2/7] Limpando arquivos temporarios..."
    set "T_STEP3=[3/7] Limpando cache de DNS..."
    set "T_STEP4=[4/7] Ajustando plano de energia para Equilibrado..."
    set "T_STEP5=[5/7] Verificando tipo de disco antes de mexer no SysMain..."
    set "T_SSD_FOUND=      Disco SSD detectado - desativando SysMain ^(nao traz beneficio em SSD^)..."
    set "T_HDD_FOUND=      Disco HDD ou nao identificado - mantendo SysMain ativo ^(ajuda no HDD^)."
    set "T_STEP6=[6/7] Desativando telemetria do Windows ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Concluido. Isso so reduz coleta de dados enviada a Microsoft, nao afeta jogos."
    set "T_STEP7=[7/7] Verificando integridade dos arquivos do sistema..."
    set "T_STEP7_NOTE=      Isso pode demorar alguns minutos."
    set "T_DONE_STEP=      Concluido."
    set "T_FINISHED=OTIMIZACAO CONCLUIDA"
    set "T_RECOMMEND1=Recomendamos reiniciar o PC para aplicar tudo."
    set "T_RECOMMEND2=Para desfazer as alteracoes, use o PruPru_Reverter.bat"
    set "T_RECOMMEND3=ou restaure o ponto criado no passo 1."
    set "T_REBOOT_PROMPT=Reiniciar agora? (S/N): "
    set "T_REBOOTING=Reiniciando em 10 segundos... ^(feche esta janela para cancelar com "shutdown /a"^)"
    set "T_LATER=Ok, reinicie quando quiser para aplicar 100%% das mudancas."
)

:: --- Auto-elevacao (precisa rodar como administrador) ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   PRUPRU DIGITAL SERVICES
echo   %T_TITLE%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo   %T_ITEM5%
echo   %T_ITEM6%
echo   %T_ITEM7%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
powershell -NoProfile -Command "Enable-ComputerRestore -Drive '%SYSTEMDRIVE%\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'PruPru_Otimizador' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue" >nul 2>&1
echo %T_STEP1_DONE1%
echo %T_STEP1_DONE2%

echo %T_STEP2%
del /q /f /s "%temp%\*" >nul 2>&1
del /q /f /s "%SYSTEMROOT%\Temp\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
ipconfig /flushdns >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP4%
powercfg /S SCHEME_BALANCED >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP5%
set IS_SSD=0
for /f "tokens=1" %%m in ('powershell -NoProfile -Command "(Get-PhysicalDisk | Select-Object -First 1 -ExpandProperty MediaType)"') do (
    echo %%m | find /i "SSD" >nul && set IS_SSD=1
)
if "!IS_SSD!"=="1" (
    echo !T_SSD_FOUND!
    sc config "SysMain" start= disabled >nul 2>&1
    sc stop "SysMain" >nul 2>&1
) else (
    echo !T_HDD_FOUND!
)

echo %T_STEP6%
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
echo %T_STEP6_DONE%

echo %T_STEP7%
echo %T_STEP7_NOTE%
sfc /scannow

echo.
echo ==================================================
echo   %T_FINISHED%
echo ==================================================
echo %T_RECOMMEND1%
echo %T_RECOMMEND2%
echo %T_RECOMMEND3%
echo.
set /p REBOOT="%T_REBOOT_PROMPT%"
if /i "%REBOOT%"=="%T_YES%" (
    shutdown /r /t 10
    echo %T_REBOOTING%
) else (
    echo %T_LATER%
)
pause
'@

$Scripts['PruPru_Reverter.bat'] = @'
@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Reverte as alteracoes feitas pelo PruPru_Otimizador.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Revert Optimization
    set "T_TITLE=Reverting optimizations"
    set "T_STEP1=[1/3] Re-enabling SysMain..."
    set "T_STEP2=[2/3] Re-enabling telemetry (DiagTrack)..."
    set "T_STEP3=[3/3] Power plan kept on Balanced (Windows default)."
    set "T_DONE=SYSTEM REVERTED TO DEFAULT SETTINGS"
    set "T_NOTE1=To undo 100%% (including temp file cleanup),"
    set "T_NOTE2=use System Restore with the "PruPru_Otimizador" point."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Revertir Optimizacion
    set "T_TITLE=Revirtiendo optimizaciones"
    set "T_STEP1=[1/3] Reactivando SysMain..."
    set "T_STEP2=[2/3] Reactivando telemetria (DiagTrack)..."
    set "T_STEP3=[3/3] Plan de energia mantenido en Equilibrado (predeterminado de Windows)."
    set "T_DONE=SISTEMA REVERTIDO A LA CONFIGURACION PREDETERMINADA"
    set "T_NOTE1=Si quieres deshacer el 100%% (incluyendo la limpieza de temporales),"
    set "T_NOTE2=usa Restaurar sistema con el punto "PruPru_Otimizador"."
) else (
    title PruPru Digital Services - Reverter Otimizacao
    set "T_TITLE=Revertendo otimizacoes"
    set "T_STEP1=[1/3] Reativando SysMain..."
    set "T_STEP2=[2/3] Reativando telemetria (DiagTrack)..."
    set "T_STEP3=[3/3] Plano de energia mantido em Equilibrado (padrao do Windows)."
    set "T_DONE=SISTEMA REVERTIDO AS CONFIGURACOES PADRAO"
    set "T_NOTE1=Se quiser desfazer 100%% (incluindo limpeza de temporarios),"
    set "T_NOTE2=use a Restauracao do Sistema com o ponto "PruPru_Otimizador"."
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   PRUPRU DIGITAL SERVICES
echo   %T_TITLE%
echo ==================================================
echo.

echo %T_STEP1%
sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1

echo %T_STEP2%
sc config "DiagTrack" start= auto >nul 2>&1
sc start "DiagTrack" >nul 2>&1

echo %T_STEP3%

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
echo %T_NOTE1%
echo %T_NOTE2%
echo.
pause
'@

$Scripts['PruPru_SaudeDisco.bat'] = @'
@echo off
title PruPru Digital Services - Saude do Disco
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Saude do Disco (SMART, SOMENTE LEITURA)
:: Nao altera nada. Apenas le indicadores de saude do HD/SSD e
:: avisa se houver risco de falha.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Disk Health
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DISK HEALTH
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Salud del Disco
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SALUD DEL DISCO
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Saude do Disco
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SAUDE DO DISCO
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_SaudeDisco.ps1"

echo.
pause
'@

$Scripts['PruPru_SaudeDisco.ps1'] = @'
# PruPru Digital Services - Saude do Disco (SMART, somente leitura)
# Nao altera nada. So le indicadores de saude e alerta se
# houver sinal de falha iminente.

$ErrorActionPreference = 'SilentlyContinue'
$report = @()
function Add-Line($text) { $script:report += $text }

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        HtmlLang = "pt-BR"; Title = "Saude do Disco"
        Generated = "{0} - Gerado em {1} - Relatorio informativo, nada foi alterado"
        Consultando = "Consultando discos instalados..."
        Interface = "Interface: {0}  |  Tamanho: {1} GB"
        StatusWin = "Status Windows: {0}"
        SmartAlerta = "SMART: [ALERTA] Falha iminente detectada pelo disco!"
        SmartRecom = "Recomendacao: FACA BACKUP AGORA e planeje a troca deste disco."
        SmartOk = "SMART: OK, sem sinais de falha reportados pelo disco."
        SmartLegado = "SMART (legado): nao exposto por este disco/driver (comum em NVMe e discos USB)."
        SmartUseSaude = "Use o campo 'Saude' informado abaixo para este disco."
        StatusAlerta = "[ALERTA] Windows reporta status '{0}' para este disco."
        DiscoFisico = "Disco fisico: {0} - Saude: {1} - Uso: {2}"
        SecResumo = "RESUMO"
        ResumoAlerta1 = "[ATENCAO] Um ou mais discos apresentam sinais de alerta."
        ResumoAlerta2 = "Recomendacao: faca backup dos arquivos importantes e considere"
        ResumoAlerta3 = "a troca do disco preventivamente antes de perder dados."
        ResumoOk = "Nenhum sinal de falha encontrado nos discos analisados."
        SalvoTambem = "Relatorio tambem salvo em: {0}"
    }
    en = @{
        HtmlLang = "en"; Title = "Disk Health"
        Generated = "{0} - Generated on {1} - Informational report, nothing was changed"
        Consultando = "Querying installed disks..."
        Interface = "Interface: {0}  |  Size: {1} GB"
        StatusWin = "Windows status: {0}"
        SmartAlerta = "SMART: [WARNING] Imminent failure detected by the disk!"
        SmartRecom = "Recommendation: BACK UP NOW and plan to replace this disk."
        SmartOk = "SMART: OK, no failure signs reported by the disk."
        SmartLegado = "SMART (legacy): not exposed by this disk/driver (common on NVMe and USB disks)."
        SmartUseSaude = "Use the 'Health' field below for this disk."
        StatusAlerta = "[WARNING] Windows reports status '{0}' for this disk."
        DiscoFisico = "Physical disk: {0} - Health: {1} - Usage: {2}"
        SecResumo = "SUMMARY"
        ResumoAlerta1 = "[WARNING] One or more disks show warning signs."
        ResumoAlerta2 = "Recommendation: back up your important files and consider"
        ResumoAlerta3 = "replacing the disk preventively before losing data."
        ResumoOk = "No failure signs found on the analyzed disks."
        SalvoTambem = "Report also saved to: {0}"
    }
    es = @{
        HtmlLang = "es"; Title = "Salud del Disco"
        Generated = "{0} - Generado el {1} - Informe informativo, no se cambio nada"
        Consultando = "Consultando discos instalados..."
        Interface = "Interfaz: {0}  |  Tamano: {1} GB"
        StatusWin = "Estado de Windows: {0}"
        SmartAlerta = "SMART: [ATENCION] Se detecto una falla inminente en el disco!"
        SmartRecom = "Recomendacion: HAZ UNA COPIA DE SEGURIDAD AHORA y planea reemplazar este disco."
        SmartOk = "SMART: OK, sin senales de falla reportadas por el disco."
        SmartLegado = "SMART (legado): no expuesto por este disco/controlador (comun en NVMe y discos USB)."
        SmartUseSaude = "Usa el campo 'Salud' indicado abajo para este disco."
        StatusAlerta = "[ATENCION] Windows reporta el estado '{0}' para este disco."
        DiscoFisico = "Disco fisico: {0} - Salud: {1} - Uso: {2}"
        SecResumo = "RESUMEN"
        ResumoAlerta1 = "[ATENCION] Uno o mas discos presentan senales de alerta."
        ResumoAlerta2 = "Recomendacion: haz una copia de seguridad de tus archivos importantes y considera"
        ResumoAlerta3 = "reemplazar el disco preventivamente antes de perder datos."
        ResumoOk = "No se encontraron senales de falla en los discos analizados."
        SalvoTambem = "Informe tambien guardado en: {0}"
    }
}[$Lang2]

function ConvertTo-PruPruHtml($titulo, $lines) {
    function EscapeHtml($s) { $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }
    $bodyHtml = ($lines | ForEach-Object {
        $line = $_
        if ($line -match '^--(.+)--$') {
            "<h3>$(EscapeHtml $Matches[1].Trim())</h3>"
        } elseif ($line -match '\[(ALERTA|ATENCAO|WARNING|ATENCION)\]') {
            "<p class='alerta'>$(EscapeHtml $line)</p>"
        } elseif ($line -eq '') {
            "<div class='spacer'></div>"
        } else {
            "<p>$(EscapeHtml $line)</p>"
        }
    }) -join "`n"
    @"
<!DOCTYPE html>
<html lang="$($T.HtmlLang)">
<head>
<meta charset="UTF-8">
<title>$titulo - PruPru Digital Services</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700&family=Montserrat:wght@400;600&display=swap');
  body { font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; background:#F7F9FB; color:#0B1F3A; margin:0; padding:0; }
  .header { background:#00205A; color:#fff; padding:24px 32px; }
  .header h1 { margin:0; font-size:22px; font-family:'Space Grotesk', sans-serif; }
  .header p { margin:4px 0 0; font-size:13px; opacity:0.85; }
  .content { max-width:720px; margin:24px auto; background:#fff; border-radius:8px; padding:24px 32px; box-shadow:0 1px 4px rgba(0,32,90,0.08); }
  h3 { color:#00205A; font-family:'Space Grotesk', sans-serif; border-bottom:2px solid #349CFA; padding-bottom:6px; margin-top:28px; }
  p { margin:4px 0; font-size:14px; line-height:1.5; white-space:pre-wrap; }
  .alerta { color:#B00020; font-weight:600; background:#FDECEC; padding:6px 10px; border-radius:4px; }
  .spacer { height:8px; }
  .footer { text-align:center; color:#8a8f98; font-size:12px; margin:24px 0 40px; }
</style>
</head>
<body>
  <div class="header">
    <h1>PruPru Digital Services</h1>
    <p>$($T.Generated -f $titulo, (Get-Date -Format 'dd/MM/yyyy HH:mm'))</p>
  </div>
  <div class="content">
$bodyHtml
  </div>
  <div class="footer">prupru.org</div>
</body>
</html>
"@
}

Write-Host $T.Consultando
$disks = Get-CimInstance Win32_DiskDrive
$predictFail = Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus

$anyAlert = $false

foreach ($d in $disks) {
    Add-Line "-- $($d.Model) --"
    Add-Line ($T.Interface -f $d.InterfaceType, [math]::Round($d.Size/1GB,0))
    Add-Line ($T.StatusWin -f $d.Status)

    $match = $predictFail | Where-Object { $_.InstanceName -like "*$($d.PNPDeviceID)*" }
    if ($match) {
        if ($match.PredictFailure) {
            Add-Line $T.SmartAlerta
            Add-Line $T.SmartRecom
            $anyAlert = $true
        } else {
            Add-Line $T.SmartOk
        }
    } else {
        Add-Line $T.SmartLegado
        Add-Line $T.SmartUseSaude
    }

    if ($d.Status -ne 'OK') {
        Add-Line ($T.StatusAlerta -f $d.Status)
        $anyAlert = $true
    }
    Add-Line ""
}

Get-PhysicalDisk | ForEach-Object {
    Add-Line ($T.DiscoFisico -f $_.FriendlyName, $_.HealthStatus, $_.Usage)
    if ($_.HealthStatus -and $_.HealthStatus -ne 'Healthy') { $anyAlert = $true }
}

Add-Line ""
Add-Line "-- $($T.SecResumo) --"
if ($anyAlert) {
    Add-Line $T.ResumoAlerta1
    Add-Line $T.ResumoAlerta2
    Add-Line $T.ResumoAlerta3
} else {
    Add-Line $T.ResumoOk
}

$desktopPath = [Environment]::GetFolderPath('Desktop')
$reportPath = Join-Path $desktopPath "PruPru_SaudeDisco_$(Get-Date -Format 'yyyyMMdd_HHmm').html"
ConvertTo-PruPruHtml $T.Title $report | Out-File -FilePath $reportPath -Encoding UTF8
Start-Process $reportPath

$report | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host ($T.SalvoTambem -f $reportPath)
'@

$Scripts['PruPru_Scanner_Seguranca.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Scanner de Seguranca (SOMENTE LEITURA)
:: Este script NAO apaga, NAO encerra e NAO altera nada.
:: Ele apenas gera um relatorio para voce decidir o que fazer.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Security Scanner
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - SECURITY REPORT"
    set "T_GENERATED=Generated on"
    set "T_INFO_ONLY=This report is informational. Nothing was deleted."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - SECURITY SCANNER"
    set "T_MODE=Read-only mode: nothing will be deleted or closed"
    set "T_STEP1=[1/4] Looking for known mining processes..."
    set "T_PROC_SECTION=-- SUSPICIOUS PROCESSES FOUND --"
    set "T_PROC_ALERT=[WARNING] Process running:"
    set "T_PROC_NONE=No known mining process found."
    set "T_STEP2=[2/4] Listing startup programs (Run keys)..."
    set "T_RUN_HKCU=-- STARTUP ITEMS (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- STARTUP ITEMS (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listed in the report. Review and manually disable"
    set "T_RUN_NOTE2=(Task Manager ^> Startup) anything you don't recognize."
    set "T_STEP3=[3/4] Listing scheduled tasks (for your manual review)..."
    set "T_TASKS_SECTION=-- SCHEDULED TASKS (excluding Microsoft's own) --"
    set "T_TASKS_NOTE=Listed in the report."
    set "T_STEP4=[4/4] Checking startup folders for unusual shortcuts..."
    set "T_STARTUP_USER=-- FILES IN THE USER STARTUP FOLDER --"
    set "T_STARTUP_ALL=-- FILES IN THE ALL USERS STARTUP FOLDER --"
    set "T_DONE=SCAN COMPLETE - NOTHING WAS CHANGED"
    set "T_SAVED=Report saved to:"
    set "T_FOOTER1=If you find something suspicious in the report that you"
    set "T_FOOTER2=don't recognize, send it to PruPru Digital Services to review"
    set "T_FOOTER3=before removing anything manually."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Escaner de Seguridad
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - INFORME DE SEGURIDAD"
    set "T_GENERATED=Generado el"
    set "T_INFO_ONLY=Este informe es informativo. No se elimino nada."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - ESCANER DE SEGURIDAD"
    set "T_MODE=Modo de solo lectura: no se eliminara ni cerrara nada"
    set "T_STEP1=[1/4] Buscando procesos de mineria conocidos..."
    set "T_PROC_SECTION=-- PROCESOS SOSPECHOSOS ENCONTRADOS --"
    set "T_PROC_ALERT=[ATENCION] Proceso en ejecucion:"
    set "T_PROC_NONE=No se encontro ningun proceso minero conocido."
    set "T_STEP2=[2/4] Listando programas de inicio (claves Run)..."
    set "T_RUN_HKCU=-- ELEMENTOS DE INICIO (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- ELEMENTOS DE INICIO (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listados en el informe. Revisa y desactiva manualmente"
    set "T_RUN_NOTE2=(Administrador de tareas ^> Inicio) lo que no reconozcas."
    set "T_STEP3=[3/4] Listando tareas programadas (para tu revision manual)..."
    set "T_TASKS_SECTION=-- TAREAS PROGRAMADAS (excluyendo las predeterminadas de Microsoft) --"
    set "T_TASKS_NOTE=Listadas en el informe."
    set "T_STEP4=[4/4] Verificando carpetas de inicio en busca de accesos inusuales..."
    set "T_STARTUP_USER=-- ARCHIVOS EN LA CARPETA STARTUP DEL USUARIO --"
    set "T_STARTUP_ALL=-- ARCHIVOS EN LA CARPETA STARTUP GENERAL --"
    set "T_DONE=ANALISIS COMPLETADO - NO SE CAMBIO NADA"
    set "T_SAVED=Informe guardado en:"
    set "T_FOOTER1=Si encuentras algo sospechoso en el informe que no"
    set "T_FOOTER2=reconoces, enviaselo a PruPru Digital Services para revisarlo"
    set "T_FOOTER3=antes de eliminar algo manualmente."
) else (
    title PruPru Digital Services - Scanner de Seguranca
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - RELATORIO DE SEGURANCA"
    set "T_GENERATED=Gerado em"
    set "T_INFO_ONLY=Este relatorio e informativo. Nada foi apagado."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - SCANNER DE SEGURANCA"
    set "T_MODE=Modo somente-leitura: nada sera apagado ou fechado"
    set "T_STEP1=[1/4] Procurando processos de mineracao conhecidos..."
    set "T_PROC_SECTION=-- PROCESSOS SUSPEITOS ENCONTRADOS --"
    set "T_PROC_ALERT=[ALERTA] Processo em execucao:"
    set "T_PROC_NONE=Nenhum processo minerador conhecido encontrado."
    set "T_STEP2=[2/4] Listando programas de inicializacao (Run keys)..."
    set "T_RUN_HKCU=-- ITENS DE INICIALIZACAO (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- ITENS DE INICIALIZACAO (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listados no relatorio. Revise e desative manualmente"
    set "T_RUN_NOTE2=(Gerenciador de Tarefas ^> Inicializar) o que nao reconhecer."
    set "T_STEP3=[3/4] Listando tarefas agendadas (para sua revisao manual)..."
    set "T_TASKS_SECTION=-- TAREFAS AGENDADAS (excluindo as padrao da Microsoft) --"
    set "T_TASKS_NOTE=Listadas no relatorio."
    set "T_STEP4=[4/4] Verificando pastas de inicializacao por atalhos incomuns..."
    set "T_STARTUP_USER=-- ARQUIVOS NA PASTA STARTUP DO USUARIO --"
    set "T_STARTUP_ALL=-- ARQUIVOS NA PASTA STARTUP GERAL --"
    set "T_DONE=SCAN CONCLUIDO - NADA FOI ALTERADO"
    set "T_SAVED=Relatorio salvo em:"
    set "T_FOOTER1=Se encontrar algo suspeito no relatorio que voce nao"
    set "T_FOOTER2=reconhece, envie para PruPru Digital Services revisar"
    set "T_FOOTER3=antes de remover qualquer coisa manualmente."
)

set DESKTOP=
for /f "usebackq delims=" %%d in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set DESKTOP=%%d
if "%DESKTOP%"=="" set DESKTOP=%USERPROFILE%\Desktop

set REPORT=%DESKTOP%\PruPru_Relatorio_Scan_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt
set REPORT=%REPORT: =0%

echo ==================================================  > "%REPORT%"
echo   %T_HEADER_REPORT%  >> "%REPORT%"
echo   %T_GENERATED% %date% %time%                           >> "%REPORT%"
echo   %T_INFO_ONLY%   >> "%REPORT%"
echo ==================================================  >> "%REPORT%"

echo ==================================================
echo   %T_HEADER_CONSOLE%
echo   %T_MODE%
echo ==================================================
echo.

echo %T_STEP1%
echo.>> "%REPORT%"
echo %T_PROC_SECTION%                >> "%REPORT%"
set FOUND_PROC=0
for %%p in (xmrig.exe minerd.exe ccminer.exe nheqminer.exe ethminer.exe cpuminer.exe t-rex.exe phoenixminer.exe lolminer.exe nbminer.exe teamredminer.exe claymore.exe wildrig.exe srbminer.exe) do (
    tasklist /fi "imagename eq %%p" 2>nul | find /i "%%p" >nul
    if not errorlevel 1 (
        echo   %T_PROC_ALERT% %%p
        echo   %T_PROC_ALERT% %%p >> "%REPORT%"
        set FOUND_PROC=1
    )
)
if "!FOUND_PROC!"=="0" (
    echo   %T_PROC_NONE%
    echo   %T_PROC_NONE% >> "%REPORT%"
)

echo.
echo %T_STEP2%
echo.>> "%REPORT%"
echo %T_RUN_HKCU%           >> "%REPORT%"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>nul
echo.>> "%REPORT%"
echo %T_RUN_HKLM%           >> "%REPORT%"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>nul
echo   %T_RUN_NOTE1%
echo   %T_RUN_NOTE2%

echo.
echo %T_STEP3%
echo.>> "%REPORT%"
echo %T_TASKS_SECTION% >> "%REPORT%"
powershell -NoProfile -Command "Get-ScheduledTask | Where-Object { $_.TaskPath -notlike '\Microsoft\*' } | ForEach-Object { \"$($_.TaskPath)$($_.TaskName)  [$($_.State)]\" }" >> "%REPORT%" 2>nul
echo   %T_TASKS_NOTE%

echo.
echo %T_STEP4%
echo.>> "%REPORT%"
echo %T_STARTUP_USER%            >> "%REPORT%"
dir /b "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup" >> "%REPORT%" 2>nul
echo.>> "%REPORT%"
echo %T_STARTUP_ALL%                 >> "%REPORT%"
dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp" >> "%REPORT%" 2>nul

echo.
echo ==================================================
echo   %T_DONE%
echo   %T_SAVED%
echo   %REPORT%
echo ==================================================
echo %T_FOOTER1%
echo %T_FOOTER2%
echo %T_FOOTER3%
echo.
pause
'@

$Scripts['PruPru_TesteIntegridade.bat'] = @'
@echo off
title PruPru Digital Services - Teste de Integridade
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Teste de Integridade Rapido (SOMENTE LEITURA)
:: Popup rapido com veredito honesto sobre RAM, disco e saude
:: do HD/SSD. Nao altera nada no sistema.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Quick Integrity Test
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Prueba de Integridad Rapida
) else (
    title PruPru Digital Services - Teste de Integridade
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_TesteIntegridade.ps1"
'@

$Scripts['PruPru_TesteIntegridade.ps1'] = @'
# PruPru Digital Services - Teste de Integridade Rapido (somente leitura)
# Popup rapido com veredito HONESTO: reutiliza os mesmos criterios reais
# do Diagnostico/Saude do Disco. Se algo estiver ruim, o popup avisa --
# nao existe mensagem positiva fixa independente do resultado.

Add-Type -AssemblyName System.Windows.Forms
$ErrorActionPreference = 'Stop'

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        Titulo = "PruPru Digital Services - Teste de Integridade"
        RamAlerta = "Memoria RAM quase no limite ({0}% em uso)"
        DiscoAlerta = "Pouco espaco livre no disco C: ({0}% livre)"
        SaudeAlerta = "Disco reportando saude '{0}' - faca backup"
        SmartAlerta = "SMART detectou risco de falha no disco - faca backup AGORA"
        Specs = "- Processador: {0}`r`n- Memoria RAM: {1} GB instalados ({2}% em uso)`r`n- Placa de Video: {3}`r`n- Espaco livre no disco C: {4} GB de {5} GB ({6}% livre)"
        OkMsg = "Analise concluida.`r`n`r`nNao encontramos nenhum problema nos itens verificados.`r`n`r`n--------------------------------------------------------`r`n  DADOS DO SEU COMPUTADOR:`r`n--------------------------------------------------------`r`n{0}`r`n--------------------------------------------------------`r`nVerificamos: uso de RAM, espaco em disco e saude do HD/SSD."
        WarnMsg = "Analise concluida.`r`n`r`nEncontramos os seguintes pontos de atencao:`r`n{0}`r`n`r`n--------------------------------------------------------`r`n  DADOS DO SEU COMPUTADOR:`r`n--------------------------------------------------------`r`n{1}`r`n--------------------------------------------------------`r`nRecomendamos rodar o Diagnostico completo ou a Saude do`r`nDisco no painel PruPru para mais detalhes."
        ErrMsg = "Nao foi possivel concluir a verificacao agora.`r`n`r`nDetalhe tecnico: {0}`r`n`r`nTente novamente, ou use o Diagnostico do PC no painel para`r`numa analise completa."
    }
    en = @{
        Titulo = "PruPru Digital Services - Quick Integrity Test"
        RamAlerta = "RAM memory nearly at its limit ({0}% in use)"
        DiscoAlerta = "Low free space on drive C: ({0}% free)"
        SaudeAlerta = "Disk reporting health '{0}' - back up your files"
        SmartAlerta = "SMART detected a disk failure risk - back up NOW"
        Specs = "- Processor: {0}`r`n- RAM: {1} GB installed ({2}% in use)`r`n- Graphics Card: {3}`r`n- Free space on drive C: {4} GB of {5} GB ({6}% free)"
        OkMsg = "Analysis complete.`r`n`r`nWe didn't find any problems in the checked items.`r`n`r`n--------------------------------------------------------`r`n  YOUR COMPUTER'S DATA:`r`n--------------------------------------------------------`r`n{0}`r`n--------------------------------------------------------`r`nWe checked: RAM usage, disk space and HDD/SSD health."
        WarnMsg = "Analysis complete.`r`n`r`nWe found the following points of attention:`r`n{0}`r`n`r`n--------------------------------------------------------`r`n  YOUR COMPUTER'S DATA:`r`n--------------------------------------------------------`r`n{1}`r`n--------------------------------------------------------`r`nWe recommend running the full Diagnostics or Disk Health`r`ntool in the PruPru panel for more details."
        ErrMsg = "The check couldn't be completed right now.`r`n`r`nTechnical detail: {0}`r`n`r`nTry again, or use PC Diagnostics in the panel for a`r`nfull analysis."
    }
    es = @{
        Titulo = "PruPru Digital Services - Prueba de Integridad Rapida"
        RamAlerta = "La memoria RAM esta casi al limite ({0}% en uso)"
        DiscoAlerta = "Poco espacio libre en el disco C: ({0}% libre)"
        SaudeAlerta = "El disco reporta salud '{0}' - haz una copia de seguridad"
        SmartAlerta = "SMART detecto riesgo de falla en el disco - haz una copia de seguridad AHORA"
        Specs = "- Procesador: {0}`r`n- Memoria RAM: {1} GB instalados ({2}% en uso)`r`n- Tarjeta Grafica: {3}`r`n- Espacio libre en el disco C: {4} GB de {5} GB ({6}% libre)"
        OkMsg = "Analisis completado.`r`n`r`nNo encontramos ningun problema en los elementos verificados.`r`n`r`n--------------------------------------------------------`r`n  DATOS DE TU EQUIPO:`r`n--------------------------------------------------------`r`n{0}`r`n--------------------------------------------------------`r`nVerificamos: uso de RAM, espacio en disco y salud del HD/SSD."
        WarnMsg = "Analisis completado.`r`n`r`nEncontramos los siguientes puntos de atencion:`r`n{0}`r`n`r`n--------------------------------------------------------`r`n  DATOS DE TU EQUIPO:`r`n--------------------------------------------------------`r`n{1}`r`n--------------------------------------------------------`r`nTe recomendamos ejecutar el Diagnostico completo o la Salud`r`ndel Disco en el panel de PruPru para mas detalles."
        ErrMsg = "No se pudo completar la verificacion ahora.`r`n`r`nDetalle tecnico: {0}`r`n`r`nIntenta de nuevo, o usa el Diagnostico del PC en el panel`r`npara un analisis completo."
    }
}[$Lang2]

try {
    $issues = @()

    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = (Get-CimInstance Win32_Processor | Select-Object -First 1).Name
    $gpu = (Get-CimInstance Win32_VideoController | Select-Object -First 1).Name

    $ramTotalGB = [math]::Round($os.TotalVisibleMemorySize/1MB,1)
    $ramFreeGB  = [math]::Round($os.FreePhysicalMemory/1MB,1)
    $ramPct = [math]::Round((($ramTotalGB-$ramFreeGB)/$ramTotalGB)*100,0)
    if ($ramPct -ge 90) { $issues += ($T.RamAlerta -f $ramPct) }

    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $discoTotalGB = [math]::Round($disk.Size/1GB,1)
    $discoLivreGB = [math]::Round($disk.FreeSpace/1GB,1)
    $discoPctLivre = if ($discoTotalGB -gt 0) { [math]::Round(($discoLivreGB/$discoTotalGB)*100,0) } else { 0 }
    if ($discoPctLivre -le 10) { $issues += ($T.DiscoAlerta -f $discoPctLivre) }

    $discoSaudavel = $true
    try {
        $physDisk = Get-PhysicalDisk | Select-Object -First 1
        if ($physDisk -and $physDisk.HealthStatus -and $physDisk.HealthStatus -ne 'Healthy') {
            $discoSaudavel = $false
            $issues += ($T.SaudeAlerta -f $physDisk.HealthStatus)
        }
        $predict = Get-CimInstance -Namespace root\wmi -ClassName MSStorageDriver_FailurePredictStatus -ErrorAction SilentlyContinue
        if ($predict -and ($predict | Where-Object { $_.PredictFailure })) {
            $discoSaudavel = $false
            $issues += $T.SmartAlerta
        }
    } catch { }

    $specs = $T.Specs -f $cpu, $ramTotalGB, $ramPct, $gpu, $discoLivreGB, $discoTotalGB, $discoPctLivre

    if ($issues.Count -eq 0) {
        $msg = $T.OkMsg -f $specs
        [System.Windows.Forms.MessageBox]::Show($msg, $T.Titulo, 'OK', 'Information') | Out-Null
    } else {
        $listaIssues = ($issues | ForEach-Object { "  - $_" }) -join "`r`n"
        $msg = $T.WarnMsg -f $listaIssues, $specs
        [System.Windows.Forms.MessageBox]::Show($msg, $T.Titulo, 'OK', 'Warning') | Out-Null
    }
} catch {
    $msg = $T.ErrMsg -f $_.Exception.Message
    [System.Windows.Forms.MessageBox]::Show($msg, $T.Titulo, 'OK', 'Error') | Out-Null
}
'@

$Scripts['PruPru_TurboRede_OFF.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Turbo de Rede - DESATIVAR
:: Reverte exatamente o que o PruPru_TurboRede_ON.bat mudou,
:: usando os valores padrao oficiais do Windows.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Network Turbo (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - NETWORK TURBO (OFF)"
    set "T_STEP1=[1/4] Detecting active network adapter..."
    set "T_ADAPTER_NONE=      Couldn't detect an active adapter. Skipping DNS."
    set "T_ADAPTER_FOUND=      Adapter detected:"
    set "T_DNS_DONE=      DNS is back to automatic (from your router/ISP)."
    set "T_STEP2=[2/4] Restoring default TCP autotuning..."
    set "T_STEP3=[3/4] Restoring default TCP congestion provider..."
    set "T_STEP4=[4/4] Restoring Windows' default multitasking priority..."
    set "T_DONE_STEP=      Done."
    set "T_DONE=NETWORK TURBO DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Turbo de Red (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE RED (OFF)"
    set "T_STEP1=[1/4] Detectando el adaptador de red activo..."
    set "T_ADAPTER_NONE=      No se pudo detectar un adaptador activo. Omitiendo DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      El DNS volvio a ser automatico (de tu router/proveedor)."
    set "T_STEP2=[2/4] Restaurando el autotuning de TCP predeterminado..."
    set "T_STEP3=[3/4] Restaurando el proveedor de congestion TCP predeterminado..."
    set "T_STEP4=[4/4] Restaurando la prioridad predeterminada de Windows para multitarea..."
    set "T_DONE_STEP=      Completado."
    set "T_DONE=TURBO DE RED DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Turbo de Rede (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE REDE (OFF)"
    set "T_STEP1=[1/4] Detectando adaptador de rede ativo..."
    set "T_ADAPTER_NONE=      Nao foi possivel detectar um adaptador ativo. Pulando DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS voltou a ser automatico (do seu roteador/provedor)."
    set "T_STEP2=[2/4] Restaurando TCP autotuning padrao..."
    set "T_STEP3=[3/4] Restaurando provedor de congestionamento TCP padrao..."
    set "T_STEP4=[4/4] Restaurando prioridade padrao do Windows para multitarefa..."
    set "T_DONE_STEP=      Concluido."
    set "T_DONE=TURBO DE REDE DESATIVADO - TUDO NORMAL DE NOVO"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.

echo %T_STEP1%
set ADAPTER=
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Sort-Object -Property RouteMetric | Select-Object -First 1 -ExpandProperty InterfaceAlias)"`) do set ADAPTER=%%a
if "!ADAPTER!"=="" (
    echo !T_ADAPTER_NONE!
) else (
    echo !T_ADAPTER_FOUND! !ADAPTER!
    netsh interface ip set dns "!ADAPTER!" dhcp >nul 2>&1
    echo !T_DNS_DONE!
)

echo %T_STEP2%
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set heuristics enabled >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
netsh int tcp set global congestionprovider=default >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP4%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xa /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
'@

$Scripts['PruPru_TurboRede_ON.bat'] = @'
@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Turbo de Rede - ATIVAR
:: Ajustes de rede documentados e reversiveis. Sem promessa de
:: milagre: isso reduz latencia/gargalo de configuracao, nao
:: aumenta a velocidade contratada do seu provedor.
:: Para desfazer: rode PruPru_TurboRede_OFF.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Network Turbo (ENABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - NETWORK TURBO (ON)"
    set "T_WHAT=What's going to happen:"
    set "T_ITEM1=- Automatic detection of your active network adapter"
    set "T_ITEM2=- DNS switched to Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- TCP tweaks documented by Microsoft (reversible)"
    set "T_ITEM4=- Network/CPU priority for games (SystemResponsiveness)"
    set "T_CONFIRM=Enable Network Turbo now? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/4] Detecting active network adapter..."
    set "T_ADAPTER_NONE=      Couldn't detect an active adapter. Skipping DNS."
    set "T_ADAPTER_FOUND=      Adapter detected:"
    set "T_DNS_DONE=      DNS set to Cloudflare on that adapter."
    set "T_STEP2=[2/4] Setting TCP autotuning to the recommended default..."
    set "T_STEP3=[3/4] Switching TCP congestion provider to CTCP..."
    set "T_STEP3_DONE=      Done (helps on higher-latency connections)."
    set "T_STEP4=[4/4] Prioritizing games/multimedia in the Windows scheduler..."
    set "T_DONE_STEP=      Done."
    set "T_ACTIVE=NETWORK TURBO IS ON"
    set "T_REVERT=To go back to normal, run PruPru_TurboRede_OFF.bat"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Turbo de Red (ACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE RED (ON)"
    set "T_WHAT=Lo que va a pasar:"
    set "T_ITEM1=- Deteccion automatica de tu adaptador de red activo"
    set "T_ITEM2=- DNS cambiado a Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- Ajustes de TCP documentados por Microsoft (reversibles)"
    set "T_ITEM4=- Prioridad de red/CPU para juegos (SystemResponsiveness)"
    set "T_CONFIRM=Activar el Turbo de Red ahora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/4] Detectando el adaptador de red activo..."
    set "T_ADAPTER_NONE=      No se pudo detectar un adaptador activo. Omitiendo DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS configurado a Cloudflare en ese adaptador."
    set "T_STEP2=[2/4] Ajustando el autotuning de TCP al valor recomendado..."
    set "T_STEP3=[3/4] Cambiando el proveedor de congestion TCP a CTCP..."
    set "T_STEP3_DONE=      Completado (ayuda en conexiones con mayor latencia)."
    set "T_STEP4=[4/4] Priorizando juegos/multimedia en el programador de Windows..."
    set "T_DONE_STEP=      Completado."
    set "T_ACTIVE=TURBO DE RED ACTIVO"
    set "T_REVERT=Para volver a la normalidad, ejecuta PruPru_TurboRede_OFF.bat"
) else (
    title PruPru Digital Services - Turbo de Rede (ATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE REDE (ON)"
    set "T_WHAT=O que vai acontecer:"
    set "T_ITEM1=- Deteccao automatica do seu adaptador de rede ativo"
    set "T_ITEM2=- DNS trocado para Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- Ajustes de TCP documentados pela Microsoft (reversiveis)"
    set "T_ITEM4=- Prioridade de rede/CPU para jogos (SystemResponsiveness)"
    set "T_CONFIRM=Ativar o Turbo de Rede agora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/4] Detectando adaptador de rede ativo..."
    set "T_ADAPTER_NONE=      Nao foi possivel detectar um adaptador ativo. Pulando DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS configurado para Cloudflare nesse adaptador."
    set "T_STEP2=[2/4] Ajustando TCP autotuning para o padrao recomendado..."
    set "T_STEP3=[3/4] Trocando provedor de congestionamento TCP para CTCP..."
    set "T_STEP3_DONE=      Concluido (ajuda em conexoes com latencia mais alta)."
    set "T_STEP4=[4/4] Priorizando jogos/multimidia no agendador do Windows..."
    set "T_DONE_STEP=      Concluido."
    set "T_ACTIVE=TURBO DE REDE ATIVO"
    set "T_REVERT=Para voltar ao normal, rode PruPru_TurboRede_OFF.bat"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
set ADAPTER=
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Sort-Object -Property RouteMetric | Select-Object -First 1 -ExpandProperty InterfaceAlias)"`) do set ADAPTER=%%a
if "!ADAPTER!"=="" (
    echo !T_ADAPTER_NONE!
) else (
    echo !T_ADAPTER_FOUND! !ADAPTER!
    netsh interface ip set dns "!ADAPTER!" static 1.1.1.1 >nul 2>&1
    netsh interface ip add dns "!ADAPTER!" 1.0.0.1 index=2 >nul 2>&1
    echo !T_DNS_DONE!
)

echo %T_STEP2%
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
echo %T_STEP3_DONE%

echo %T_STEP4%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_ACTIVE%
echo   %T_REVERT%
echo ==================================================
pause
'@

$Scripts['PruPru_VerificadorDrivers.bat'] = @'
@echo off
title PruPru Digital Services - Verificador de Drivers
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Verificador de Drivers (SOMENTE LEITURA)
:: Lista dispositivos com problema no Gerenciador de Dispositivos.
:: Nao instala nem atualiza nada.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Driver Checker
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DRIVER CHECKER
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Verificador de Controladores
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - VERIFICADOR DE CONTROLADORES
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Verificador de Drivers
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - VERIFICADOR DE DRIVERS
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_VerificadorDrivers.ps1"

echo.
pause
'@

$Scripts['PruPru_VerificadorDrivers.ps1'] = @'
# PruPru Digital Services - Verificador de Drivers (somente leitura)
# Lista dispositivos com problema no Gerenciador de Dispositivos.
# Nao instala nem atualiza nenhum driver -- so aponta o que precisa
# de atencao, para voce decidir o que fazer.

$ErrorActionPreference = 'SilentlyContinue'
$report = @()
function Add-Line($text) { $script:report += $text }

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}

$codeMaps = @{
    pt = @{
        1=  "Dispositivo nao configurado corretamente"; 3=  "Driver corrompido ou com falta de recursos"
        10= "O dispositivo nao conseguiu iniciar"; 12= "Recursos de hardware insuficientes (conflito)"
        18= "Reinstalar os drivers deste dispositivo"; 19= "Registro do Windows corrompido para este dispositivo"
        21= "Windows esta removendo este dispositivo"; 22= "Dispositivo desativado pelo usuario"
        24= "Dispositivo nao presente ou drivers com falha"; 28= "Drivers nao instalados para este dispositivo"
        31= "Windows nao conseguiu carregar o driver"; 32= "Driver desativado por um servico"
        33= "Windows nao consegue determinar os recursos do dispositivo"; 34= "Windows nao consegue determinar as configuracoes"
        35= "BIOS/firmware nao inclui recursos suficientes"; 36= "Conflito de IRQ (interrupcao)"
        37= "Falha ao inicializar o driver"; 38= "Driver anterior ainda carregado na memoria"
        39= "Driver corrompido ou ausente"; 40= "Chave de registro do servico corrompida"
        41= "Driver carregado, mas dispositivo nao encontrado"; 42= "Dispositivo duplicado detectado"
        43= "Windows parou este dispositivo (falha reportada)"; 44= "Aplicativo desligou o dispositivo"
        45= "Dispositivo nao esta conectado ao computador"; 47= "Dispositivo preparado para remocao segura"
        48= "Driver bloqueado por ser incompativel"; 52= "Driver nao assinado digitalmente"
    }
    en = @{
        1=  "Device is not configured correctly"; 3=  "Driver corrupted or missing resources"
        10= "The device failed to start"; 12= "Insufficient hardware resources (conflict)"
        18= "Reinstall the drivers for this device"; 19= "Windows registry corrupted for this device"
        21= "Windows is removing this device"; 22= "Device disabled by the user"
        24= "Device not present or drivers failed"; 28= "Drivers not installed for this device"
        31= "Windows could not load the driver"; 32= "Driver disabled by a service"
        33= "Windows cannot determine the device's resources"; 34= "Windows cannot determine the settings"
        35= "BIOS/firmware doesn't include enough resources"; 36= "IRQ (interrupt) conflict"
        37= "Failed to initialize the driver"; 38= "A previous driver is still loaded in memory"
        39= "Driver corrupted or missing"; 40= "Service registry key corrupted"
        41= "Driver loaded, but device not found"; 42= "Duplicate device detected"
        43= "Windows stopped this device (failure reported)"; 44= "An application shut down the device"
        45= "Device is not connected to the computer"; 47= "Device is ready for safe removal"
        48= "Driver blocked for being incompatible"; 52= "Driver is not digitally signed"
    }
    es = @{
        1=  "El dispositivo no esta configurado correctamente"; 3=  "Driver corrupto o con falta de recursos"
        10= "El dispositivo no pudo iniciar"; 12= "Recursos de hardware insuficientes (conflicto)"
        18= "Reinstala los drivers de este dispositivo"; 19= "Registro de Windows corrupto para este dispositivo"
        21= "Windows esta quitando este dispositivo"; 22= "Dispositivo deshabilitado por el usuario"
        24= "Dispositivo no presente o drivers con fallas"; 28= "Drivers no instalados para este dispositivo"
        31= "Windows no pudo cargar el driver"; 32= "Driver deshabilitado por un servicio"
        33= "Windows no puede determinar los recursos del dispositivo"; 34= "Windows no puede determinar la configuracion"
        35= "El BIOS/firmware no incluye recursos suficientes"; 36= "Conflicto de IRQ (interrupcion)"
        37= "Fallo al inicializar el driver"; 38= "Un driver anterior sigue cargado en memoria"
        39= "Driver corrupto o ausente"; 40= "Clave de registro del servicio corrupta"
        41= "Driver cargado, pero dispositivo no encontrado"; 42= "Dispositivo duplicado detectado"
        43= "Windows detuvo este dispositivo (fallo reportado)"; 44= "Una aplicacion apago el dispositivo"
        45= "El dispositivo no esta conectado al equipo"; 47= "Dispositivo listo para extraccion segura"
        48= "Driver bloqueado por ser incompatible"; 52= "El driver no esta firmado digitalmente"
    }
}
$codeMap = $codeMaps[$Lang2]

$T = @{
    pt = @{
        HtmlLang = "pt-BR"; Title = "Verificador de Drivers"
        Generated = "{0} - Gerado em {1} - Relatorio informativo, nada foi alterado"
        Banner1 = "PRUPRU DIGITAL SERVICES - VERIFICADOR DE DRIVERS"; Banner2 = "Gerado em {0}"
        Banner3 = "Relatorio informativo - nada foi instalado ou alterado."
        Passo1 = "[1/2] Verificando dispositivos com problema..."; Passo2 = "[2/2] Verificando versao do Windows..."
        SecProblemas = "DISPOSITIVOS COM PROBLEMA"; SecVersao = "VERSAO DO WINDOWS"; SecResumo = "RESUMO"
        NenhumProblema1 = "Nenhum dispositivo com problema encontrado. Todos os drivers"
        NenhumProblema2 = "instalados estao funcionando sem erro reportado pelo Windows."
        DispositivoAlerta = "[ALERTA] {0}"; CodigoLinha = "         Codigo {0} - {1}"
        CodigoDesconhecido = "Codigo de erro {0} (consulte o Gerenciador de Dispositivos)"
        VersaoLinha = "{0} - Build {1}"
        VersaoNota1 = "(Para verificar atualizacoes de driver disponiveis, use o"
        VersaoNota2 = "Diagnostico do PC no painel PruPru, que checa atualizacoes"
        VersaoNota3 = "pendentes do Windows Update.)"
        ResumoOk = "Nenhum problema de driver encontrado."
        ResumoAlerta = "[ATENCAO] {0} dispositivo(s) com problema."
        ResumoRecom1 = "Recomendacao: reinstale ou atualize o driver pelo site do"
        ResumoRecom2 = "fabricante do componente, ou pelo Windows Update."
        Concluido = "VERIFICACAO CONCLUIDA"; Salvo = "Relatorio salvo em:"
        Encontrados = "{0} dispositivo(s) com problema encontrados."
    }
    en = @{
        HtmlLang = "en"; Title = "Driver Checker"
        Generated = "{0} - Generated on {1} - Informational report, nothing was changed"
        Banner1 = "PRUPRU DIGITAL SERVICES - DRIVER CHECKER"; Banner2 = "Generated on {0}"
        Banner3 = "Informational report - nothing was installed or changed."
        Passo1 = "[1/2] Checking devices with problems..."; Passo2 = "[2/2] Checking Windows version..."
        SecProblemas = "DEVICES WITH PROBLEMS"; SecVersao = "WINDOWS VERSION"; SecResumo = "SUMMARY"
        NenhumProblema1 = "No problem devices found. All installed drivers are"
        NenhumProblema2 = "working with no error reported by Windows."
        DispositivoAlerta = "[WARNING] {0}"; CodigoLinha = "         Code {0} - {1}"
        CodigoDesconhecido = "Error code {0} (check Device Manager)"
        VersaoLinha = "{0} - Build {1}"
        VersaoNota1 = "(To check for available driver updates, use"
        VersaoNota2 = "PC Diagnostics in the PruPru panel, which checks for"
        VersaoNota3 = "pending Windows Update items.)"
        ResumoOk = "No driver problems found."
        ResumoAlerta = "[WARNING] {0} device(s) with problems."
        ResumoRecom1 = "Recommendation: reinstall or update the driver from the"
        ResumoRecom2 = "component manufacturer's website, or via Windows Update."
        Concluido = "CHECK COMPLETE"; Salvo = "Report saved to:"
        Encontrados = "{0} device(s) with problems found."
    }
    es = @{
        HtmlLang = "es"; Title = "Verificador de Controladores"
        Generated = "{0} - Generado el {1} - Informe informativo, no se cambio nada"
        Banner1 = "PRUPRU DIGITAL SERVICES - VERIFICADOR DE CONTROLADORES"; Banner2 = "Generado el {0}"
        Banner3 = "Informe informativo - no se instalo ni cambio nada."
        Passo1 = "[1/2] Verificando dispositivos con problemas..."; Passo2 = "[2/2] Verificando la version de Windows..."
        SecProblemas = "DISPOSITIVOS CON PROBLEMAS"; SecVersao = "VERSION DE WINDOWS"; SecResumo = "RESUMEN"
        NenhumProblema1 = "No se encontraron dispositivos con problemas. Todos los"
        NenhumProblema2 = "drivers instalados funcionan sin errores reportados por Windows."
        DispositivoAlerta = "[ATENCION] {0}"; CodigoLinha = "         Codigo {0} - {1}"
        CodigoDesconhecido = "Codigo de error {0} (consulta el Administrador de dispositivos)"
        VersaoLinha = "{0} - Build {1}"
        VersaoNota1 = "(Para verificar actualizaciones de driver disponibles, usa"
        VersaoNota2 = "el Diagnostico del PC en el panel de PruPru, que revisa"
        VersaoNota3 = "actualizaciones pendientes de Windows Update.)"
        ResumoOk = "No se encontraron problemas de drivers."
        ResumoAlerta = "[ATENCION] {0} dispositivo(s) con problemas."
        ResumoRecom1 = "Recomendacion: reinstala o actualiza el driver desde el sitio"
        ResumoRecom2 = "del fabricante del componente, o mediante Windows Update."
        Concluido = "VERIFICACION COMPLETADA"; Salvo = "Informe guardado en:"
        Encontrados = "{0} dispositivo(s) con problemas encontrados."
    }
}[$Lang2]

function ConvertTo-PruPruHtml($titulo, $lines) {
    function EscapeHtml($s) { $s -replace '&','&amp;' -replace '<','&lt;' -replace '>','&gt;' }
    $bodyHtml = ($lines | ForEach-Object {
        $line = $_
        if ($line -match '^--(.+)--$') {
            "<h3>$(EscapeHtml $Matches[1].Trim())</h3>"
        } elseif ($line -match '\[(ALERTA|ATENCAO|WARNING|ATENCION)\]') {
            "<p class='alerta'>$(EscapeHtml $line)</p>"
        } elseif ($line -eq '') {
            "<div class='spacer'></div>"
        } else {
            "<p>$(EscapeHtml $line)</p>"
        }
    }) -join "`n"
    @"
<!DOCTYPE html>
<html lang="$($T.HtmlLang)">
<head>
<meta charset="UTF-8">
<title>$titulo - PruPru Digital Services</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@700&family=Montserrat:wght@400;600&display=swap');
  body { font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; background:#F7F9FB; color:#0B1F3A; margin:0; padding:0; }
  .header { background:#00205A; color:#fff; padding:24px 32px; }
  .header h1 { margin:0; font-size:22px; font-family:'Space Grotesk', sans-serif; }
  .header p { margin:4px 0 0; font-size:13px; opacity:0.85; }
  .content { max-width:720px; margin:24px auto; background:#fff; border-radius:8px; padding:24px 32px; box-shadow:0 1px 4px rgba(0,32,90,0.08); }
  h3 { color:#00205A; font-family:'Space Grotesk', sans-serif; border-bottom:2px solid #349CFA; padding-bottom:6px; margin-top:28px; }
  p { margin:4px 0; font-size:14px; line-height:1.5; white-space:pre-wrap; }
  .alerta { color:#B00020; font-weight:600; background:#FDECEC; padding:6px 10px; border-radius:4px; }
  .spacer { height:8px; }
  .footer { text-align:center; color:#8a8f98; font-size:12px; margin:24px 0 40px; }
</style>
</head>
<body>
  <div class="header">
    <h1>PruPru Digital Services</h1>
    <p>$($T.Generated -f $titulo, (Get-Date -Format 'dd/MM/yyyy HH:mm'))</p>
  </div>
  <div class="content">
$bodyHtml
  </div>
  <div class="footer">prupru.org</div>
</body>
</html>
"@
}

Add-Line "=================================================="
Add-Line "  $($T.Banner1)"
Add-Line "  $($T.Banner2 -f (Get-Date -Format 'dd/MM/yyyy HH:mm'))"
Add-Line "  $($T.Banner3)"
Add-Line "=================================================="
Add-Line ""

Write-Host $T.Passo1
Add-Line "-- $($T.SecProblemas) --"
$problemDevices = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 }

if ($problemDevices.Count -eq 0) {
    Add-Line $T.NenhumProblema1
    Add-Line $T.NenhumProblema2
} else {
    foreach ($dev in $problemDevices) {
        $code = $dev.ConfigManagerErrorCode
        $explicacao = if ($codeMap.ContainsKey($code)) { $codeMap[$code] } else { $T.CodigoDesconhecido -f $code }
        Add-Line ($T.DispositivoAlerta -f $dev.Name)
        Add-Line ($T.CodigoLinha -f $code, $explicacao)
    }
}
Add-Line ""

Write-Host $T.Passo2
Add-Line "-- $($T.SecVersao) --"
$os = Get-CimInstance Win32_OperatingSystem
Add-Line ($T.VersaoLinha -f $os.Caption, $os.BuildNumber)
Add-Line $T.VersaoNota1
Add-Line $T.VersaoNota2
Add-Line $T.VersaoNota3
Add-Line ""

Add-Line "-- $($T.SecResumo) --"
if ($problemDevices.Count -eq 0) {
    Add-Line $T.ResumoOk
} else {
    Add-Line ($T.ResumoAlerta -f $problemDevices.Count)
    Add-Line $T.ResumoRecom1
    Add-Line $T.ResumoRecom2
}

$desktopPath = [Environment]::GetFolderPath('Desktop')
$reportPath = Join-Path $desktopPath "PruPru_VerificadorDrivers_$(Get-Date -Format 'yyyyMMdd_HHmm').html"
ConvertTo-PruPruHtml $T.Title $report | Out-File -FilePath $reportPath -Encoding UTF8
Start-Process $reportPath

Write-Host ""
Write-Host "=================================================="
Write-Host "  $($T.Concluido)"
Write-Host "  $($T.Salvo)"
Write-Host "  $reportPath"
Write-Host "=================================================="
if ($problemDevices.Count -gt 0) {
    Write-Host ""
    Write-Host ($T.Encontrados -f $problemDevices.Count) -ForegroundColor Yellow
}
'@
$Scripts['PruPru_TweaksPrivacidade.bat'] = @'
@echo off
title PruPru Digital Services - Tweaks de Privacidade e Desempenho
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Tweaks de Privacidade e Desempenho
:: Painel com checkboxes, 100% offline, tudo reversivel.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Privacy and Performance Tweaks
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Ajustes de Privacidad y Rendimiento
) else (
    title PruPru Digital Services - Tweaks de Privacidade e Desempenho
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_TweaksPrivacidade.ps1"
'@

$Scripts['PruPru_TweaksPrivacidade.ps1'] = @'
# PruPru Digital Services - Tweaks de Privacidade e Desempenho
# Painel com checkboxes (estilo WinUtil): marque o que quer LIGADO,
# desmarque o que quer DESLIGADO, clique em Aplicar. 100% offline,
# nada e apagado, tudo pode ser desfeito voltando aqui e desmarcando.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'SilentlyContinue'

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        Titulo = "PruPru - Tweaks de Privacidade e Desempenho"
        Sub = "100% offline. Marque para ligar, desmarque para desligar, e clique em Aplicar."
        Aplicar = "Aplicar selecionados"
        Fechar = "Fechar"
        Status_Pronto = "Pronto."
        Status_Aplicando = "Aplicando ajustes..."
        Status_Concluido = "Concluido! Alguns ajustes podem pedir reinicio para efeito completo."
        Cat_Privacidade = "Privacidade"
        Cat_Desempenho = "Desempenho"
        Cat_Interface = "Interface"
        Desc_Telemetria = "Reduzir telemetria enviada a Microsoft"
        Desc_SysMain = "Desativar SysMain (Superfetch) - libera disco em HD/SSD antigo"
        Desc_Dicas = "Desativar dicas/sugestoes/anuncios no menu Iniciar"
        Desc_Toast = "Desativar notificacoes toast (menos interrupcoes)"
        Desc_Cortana = "Desativar Cortana"
        Desc_Visual = "Efeitos visuais em modo desempenho (menos animacao)"
        Desc_DVR = "Desativar Game DVR / Xbox Game Bar em segundo plano"
    }
    en = @{
        Titulo = "PruPru - Privacy and Performance Tweaks"
        Sub = "100% offline. Check to turn on, uncheck to turn off, then click Apply."
        Aplicar = "Apply selected"
        Fechar = "Close"
        Status_Pronto = "Ready."
        Status_Aplicando = "Applying tweaks..."
        Status_Concluido = "Done! Some tweaks may need a restart to fully apply."
        Cat_Privacidade = "Privacy"
        Cat_Desempenho = "Performance"
        Cat_Interface = "Interface"
        Desc_Telemetria = "Reduce telemetry sent to Microsoft"
        Desc_SysMain = "Disable SysMain (Superfetch) - frees up disk on older HDD/SSD"
        Desc_Dicas = "Disable Start menu tips/suggestions/ads"
        Desc_Toast = "Disable toast notifications (fewer interruptions)"
        Desc_Cortana = "Disable Cortana"
        Desc_Visual = "Visual effects set to performance (less animation)"
        Desc_DVR = "Disable background Game DVR / Xbox Game Bar"
    }
    es = @{
        Titulo = "PruPru - Ajustes de Privacidad y Rendimiento"
        Sub = "100% sin conexion. Marca para activar, desmarca para desactivar y haz clic en Aplicar."
        Aplicar = "Aplicar seleccionados"
        Fechar = "Cerrar"
        Status_Pronto = "Listo."
        Status_Aplicando = "Aplicando ajustes..."
        Status_Concluido = "Listo! Algunos ajustes pueden necesitar reiniciar para aplicarse del todo."
        Cat_Privacidade = "Privacidad"
        Cat_Desempenho = "Rendimiento"
        Cat_Interface = "Interfaz"
        Desc_Telemetria = "Reducir telemetria enviada a Microsoft"
        Desc_SysMain = "Desactivar SysMain (Superfetch) - libera disco en HDD/SSD antiguo"
        Desc_Dicas = "Desactivar sugerencias/anuncios en el menu Inicio"
        Desc_Toast = "Desactivar notificaciones toast (menos interrupciones)"
        Desc_Cortana = "Desactivar Cortana"
        Desc_Visual = "Efectos visuales en modo rendimiento (menos animacion)"
        Desc_DVR = "Desactivar Game DVR / Xbox Game Bar en segundo plano"
    }
}[$Lang2]

# Cada tweak: Categoria, DescKey, Get (estado atual), On, Off.
$Tweaks = @(
    [PSCustomObject]@{ Cat="Cat_Privacidade"; DescKey="Desc_Telemetria"
        Get = { (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue) -eq 0 }
        On  = {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force | Out-Null
            Stop-Service -Name "DiagTrack" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "DiagTrack" -StartupType Disabled -ErrorAction SilentlyContinue
        }
        Off = {
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -ErrorAction SilentlyContinue
            Set-Service -Name "DiagTrack" -StartupType Automatic -ErrorAction SilentlyContinue
            Start-Service -Name "DiagTrack" -ErrorAction SilentlyContinue
        }
    },
    [PSCustomObject]@{ Cat="Cat_Privacidade"; DescKey="Desc_Cortana"
        Get = { (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue) -eq 0 }
        On  = {
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -PropertyType DWord -Value 0 -Force | Out-Null
        }
        Off = { Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -ErrorAction SilentlyContinue }
    },
    [PSCustomObject]@{ Cat="Cat_Desempenho"; DescKey="Desc_SysMain"
        Get = { (Get-Service -Name "SysMain" -ErrorAction SilentlyContinue).StartType -eq 'Disabled' }
        On  = { Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue; Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue }
        Off = { Set-Service -Name "SysMain" -StartupType Automatic -ErrorAction SilentlyContinue; Start-Service -Name "SysMain" -ErrorAction SilentlyContinue }
    },
    [PSCustomObject]@{ Cat="Cat_Desempenho"; DescKey="Desc_Visual"
        Get = { (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -ErrorAction SilentlyContinue) -eq 3 }
        On  = { New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -PropertyType DWord -Value 3 -Force | Out-Null }
        Off = { New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -PropertyType DWord -Value 0 -Force | Out-Null }
    },
    [PSCustomObject]@{ Cat="Cat_Desempenho"; DescKey="Desc_DVR"
        Get = { (Get-ItemPropertyValue -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -ErrorAction SilentlyContinue) -eq 0 }
        On  = {
            New-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
            New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Force | Out-Null
            New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -PropertyType DWord -Value 0 -Force | Out-Null
        }
        Off = {
            New-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -PropertyType DWord -Value 1 -Force | Out-Null
            Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -ErrorAction SilentlyContinue
        }
    },
    [PSCustomObject]@{ Cat="Cat_Interface"; DescKey="Desc_Dicas"
        Get = { (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -ErrorAction SilentlyContinue) -eq 0 }
        On  = {
            New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -PropertyType DWord -Value 0 -Force | Out-Null
            New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -PropertyType DWord -Value 0 -Force | Out-Null
        }
        Off = {
            New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -PropertyType DWord -Value 1 -Force | Out-Null
            New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -PropertyType DWord -Value 1 -Force | Out-Null
        }
    },
    [PSCustomObject]@{ Cat="Cat_Interface"; DescKey="Desc_Toast"
        Get = { (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -ErrorAction SilentlyContinue) -eq 0 }
        On  = { New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType DWord -Value 0 -Force | Out-Null }
        Off = { New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType DWord -Value 1 -Force | Out-Null }
    }
)

$colorPrimary = [System.Drawing.Color]::FromArgb(0x00,0x20,0x5A)
$colorAccent  = [System.Drawing.Color]::FromArgb(0x34,0x9C,0xFA)
$colorBg      = [System.Drawing.Color]::FromArgb(0xF7,0xF9,0xFB)
$colorText    = [System.Drawing.Color]::FromArgb(0x0B,0x1F,0x3A)

$form = New-Object System.Windows.Forms.Form
$form.Text = $T.Titulo
$form.Size = New-Object System.Drawing.Size(620, 560)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $colorBg
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(620, 60)
$header.Location = New-Object System.Drawing.Point(0,0)
$header.BackColor = $colorPrimary
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = $T.Titulo
$title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::White
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(15, 8)
$header.Controls.Add($title)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = $T.Sub
$sub.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$sub.ForeColor = [System.Drawing.Color]::White
$sub.AutoSize = $true
$sub.Location = New-Object System.Drawing.Point(15, 34)
$header.Controls.Add($sub)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(590, 380)
$panel.Location = New-Object System.Drawing.Point(15, 72)
$panel.AutoScroll = $true
$form.Controls.Add($panel)

$checkboxes = @{}
$y = 5
$categoriasVistas = @{}
foreach ($tw in $Tweaks) {
    if (-not $categoriasVistas.ContainsKey($tw.Cat)) {
        $catLbl = New-Object System.Windows.Forms.Label
        $catLbl.Text = $T[$tw.Cat]
        $catLbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $catLbl.ForeColor = $colorPrimary
        $catLbl.AutoSize = $true
        $catLbl.Location = New-Object System.Drawing.Point(5, $y)
        $panel.Controls.Add($catLbl)
        $y += 26
        $categoriasVistas[$tw.Cat] = $true
    }
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $T[$tw.DescKey]
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $chk.ForeColor = $colorText
    $chk.AutoSize = $true
    $chk.Location = New-Object System.Drawing.Point(15, $y)
    $chk.Checked = (& $tw.Get)
    $panel.Controls.Add($chk)
    $checkboxes[$tw] = $chk
    $y += 24
}

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = $T.Status_Pronto
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$statusLabel.ForeColor = $colorText
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(15, 460)
$form.Controls.Add($statusLabel)

$btnAplicar = New-Object System.Windows.Forms.Button
$btnAplicar.Text = $T.Aplicar
$btnAplicar.Size = New-Object System.Drawing.Size(180, 36)
$btnAplicar.Location = New-Object System.Drawing.Point(300, 480)
$btnAplicar.BackColor = $colorAccent
$btnAplicar.ForeColor = [System.Drawing.Color]::White
$btnAplicar.FlatStyle = 'Flat'
$btnAplicar.Add_Click({
    $statusLabel.Text = $T.Status_Aplicando
    $form.Refresh()
    foreach ($tw in $checkboxes.Keys) {
        $chk = $checkboxes[$tw]
        $ligadoAgora = (& $tw.Get)
        if ($chk.Checked -and -not $ligadoAgora) {
            & $tw.On
        } elseif (-not $chk.Checked -and $ligadoAgora) {
            & $tw.Off
        }
    }
    $statusLabel.Text = $T.Status_Concluido
    [System.Windows.Forms.MessageBox]::Show($T.Status_Concluido, $T.Titulo, 'OK', 'Information') | Out-Null
}.GetNewClosure())
$form.Controls.Add($btnAplicar)

$btnFechar = New-Object System.Windows.Forms.Button
$btnFechar.Text = $T.Fechar
$btnFechar.Size = New-Object System.Drawing.Size(100, 36)
$btnFechar.Location = New-Object System.Drawing.Point(490, 480)
$btnFechar.FlatStyle = 'Flat'
$btnFechar.Add_Click({ $form.Close() }.GetNewClosure())
$form.Controls.Add($btnFechar)

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($form)
'@

$Scripts['PruPru_InstaladorApps.bat'] = @'
@echo off
title PruPru Digital Services - Instalador de Aplicativos
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Instalador de Aplicativos (via winget)
:: ATENCAO: esta e a unica ferramenta do PruPru que precisa de
:: internet -- ela baixa os instaladores dos programas marcados.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - App Installer
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Instalador de Aplicaciones
) else (
    title PruPru Digital Services - Instalador de Aplicativos
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_InstaladorApps.ps1"
'@

$Scripts['PruPru_InstaladorApps.ps1'] = @'
# PruPru Digital Services - Instalador de Aplicativos
# Painel com checkboxes (estilo WinUtil): marque os programas, clique
# em Instalar. Usa o winget do proprio Windows. ATENCAO: esta ferramenta
# precisa de internet para baixar os instaladores -- as demais ferramentas
# do PruPru nao precisam.

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'SilentlyContinue'

$langFilePath2 = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "lang.txt"
$Lang2 = "pt"
if (Test-Path $langFilePath2) {
    $saved2 = (Get-Content -Path $langFilePath2 -Raw -ErrorAction SilentlyContinue)
    if ($saved2) { $saved2 = $saved2.Trim() }
    if ($saved2 -in @("pt","en","es")) { $Lang2 = $saved2 }
}
$T = @{
    pt = @{
        Titulo = "PruPru - Instalador de Aplicativos"
        Sub = "Precisa de internet. Marque os programas e clique em Instalar (via winget)."
        Instalar = "Instalar selecionados"
        Fechar = "Fechar"
        Status_Pronto = "Pronto."
        Status_SemWinget = "winget nao foi encontrado neste Windows. Atualize a 'Instalador de Aplicativos' pela Microsoft Store e tente novamente."
        Status_Instalando = "Instalando: {0}..."
        Status_Concluido = "Concluido!"
        Cat_Navegadores = "Navegadores"
        Cat_Utilitarios = "Utilitarios"
        Cat_Multimidia = "Multimidia"
        Cat_Comunicacao = "Comunicacao"
        Cat_Documentos = "Documentos"
        Cat_Desenvolvimento = "Desenvolvimento"
    }
    en = @{
        Titulo = "PruPru - App Installer"
        Sub = "Requires internet. Check the apps and click Install (via winget)."
        Instalar = "Install selected"
        Fechar = "Close"
        Status_Pronto = "Ready."
        Status_SemWinget = "winget was not found on this Windows. Update 'App Installer' from the Microsoft Store and try again."
        Status_Instalando = "Installing: {0}..."
        Status_Concluido = "Done!"
        Cat_Navegadores = "Browsers"
        Cat_Utilitarios = "Utilities"
        Cat_Multimidia = "Multimedia"
        Cat_Comunicacao = "Communication"
        Cat_Documentos = "Documents"
        Cat_Desenvolvimento = "Development"
    }
    es = @{
        Titulo = "PruPru - Instalador de Aplicaciones"
        Sub = "Necesita internet. Marca los programas y haz clic en Instalar (via winget)."
        Instalar = "Instalar seleccionados"
        Fechar = "Cerrar"
        Status_Pronto = "Listo."
        Status_SemWinget = "No se encontro winget en este Windows. Actualiza 'Instalador de aplicaciones' desde Microsoft Store e intenta de nuevo."
        Status_Instalando = "Instalando: {0}..."
        Status_Concluido = "Listo!"
        Cat_Navegadores = "Navegadores"
        Cat_Utilitarios = "Utilidades"
        Cat_Multimidia = "Multimedia"
        Cat_Comunicacao = "Comunicacion"
        Cat_Documentos = "Documentos"
        Cat_Desenvolvimento = "Desarrollo"
    }
}[$Lang2]

$Apps = @(
    [PSCustomObject]@{ Cat="Cat_Navegadores"; Nome="Google Chrome"; Winget="Google.Chrome" }
    [PSCustomObject]@{ Cat="Cat_Navegadores"; Nome="Mozilla Firefox"; Winget="Mozilla.Firefox" }
    [PSCustomObject]@{ Cat="Cat_Navegadores"; Nome="Brave"; Winget="Brave.Brave" }
    [PSCustomObject]@{ Cat="Cat_Utilitarios"; Nome="7-Zip"; Winget="7zip.7zip" }
    [PSCustomObject]@{ Cat="Cat_Utilitarios"; Nome="WinRAR"; Winget="RARLab.WinRAR" }
    [PSCustomObject]@{ Cat="Cat_Utilitarios"; Nome="Everything (busca de arquivos)"; Winget="voidtools.Everything" }
    [PSCustomObject]@{ Cat="Cat_Utilitarios"; Nome="Microsoft PowerToys"; Winget="Microsoft.PowerToys" }
    [PSCustomObject]@{ Cat="Cat_Utilitarios"; Nome="Revo Uninstaller"; Winget="RevoUninstaller.RevoUninstaller" }
    [PSCustomObject]@{ Cat="Cat_Multimidia"; Nome="VLC Media Player"; Winget="VideoLAN.VLC" }
    [PSCustomObject]@{ Cat="Cat_Multimidia"; Nome="Spotify"; Winget="Spotify.Spotify" }
    [PSCustomObject]@{ Cat="Cat_Multimidia"; Nome="OBS Studio"; Winget="OBSProject.OBSStudio" }
    [PSCustomObject]@{ Cat="Cat_Comunicacao"; Nome="Discord"; Winget="Discord.Discord" }
    [PSCustomObject]@{ Cat="Cat_Comunicacao"; Nome="Telegram"; Winget="Telegram.TelegramDesktop" }
    [PSCustomObject]@{ Cat="Cat_Comunicacao"; Nome="AnyDesk"; Winget="AnyDesk.AnyDesk" }
    [PSCustomObject]@{ Cat="Cat_Documentos"; Nome="Adobe Acrobat Reader"; Winget="Adobe.Acrobat.Reader.64-bit" }
    [PSCustomObject]@{ Cat="Cat_Documentos"; Nome="LibreOffice"; Winget="TheDocumentFoundation.LibreOffice" }
    [PSCustomObject]@{ Cat="Cat_Documentos"; Nome="Sumatra PDF"; Winget="SumatraPDF.SumatraPDF" }
    [PSCustomObject]@{ Cat="Cat_Desenvolvimento"; Nome="Visual Studio Code"; Winget="Microsoft.VisualStudioCode" }
    [PSCustomObject]@{ Cat="Cat_Desenvolvimento"; Nome="Git"; Winget="Git.Git" }
    [PSCustomObject]@{ Cat="Cat_Desenvolvimento"; Nome="Node.js LTS"; Winget="OpenJS.NodeJS.LTS" }
)

$colorPrimary = [System.Drawing.Color]::FromArgb(0x00,0x20,0x5A)
$colorAccent  = [System.Drawing.Color]::FromArgb(0x34,0x9C,0xFA)
$colorBg      = [System.Drawing.Color]::FromArgb(0xF7,0xF9,0xFB)
$colorText    = [System.Drawing.Color]::FromArgb(0x0B,0x1F,0x3A)

$form = New-Object System.Windows.Forms.Form
$form.Text = $T.Titulo
$form.Size = New-Object System.Drawing.Size(620, 620)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $colorBg
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(620, 60)
$header.Location = New-Object System.Drawing.Point(0,0)
$header.BackColor = $colorPrimary
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = $T.Titulo
$title.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::White
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(15, 8)
$header.Controls.Add($title)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = $T.Sub
$sub.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$sub.ForeColor = [System.Drawing.Color]::White
$sub.AutoSize = $true
$sub.Location = New-Object System.Drawing.Point(15, 34)
$header.Controls.Add($sub)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(590, 440)
$panel.Location = New-Object System.Drawing.Point(15, 72)
$panel.AutoScroll = $true
$form.Controls.Add($panel)

$checkboxes = @{}
$y = 5
$categoriasVistas = @{}
foreach ($app in $Apps) {
    if (-not $categoriasVistas.ContainsKey($app.Cat)) {
        $catLbl = New-Object System.Windows.Forms.Label
        $catLbl.Text = $T[$app.Cat]
        $catLbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
        $catLbl.ForeColor = $colorPrimary
        $catLbl.AutoSize = $true
        $catLbl.Location = New-Object System.Drawing.Point(5, $y)
        $panel.Controls.Add($catLbl)
        $y += 26
        $categoriasVistas[$app.Cat] = $true
    }
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $app.Nome
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $chk.ForeColor = $colorText
    $chk.AutoSize = $true
    $chk.Location = New-Object System.Drawing.Point(15, $y)
    $panel.Controls.Add($chk)
    $checkboxes[$app] = $chk
    $y += 24
}

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = $T.Status_Pronto
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
$statusLabel.ForeColor = $colorText
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(15, 522)
$statusLabel.MaximumSize = New-Object System.Drawing.Size(590, 0)
$form.Controls.Add($statusLabel)

$btnInstalar = New-Object System.Windows.Forms.Button
$btnInstalar.Text = $T.Instalar
$btnInstalar.Size = New-Object System.Drawing.Size(180, 36)
$btnInstalar.Location = New-Object System.Drawing.Point(300, 545)
$btnInstalar.BackColor = $colorAccent
$btnInstalar.ForeColor = [System.Drawing.Color]::White
$btnInstalar.FlatStyle = 'Flat'
$btnInstalar.Add_Click({
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        [System.Windows.Forms.MessageBox]::Show($T.Status_SemWinget, $T.Titulo, 'OK', 'Warning') | Out-Null
        return
    }
    $btnInstalar.Enabled = $false
    foreach ($app in $checkboxes.Keys) {
        $chk = $checkboxes[$app]
        if ($chk.Checked) {
            $statusLabel.Text = ($T.Status_Instalando -f $app.Nome)
            $form.Refresh()
            Start-Process -FilePath "winget" -ArgumentList @(
                "install", "--id", $app.Winget, "--silent",
                "--accept-package-agreements", "--accept-source-agreements", "-e"
            ) -Wait -WindowStyle Hidden
        }
    }
    $statusLabel.Text = $T.Status_Concluido
    $btnInstalar.Enabled = $true
    [System.Windows.Forms.MessageBox]::Show($T.Status_Concluido, $T.Titulo, 'OK', 'Information') | Out-Null
}.GetNewClosure())
$form.Controls.Add($btnInstalar)

$btnFechar = New-Object System.Windows.Forms.Button
$btnFechar.Text = $T.Fechar
$btnFechar.Size = New-Object System.Drawing.Size(100, 36)
$btnFechar.Location = New-Object System.Drawing.Point(490, 545)
$btnFechar.FlatStyle = 'Flat'
$btnFechar.Add_Click({ $form.Close() }.GetNewClosure())
$form.Controls.Add($btnFechar)

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($form)
'@




# ------------------------------------------------------------------
# Extrai os scripts embutidos para uma pasta de trabalho.
# NAO usar %TEMP% aqui: as proprias ferramentas (Otimizador,
# Limpar Espaco) limpam %TEMP% e apagariam os scripts rodando.
# ------------------------------------------------------------------
$tempRoot = Join-Path $env:LOCALAPPDATA "PruPru\run"
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
Get-ChildItem -Path $tempRoot -Directory -Filter "PruPru_*" -ErrorAction SilentlyContinue | ForEach-Object {
    try { Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop } catch { }
}

$workDir = Join-Path $tempRoot ("PruPru_" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $workDir -Force | Out-Null

foreach ($name in $Scripts.Keys) {
    $dest = Join-Path $workDir $name
    Set-Content -Path $dest -Value $Scripts[$name] -Encoding ASCII -NoNewline
}

# Log de execucoes - fica em %LocalAppData%\PruPru (persistente, fora da
# pasta "run" que e limpa a cada abertura do app)
$logPath = Join-Path (Join-Path $env:LOCALAPPDATA "PruPru") "PruPru_Log.txt"
function Write-PruPruLog($toolKey) {
    try {
        $linha = "$(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') - $toolKey"
        Add-Content -Path $logPath -Value $linha -Encoding UTF8 -ErrorAction SilentlyContinue
    } catch { }
}

# $toolKey e um identificador estavel (sempre em ingles, ex: "Diagnostico")
# usado no log e no lembrete de manutencao - nao muda com o idioma da UI,
# assim o historico continua consistente mesmo se o usuario trocar de idioma.
function Run-Tool($scriptName, $toolKey) {
    $path = Join-Path $workDir $scriptName
    if (Test-Path $path) {
        Write-PruPruLog $toolKey
        Start-Process -FilePath $path -WorkingDirectory $workDir
    } else {
        [System.Windows.Forms.MessageBox]::Show(($L.MsgFileNotFound -f $path), "PruPru Digital Services", 'OK', 'Error') | Out-Null
    }
}

$colorPrimary = [System.Drawing.Color]::FromArgb(0x00,0x20,0x5A)   # PruPru Blue (Primary)
$colorAccent  = [System.Drawing.Color]::FromArgb(0x34,0x9C,0xFA)   # PruPru Light Blue (Accent)
$colorBg      = [System.Drawing.Color]::FromArgb(0xF7,0xF9,0xFB)   # City Concrete (Background)
$colorText    = [System.Drawing.Color]::FromArgb(0x0B,0x1F,0x3A)   # Texto sobre fundo claro
$colorOnAccent = [System.Drawing.Color]::White                      # Texto sobre botoes de destaque (azul claro)

$form = New-Object System.Windows.Forms.Form
$form.Text = "PruPru Digital Services"
$form.Size = New-Object System.Drawing.Size(560, 1060)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false
$form.BackColor = $colorBg
try {
    $form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($exePath)
} catch { }

# Cabecalho
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(560, 80)
$header.Location = New-Object System.Drawing.Point(0,0)
$header.BackColor = $colorPrimary
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = "PruPru Digital Services"
$title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$title.ForeColor = [System.Drawing.Color]::White
$title.AutoSize = $true
$title.Location = New-Object System.Drawing.Point(20, 15)
$header.Controls.Add($title)

$subtitle = New-Object System.Windows.Forms.Label
$subtitle.Text = $L.Subtitle
$subtitle.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$subtitle.ForeColor = [System.Drawing.Color]::White
$subtitle.AutoSize = $true
$subtitle.Location = New-Object System.Drawing.Point(20, 48)
$header.Controls.Add($subtitle)

# Lembrete de manutencao - le o log de execucoes e avisa se faz tempo
# que Diagnostico/Otimizador/SaudeDisco nao rodam. So depende do log
# que ja existe, sem tarefa agendada nem processo em segundo plano.
$ferramentasManutencao = @("Diagnostico", "Otimizador", "SaudeDisco")
$diasLimite = 14

function Get-TextoLembrete {
    if (-not (Test-Path $logPath)) { return @{ Texto = $L.ReminderNoHistory; Alerta = $true } }
    try {
        $linhas = Get-Content -Path $logPath -Encoding UTF8 -ErrorAction Stop
    } catch { return @{ Texto = $L.ReminderNoHistory; Alerta = $true } }

    $ultimaData = $null
    foreach ($linha in $linhas) {
        foreach ($ferramenta in $ferramentasManutencao) {
            if ($linha -like "*- $ferramenta") {
                $dataTexto = ($linha -split ' - ')[0]
                try {
                    $data = [DateTime]::ParseExact($dataTexto, 'dd/MM/yyyy HH:mm:ss', $null)
                    if (-not $ultimaData -or $data -gt $ultimaData) { $ultimaData = $data }
                } catch { }
            }
        }
    }

    if (-not $ultimaData) {
        return @{ Texto = $L.ReminderNoHistory; Alerta = $true }
    }

    $dias = [Math]::Floor(((Get-Date) - $ultimaData).TotalDays)
    if ($dias -ge $diasLimite) {
        return @{ Texto = ($L.ReminderOverdue -f $dias); Alerta = $true }
    } elseif ($dias -le 0) {
        return @{ Texto = $L.ReminderToday; Alerta = $false }
    } else {
        return @{ Texto = ($L.ReminderDaysAgo -f $dias); Alerta = $false }
    }
}

function Add-SectionLabel($text, $y) {
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text
    $lbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $lbl.ForeColor = $colorText
    $lbl.AutoSize = $true
    $lbl.Location = New-Object System.Drawing.Point(20, $y)
    $form.Controls.Add($lbl)
}

function Add-ToolButton($text, $script, $toolKey, $x, $y, $w, $accent) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size($w, 44)
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderColor = $colorPrimary
    if ($accent) {
        $btn.BackColor = $colorAccent
        $btn.ForeColor = $colorOnAccent
    } else {
        $btn.BackColor = [System.Drawing.Color]::White
        $btn.ForeColor = $colorPrimary
    }
    $btn.Add_Click({ Run-Tool $script $toolKey }.GetNewClosure())
    $form.Controls.Add($btn)
}

$reminderPanel = New-Object System.Windows.Forms.Panel
$reminderPanel.Size = New-Object System.Drawing.Size(520, 26)
$reminderPanel.Location = New-Object System.Drawing.Point(20, 88)
$form.Controls.Add($reminderPanel)

$reminderLabel = New-Object System.Windows.Forms.Label
$reminderLabel.AutoSize = $true
$reminderLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Bold)
$reminderLabel.Location = New-Object System.Drawing.Point(0, 4)
$lembrete = Get-TextoLembrete
$reminderLabel.Text = $lembrete.Texto
$reminderLabel.ForeColor = if ($lembrete.Alerta) { [System.Drawing.Color]::FromArgb(0xB0,0x00,0x20) } else { $colorText }
$reminderPanel.Controls.Add($reminderLabel)

Add-SectionLabel $L.SectionDiag 126
Add-ToolButton $L.BtnDiagnostico  "PruPru_Diagnostico.bat"              "Diagnostico"     20 156 250 $false
Add-ToolButton $L.BtnSaudeDisco   "PruPru_SaudeDisco.bat"               "SaudeDisco"      290 156 250 $false
Add-ToolButton $L.BtnScanner      "PruPru_Scanner_Seguranca.bat"        "Scanner"         20 206 250 $false
Add-ToolButton $L.BtnTeste        "PruPru_TesteIntegridade.bat"         "TesteIntegridade" 290 206 250 $false
Add-ToolButton $L.BtnBackup       "PruPru_BackupConfig.bat"             "BackupConfig"    20 256 520 $false
Add-ToolButton $L.BtnDrivers      "PruPru_VerificadorDrivers.bat"       "VerifDrivers"    20 306 520 $false

Add-SectionLabel $L.SectionOtim 366
Add-ToolButton $L.BtnOtimizador   "PruPru_Otimizador.bat"               "Otimizador"      20 396 250 $false
Add-ToolButton $L.BtnReverter     "PruPru_Reverter.bat"                 "Reverter"        290 396 250 $false
Add-ToolButton $L.BtnLimpar       "PruPru_LimparEspaco.bat"             "LimparEspaco"    20 446 250 $false
Add-ToolButton $L.BtnGerenciador  "PruPru_GerenciadorInicializacao.bat" "GerenciadorInit" 290 446 250 $false
Add-ToolButton $L.BtnDesinstalador "PruPru_DesinstaladorGuiado.bat"     "Desinstalador"   20 496 520 $false

Add-SectionLabel $L.SectionFoco 556
Add-ToolButton $L.BtnFocoOn       "PruPru_FocoJogo_ON.bat"              "FocoJogoOn"      20 586 250 $true
Add-ToolButton $L.BtnFocoOff      "PruPru_FocoJogo_OFF.bat"             "FocoJogoOff"     290 586 250 $false

Add-SectionLabel $L.SectionTurbo 646
Add-ToolButton $L.BtnTurboOn      "PruPru_TurboRede_ON.bat"             "TurboRedeOn"     20 676 250 $true
Add-ToolButton $L.BtnTurboOff     "PruPru_TurboRede_OFF.bat"            "TurboRedeOff"    290 676 250 $false

Add-SectionLabel $L.SectionStream 736
Add-ToolButton $L.BtnStreamOn     "PruPru_ModoStreaming_ON.bat"         "ModoStreamingOn"  20 766 250 $true
Add-ToolButton $L.BtnStreamOff    "PruPru_ModoStreaming_OFF.bat"        "ModoStreamingOff" 290 766 250 $false

Add-SectionLabel $L.SectionExtras 826
Add-ToolButton $L.BtnTweaks       "PruPru_TweaksPrivacidade.bat"        "TweaksPrivacidade" 20 856 250 $true
Add-ToolButton $L.BtnApps         "PruPru_InstaladorApps.bat"           "InstaladorApps"    290 856 250 $false

$footer = New-Object System.Windows.Forms.Label
$footer.Text = "prupru.org  |  v$AppVersion"
$footer.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$footer.ForeColor = $colorText
$footer.AutoSize = $true
$footer.Location = New-Object System.Drawing.Point(20, 926)
$form.Controls.Add($footer)

$updateLink = New-Object System.Windows.Forms.LinkLabel
$updateLink.Text = $L.LinkCheckUpdate
$updateLink.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$updateLink.AutoSize = $true
$updateLink.Location = New-Object System.Drawing.Point(400, 926)
$updateLink.LinkColor = $colorPrimary
$updateLink.Add_Click({ Check-ForUpdate }.GetNewClosure())
$form.Controls.Add($updateLink)

$historyLink = New-Object System.Windows.Forms.LinkLabel
$historyLink.Text = $L.LinkHistory
$historyLink.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$historyLink.AutoSize = $true
$historyLink.Location = New-Object System.Drawing.Point(20, 950)
$historyLink.LinkColor = $colorPrimary
$historyLink.Add_Click({
    New-Item -ItemType Directory -Path (Split-Path $logPath) -Force | Out-Null
    if (-not (Test-Path $logPath)) {
        Set-Content -Path $logPath -Value $L.HistoryHeader -Encoding UTF8
    }
    Start-Process notepad.exe $logPath
}.GetNewClosure())
$form.Controls.Add($historyLink)

$langLabel = New-Object System.Windows.Forms.Label
$langLabel.Text = "$($L.LinkLang):"
$langLabel.Font = New-Object System.Drawing.Font("Segoe UI", 8)
$langLabel.ForeColor = $colorText
$langLabel.AutoSize = $true
$langLabel.Location = New-Object System.Drawing.Point(20, 974)
$form.Controls.Add($langLabel)

$langX = 78
foreach ($langOption in @(
    @{ Code = "pt"; Label = "PT" },
    @{ Code = "en"; Label = "EN" },
    @{ Code = "es"; Label = "ES" }
)) {
    $langLink = New-Object System.Windows.Forms.LinkLabel
    $langLink.Text = $langOption.Label
    $langLink.Font = New-Object System.Drawing.Font("Segoe UI", 8, $(if ($Lang -eq $langOption.Code) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }))
    $langLink.AutoSize = $true
    $langLink.Location = New-Object System.Drawing.Point($langX, 974)
    $langLink.LinkColor = $colorPrimary
    $langLink.Enabled = ($Lang -ne $langOption.Code)
    $langLink.Add_Click({ Set-PruPruLang $langOption.Code }.GetNewClosure())
    $form.Controls.Add($langLink)
    $langX += 28
}

# Checagem silenciosa 1.5s apos abrir, sem travar a exibicao da janela
$updateTimer = New-Object System.Windows.Forms.Timer
$updateTimer.Interval = 1500
$updateTimer.Add_Tick({
    $updateTimer.Stop()
    Check-ForUpdate -Silent
}.GetNewClosure())
$form.Add_Shown({ $updateTimer.Start() }.GetNewClosure())

[System.Windows.Forms.Application]::EnableVisualStyles()
[System.Windows.Forms.Application]::Run($form)
