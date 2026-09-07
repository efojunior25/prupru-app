@echo off
title PruPru Digital Services - Gerenciador de Inicializacao
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Gerenciador de Inicializacao
:: Ativa/desativa itens de inicializacao SEM apagar nada -- os
:: itens desativados vao para um "cofre" e podem ser reativados
:: a qualquer momento pelo mesmo menu.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Startup Manager
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Administrador de Inicio
) else (
    title PruPru Digital Services - Gerenciador de Inicializacao
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0PruPru_GerenciadorInicializacao.ps1"

pause
