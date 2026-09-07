@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Turbo de Rede - ATIVAR
:: Ajustes de rede documentados e reversiveis. Sem promessa de
:: milagre: isso reduz latencia/gargalo de configuracao, nao
:: aumenta a velocidade contratada do seu provedor.
:: Para desfazer: rode PruPru_TurboRede_OFF.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Network Turbo (ENABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - NETWORK TURBO (ON)"
    set "T_WHAT=What's going to happen:"
    set "T_ITEM1=- Automatic detection of your active network adapter"
    set "T_ITEM2=- DNS switched to Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- TCP tweaks documented by Microsoft (reversible)"
    set "T_ITEM4=- Network/CPU priority for games (SystemResponsiveness)"
    set "T_CONFIRM=Enable Network Turbo now? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/4] Detecting active network adapter..."
    set "T_ADAPTER_NONE=      Couldn't detect an active adapter. Skipping DNS."
    set "T_ADAPTER_FOUND=      Adapter detected:"
    set "T_DNS_DONE=      DNS set to Cloudflare on that adapter."
    set "T_STEP2=[2/4] Setting TCP autotuning to the recommended default..."
    set "T_STEP3=[3/4] Switching TCP congestion provider to CTCP..."
    set "T_STEP3_DONE=      Done (helps on higher-latency connections)."
    set "T_STEP4=[4/4] Prioritizing games/multimedia in the Windows scheduler..."
    set "T_DONE_STEP=      Done."
    set "T_ACTIVE=NETWORK TURBO IS ON"
    set "T_REVERT=To go back to normal, run PruPru_TurboRede_OFF.bat"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Turbo de Red (ACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE RED (ON)"
    set "T_WHAT=Lo que va a pasar:"
    set "T_ITEM1=- Deteccion automatica de tu adaptador de red activo"
    set "T_ITEM2=- DNS cambiado a Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- Ajustes de TCP documentados por Microsoft (reversibles)"
    set "T_ITEM4=- Prioridad de red/CPU para juegos (SystemResponsiveness)"
    set "T_CONFIRM=Activar el Turbo de Red ahora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/4] Detectando el adaptador de red activo..."
    set "T_ADAPTER_NONE=      No se pudo detectar un adaptador activo. Omitiendo DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS configurado a Cloudflare en ese adaptador."
    set "T_STEP2=[2/4] Ajustando el autotuning de TCP al valor recomendado..."
    set "T_STEP3=[3/4] Cambiando el proveedor de congestion TCP a CTCP..."
    set "T_STEP3_DONE=      Completado (ayuda en conexiones con mayor latencia)."
    set "T_STEP4=[4/4] Priorizando juegos/multimedia en el programador de Windows..."
    set "T_DONE_STEP=      Completado."
    set "T_ACTIVE=TURBO DE RED ACTIVO"
    set "T_REVERT=Para volver a la normalidad, ejecuta PruPru_TurboRede_OFF.bat"
) else (
    title PruPru Digital Services - Turbo de Rede (ATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - TURBO DE REDE (ON)"
    set "T_WHAT=O que vai acontecer:"
    set "T_ITEM1=- Deteccao automatica do seu adaptador de rede ativo"
    set "T_ITEM2=- DNS trocado para Cloudflare (1.1.1.1 / 1.0.0.1)"
    set "T_ITEM3=- Ajustes de TCP documentados pela Microsoft (reversiveis)"
    set "T_ITEM4=- Prioridade de rede/CPU para jogos (SystemResponsiveness)"
    set "T_CONFIRM=Ativar o Turbo de Rede agora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/4] Detectando adaptador de rede ativo..."
    set "T_ADAPTER_NONE=      Nao foi possivel detectar um adaptador ativo. Pulando DNS."
    set "T_ADAPTER_FOUND=      Adaptador detectado:"
    set "T_DNS_DONE=      DNS configurado para Cloudflare nesse adaptador."
    set "T_STEP2=[2/4] Ajustando TCP autotuning para o padrao recomendado..."
    set "T_STEP3=[3/4] Trocando provedor de congestionamento TCP para CTCP..."
    set "T_STEP3_DONE=      Concluido (ajuda em conexoes com latencia mais alta)."
    set "T_STEP4=[4/4] Priorizando jogos/multimidia no agendador do Windows..."
    set "T_DONE_STEP=      Concluido."
    set "T_ACTIVE=TURBO DE REDE ATIVO"
    set "T_REVERT=Para voltar ao normal, rode PruPru_TurboRede_OFF.bat"
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
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
set ADAPTER=
for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "(Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Sort-Object -Property RouteMetric | Select-Object -First 1 -ExpandProperty InterfaceAlias)"`) do set ADAPTER=%%a
if "!ADAPTER!"=="" (
    echo !T_ADAPTER_NONE!
) else (
    echo !T_ADAPTER_FOUND! !ADAPTER!
    netsh interface ip set dns "!ADAPTER!" static 1.1.1.1 >nul 2>&1
    netsh interface ip add dns "!ADAPTER!" 1.0.0.1 index=2 >nul 2>&1
    echo !T_DNS_DONE!
)

echo %T_STEP2%
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set heuristics disabled >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
netsh int tcp set global congestionprovider=ctcp >nul 2>&1
echo %T_STEP3_DONE%

echo %T_STEP4%
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 0xffffffff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_ACTIVE%
echo   %T_REVERT%
echo ==================================================
pause
