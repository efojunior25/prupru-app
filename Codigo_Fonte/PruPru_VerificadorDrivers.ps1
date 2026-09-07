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
