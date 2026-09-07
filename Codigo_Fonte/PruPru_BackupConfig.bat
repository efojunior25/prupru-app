@echo off
title PruPru Digital Services - Backup de Configuracoes
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Backup de Configuracoes (SOMENTE LEITURA)
:: Salva um registro do que esta configurado agora (energia,
:: DNS, servicos, TCP). Nao restaura nada sozinho -- e um
:: registro de consulta.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Settings Backup
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - SETTINGS BACKUP
    echo   Read-only mode: nothing will be changed
    echo ==================================================
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Copia de Seguridad de Configuracion
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - COPIA DE SEGURIDAD DE CONFIGURACION
    echo   Modo de solo lectura: no se cambiara nada
    echo ==================================================
) else (
    title PruPru Digital Services - Backup de Configuracoes
    echo ==================================================
    echo   PRUPRU DIGITAL SERVICES - BACKUP DE CONFIGURACOES
    echo   Modo somente-leitura: nada sera alterado
    echo ==================================================
)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_BackupConfig.ps1"

echo.
pause
