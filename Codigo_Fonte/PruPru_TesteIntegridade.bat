@echo off
title PruPru Digital Services - Teste de Integridade
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Teste de Integridade Rapido (SOMENTE LEITURA)
:: Popup rapido com veredito honesto sobre RAM, disco e saude
:: do HD/SSD. Nao altera nada no sistema.
:: ============================================================

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    set "PP_SELF=%~f0"
    powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath $env:PP_SELF -Verb RunAs"
    exit /b
)

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"
if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Quick Integrity Test
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Prueba de Integridad Rapida
) else (
    title PruPru Digital Services - Teste de Integridade
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_TesteIntegridade.ps1"
