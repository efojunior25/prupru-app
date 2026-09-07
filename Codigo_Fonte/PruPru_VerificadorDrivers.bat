@echo off
title PruPru Digital Services - Verificador de Drivers
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Verificador de Drivers (SOMENTE LEITURA)
:: Lista dispositivos com problema no Gerenciador de Dispositivos.
:: Nao instala nem atualiza nada.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Driver Checker
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DRIVER CHECKER
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Verificador de Controladores
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - VERIFICADOR DE CONTROLADORES
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Verificador de Drivers
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - VERIFICADOR DE DRIVERS
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_VerificadorDrivers.ps1"

echo.
pause
