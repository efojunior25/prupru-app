@echo off
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Reverte as alteracoes feitas pelo PruPru_Otimizador.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Revert Optimization
    set "T_TITLE=Reverting optimizations"
    set "T_STEP1=[1/3] Re-enabling SysMain..."
    set "T_STEP2=[2/3] Re-enabling telemetry (DiagTrack)..."
    set "T_STEP3=[3/3] Power plan kept on Balanced (Windows default)."
    set "T_DONE=SYSTEM REVERTED TO DEFAULT SETTINGS"
    set "T_NOTE1=To undo 100%% (including temp file cleanup),"
    set "T_NOTE2=use System Restore with the "PruPru_Otimizador" point."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Revertir Optimizacion
    set "T_TITLE=Revirtiendo optimizaciones"
    set "T_STEP1=[1/3] Reactivando SysMain..."
    set "T_STEP2=[2/3] Reactivando telemetria (DiagTrack)..."
    set "T_STEP3=[3/3] Plan de energia mantenido en Equilibrado (predeterminado de Windows)."
    set "T_DONE=SISTEMA REVERTIDO A LA CONFIGURACION PREDETERMINADA"
    set "T_NOTE1=Si quieres deshacer el 100%% (incluyendo la limpieza de temporales),"
    set "T_NOTE2=usa Restaurar sistema con el punto "PruPru_Otimizador"."
) else (
    title PruPru Digital Services - Reverter Otimizacao
    set "T_TITLE=Revertendo otimizacoes"
    set "T_STEP1=[1/3] Reativando SysMain..."
    set "T_STEP2=[2/3] Reativando telemetria (DiagTrack)..."
    set "T_STEP3=[3/3] Plano de energia mantido em Equilibrado (padrao do Windows)."
    set "T_DONE=SISTEMA REVERTIDO AS CONFIGURACOES PADRAO"
    set "T_NOTE1=Se quiser desfazer 100%% (incluindo limpeza de temporarios),"
    set "T_NOTE2=use a Restauracao do Sistema com o ponto "PruPru_Otimizador"."
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    set "PP_SELF=%~f0"
    powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath $env:PP_SELF -Verb RunAs"
    exit /b
)

echo ==================================================
echo   PRUPRU DIGITAL SERVICES
echo   %T_TITLE%
echo ==================================================
echo.

echo %T_STEP1%
sc config "SysMain" start= auto >nul 2>&1
sc start "SysMain" >nul 2>&1

echo %T_STEP2%
sc config "DiagTrack" start= auto >nul 2>&1
sc start "DiagTrack" >nul 2>&1

echo %T_STEP3%

echo.
echo ==================================================
echo   %T_DONE%
echo ==================================================
echo %T_NOTE1%
echo %T_NOTE2%
echo.
pause
