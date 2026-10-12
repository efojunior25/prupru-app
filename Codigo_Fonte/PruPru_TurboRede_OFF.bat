@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Turbo de Rede - DESATIVAR
:: Reverte exatamente o que o PruPru_TurboRede_ON.bat mudou,
:: usando os valores padrao oficiais do Windows.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Network Turbo (DISABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - NETWORK TURBO (OFF)"
    set "T_STEP1=[1/4] Detecting active network adapter..."
    set "T_ADAPTER_NONE=      Couldn't detect an active adapter. Skipping DNS."
    set "T_ADAPTER_FOUND=      Adapter detected:"
    set "T_DNS_DONE=      DNS is back to automatic (from your router/ISP)."
    set "T_STEP2=[2/4] Restoring default TCP autotuning..."
    set "T_STEP3=[3/4] Restoring default TCP congestion provider..."
    set "T_STEP4=[4/4] Restoring Windows' default multitasking priority..."
    set "T_DONE_STEP=      Done."
    set "T_DONE=NETWORK TURBO DISABLED - EVERYTHING BACK TO NORMAL"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Turbo de Red (DESACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE RED (OFF)"
    set "T_STEP1=[1/4] Detectando el adaptador de red activo..."
    set "T_ADAPTER_NONE=      No se pudo detectar un adaptador activo. Omitiendo DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      El DNS volvio a ser automatico (de tu router/proveedor)."
    set "T_STEP2=[2/4] Restaurando el autotuning de TCP predeterminado..."
    set "T_STEP3=[3/4] Restaurando el proveedor de congestion TCP predeterminado..."
    set "T_STEP4=[4/4] Restaurando la prioridad predeterminada de Windows para multitarea..."
    set "T_DONE_STEP=      Completado."
    set "T_DONE=TURBO DE RED DESACTIVADO - TODO NORMAL DE NUEVO"
) else (
    title PruPru Digital Services - Turbo de Rede (DESATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE REDE (OFF)"
    set "T_STEP1=[1/4] Detectando adaptador de rede ativo..."
    set "T_ADAPTER_NONE=      Nao foi possivel detectar um adaptador ativo. Pulando DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS voltou a ser automatico (do seu roteador/provedor)."
    set "T_STEP2=[2/4] Restaurando TCP autotuning padrao..."
    set "T_STEP3=[3/4] Restaurando provedor de congestionamento TCP padrao..."
    set "T_STEP4=[4/4] Restaurando prioridade padrao do Windows para multitarefa..."
    set "T_DONE_STEP=      Concluido."
    set "T_DONE=TURBO DE REDE DESATIVADO - TUDO NORMAL DE NOVO"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    set "PP_SELF=%~f0"
    powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath $env:PP_SELF -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.

echo %T_STEP1%
set ADAPTER=
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Sort-Object -Property RouteMetric | Select-Object -First 1 -ExpandProperty InterfaceAlias)"`) do set ADAPTER=%%a
if "!ADAPTER!"=="" (
    echo !T_ADAPTER_NONE!
) else (
    echo !T_ADAPTER_FOUND! !ADAPTER!
    netsh interface ip set dns "!ADAPTER!" dhcp >nul 2>&1
    echo !T_DNS_DONE!
)

echo %T_STEP2%
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set heuristics enabled >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
netsh int tcp set global congestionprovider=default >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP4%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xa /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 20 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
pause
