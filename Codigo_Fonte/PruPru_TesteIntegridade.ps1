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
