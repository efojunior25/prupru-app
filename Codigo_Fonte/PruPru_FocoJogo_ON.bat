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
