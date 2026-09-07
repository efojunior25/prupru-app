@echo off
title PruPru Digital Services - Desinstalador Guiado
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Desinstalador de Bloatware Guiado
:: Lista programas por tamanho e aciona o desinstalador OFICIAL
:: de cada um -- nunca apaga arquivos por conta propria.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Guided Uninstaller
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Desinstalador Guiado
) else (
    title PruPru Digital Services - Desinstalador Guiado
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_DesinstaladorGuiado.ps1"

pause
