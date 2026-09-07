@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Modo Streaming - DESATIVAR
:: Reverte exatamente o que o PruPru_ModoStreaming_ON.bat fez.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Streaming Mode (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - STREAMING MODE (OFF)"
    set "T_STEP1=[1/2] Restoring OBS/Streamlabs normal priority..."
    set "T_STEP2=[2/2] Re-enabling Xbox Game Bar (background recording)..."
    set "T_DONE=STREAMING MODE DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Modo Streaming (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (OFF)"
    set "T_STEP1=[1/2] Restaurando la prioridad normal de OBS/Streamlabs..."
    set "T_STEP2=[2/2] Reactivando Xbox Game Bar (grabacion en segundo plano)..."
    set "T_DONE=MODO STREAMING DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Modo Streaming (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (OFF)"
    set "T_STEP1=[1/2] Voltando prioridade do OBS/Streamlabs ao normal..."
    set "T_STEP2=[2/2] Reativando Xbox Game Bar (gravacao em segundo plano)..."
    set "T_DONE=MODO STREAMING DESATIVADO - TUDO NORMAL DE NOVO"
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
powershell -NoProfile -Command "Get-Process obs64,obs32,'streamlabs-obs' -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'Normal' }" >nul 2>&1

echo %T_STEP2%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 1 /f >nul 2>&1

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
