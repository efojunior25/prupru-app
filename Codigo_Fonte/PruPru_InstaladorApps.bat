@echo off
title PruPru Digital Services - Instalador de Aplicativos
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Instalador de Aplicativos (via winget)
:: ATENCAO: esta e a unica ferramenta do PruPru que precisa de
:: internet -- ela baixa os instaladores dos programas marcados.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - App Installer
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Instalador de Aplicaciones
) else (
    title PruPru Digital Services - Instalador de Aplicativos
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_InstaladorApps.ps1"
