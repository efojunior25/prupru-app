@echo off
title PruPru Digital Services - Saude do Disco
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Saude do Disco (SMART, SOMENTE LEITURA)
:: Nao altera nada. Apenas le indicadores de saude do HD/SSD e
:: avisa se houver risco de falha.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Disk Health
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DISK HEALTH
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Salud del Disco
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SALUD DEL DISCO
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Saude do Disco
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SAUDE DO DISCO
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_SaudeDisco.ps1"

echo.
pause
