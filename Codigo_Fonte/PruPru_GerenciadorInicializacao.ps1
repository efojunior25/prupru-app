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
