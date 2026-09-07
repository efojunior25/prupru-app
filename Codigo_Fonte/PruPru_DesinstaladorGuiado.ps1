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
