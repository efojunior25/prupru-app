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
