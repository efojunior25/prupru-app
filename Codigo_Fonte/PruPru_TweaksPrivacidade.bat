@echo off
title PruPru Digital Services - Tweaks de Privacidade e Desempenho
color 0B

:: ============================================================
:: PruPru Digital Services - www.pruprudigital.com.br
:: Tweaks de Privacidade e Desempenho
:: Painel com checkboxes, 100% offline, tudo reversivel.
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
    title PruPru Digital Services - Privacy and Performance Tweaks
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Ajustes de Privacidad y Rendimiento
) else (
    title PruPru Digital Services - Tweaks de Privacidade e Desempenho
)

powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0PruPru_TweaksPrivacidade.ps1"
