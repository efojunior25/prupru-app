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
