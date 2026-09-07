@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Foco no Jogo - DESATIVAR
:: Desfaz exatamente o que o PruPru_FocoJogo_ON.bat fez.
:: So remove as regras de firewall criadas por ele (prefixo
:: "PruPru Foco -"), nao mexe em nenhuma regra sua.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Game Focus (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - GAME FOCUS (OFF)"
    set "T_STEP1=[1/2] Restoring Steam's normal priority..."
    set "T_STEP2=[2/2] Removing browser blocks..."
    set "T_DONE=GAME FOCUS DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Enfoque en el Juego (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - ENFOQUE EN EL JUEGO (OFF)"
    set "T_STEP1=[1/2] Restaurando la prioridad normal de Steam..."
    set "T_STEP2=[2/2] Quitando los bloqueos de navegador..."
    set "T_DONE=ENFOQUE EN EL JUEGO DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Foco no Jogo (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - FOCO NO JOGO (OFF)"
    set "T_STEP1=[1/2] Voltando prioridade da Steam ao normal..."
    set "T_STEP2=[2/2] Removendo bloqueios de navegador..."
    set "T_DONE=FOCO NO JOGO DESATIVADO - TUDO NORMAL DE NOVO"
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

echo %T_STEP1%
powershell -NoProfile -Command "Get-Process steam,steamwebhelper -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'Normal' }" >nul 2>&1

echo %T_STEP2%
netsh advfirewall firewall delete rule name="PruPru Foco - Block Chrome" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Chrome x86" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Edge" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Firefox" >nul 2>&1
netsh advfirewall firewall delete rule name="PruPru Foco - Block Brave" >nul 2>&1

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
