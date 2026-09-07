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
