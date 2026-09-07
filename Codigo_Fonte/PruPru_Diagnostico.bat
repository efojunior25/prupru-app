@echo off
title PruPru Digital Services - Diagnostico do PC
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Diagnostico do PC (SOMENTE LEITURA)
:: Nao altera nada. Gera um relatorio completo na Area de
:: Trabalho com specs, saude de disco, espaco livre, updates
:: pendentes e erros recentes.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - PC Diagnostics
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - PC DIAGNOSTICS
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Diagnostico del PC
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DIAGNOSTICO DEL PC
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Diagnostico do PC
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - DIAGNOSTICO DO PC
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_Diagnostico.ps1"

echo.
pause
