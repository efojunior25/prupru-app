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
