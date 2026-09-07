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
