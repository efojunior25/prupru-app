@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Modo Streaming - ATIVAR
:: Da prioridade alta para o OBS/Streamlabs e libera recursos
:: do codificador desativando a gravacao em segundo plano do
:: Xbox Game Bar. NAO bloqueia navegador (chat/alertas precisam
:: dele). Para desfazer: PruPru_ModoStreaming_OFF.bat
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Streaming Mode (ENABLE)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - STREAMING MODE (ON)"
    set "T_WHAT=What's going to happen:"
    set "T_ITEM1=- OBS Studio / Streamlabs priority is raised to High"
    set "T_ITEM2=  (reversible, only if it's open)"
    set "T_ITEM3=- Xbox Game Bar's background recording is disabled"
    set "T_ITEM4=  (frees up part of the video encoder for your stream)"
    set "T_ITEM5=- NO browser is blocked - chat and alerts keep"
    set "T_ITEM6=  working normally"
    set "T_CONFIRM=Enable Streaming Mode now? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/2] Adjusting OBS/Streamlabs priority..."
    set "T_STEP1_DONE=      Done (if none is open, this is skipped)."
    set "T_STEP2=[2/2] Freeing up encoder resources (Xbox Game Bar)..."
    set "T_DONE_STEP=      Done."
    set "T_ACTIVE=STREAMING MODE IS ON"
    set "T_REVERT=To go back to normal, run PruPru_ModoStreaming_OFF.bat"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Modo Streaming (ACTIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (ON)"
    set "T_WHAT=Lo que va a pasar:"
    set "T_ITEM1=- La prioridad de OBS Studio / Streamlabs sube a Alta"
    set "T_ITEM2=  (reversible, solo si esta abierto)"
    set "T_ITEM3=- Se desactiva la grabacion en segundo plano de Xbox Game Bar"
    set "T_ITEM4=  (libera parte del codificador de video para tu directo)"
    set "T_ITEM5=- NINGUN navegador es bloqueado - el chat y las alertas"
    set "T_ITEM6=  siguen funcionando con normalidad"
    set "T_CONFIRM=Activar el Modo Streaming ahora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/2] Ajustando la prioridad de OBS/Streamlabs..."
    set "T_STEP1_DONE=      Completado (si ninguno esta abierto, esto se omite)."
    set "T_STEP2=[2/2] Liberando recursos del codificador (Xbox Game Bar)..."
    set "T_DONE_STEP=      Completado."
    set "T_ACTIVE=MODO STREAMING ACTIVO"
    set "T_REVERT=Para volver a la normalidad, ejecuta PruPru_ModoStreaming_OFF.bat"
) else (
    title PruPru Digital Services - Modo Streaming (ATIVAR)
    set "T_HEADER=PRUPRU DIGITAL SERVICES - MODO STREAMING (ON)"
    set "T_WHAT=O que vai acontecer:"
    set "T_ITEM1=- Prioridade do OBS Studio / Streamlabs sobe para Alta"
    set "T_ITEM2=  (reversivel, so se estiver aberto)"
    set "T_ITEM3=- Gravacao em segundo plano do Xbox Game Bar e desativada"
    set "T_ITEM4=  (libera parte do codificador de video para sua live)"
    set "T_ITEM5=- NADA de navegador e bloqueado - chat e alertas continuam"
    set "T_ITEM6=  funcionando normalmente"
    set "T_CONFIRM=Ativar o Modo Streaming agora? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/2] Ajustando prioridade do OBS/Streamlabs..."
    set "T_STEP1_DONE=      Concluido (se nenhum estiver aberto, isso e ignorado)."
    set "T_STEP2=[2/2] Liberando recursos do codificador (Xbox Game Bar)..."
    set "T_DONE_STEP=      Concluido."
    set "T_ACTIVE=MODO STREAMING ATIVO"
    set "T_REVERT=Para voltar ao normal, rode PruPru_ModoStreaming_OFF.bat"
)

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   %T_HEADER%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo   %T_ITEM5%
echo   %T_ITEM6%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
powershell -NoProfile -Command "Get-Process obs64,obs32,'streamlabs-obs' -ErrorAction SilentlyContinue | ForEach-Object { $_.PriorityClass = 'High' }" >nul 2>&1
echo %T_STEP1_DONE%

echo %T_STEP2%
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1
echo %T_DONE_STEP%

echo.
echo ==================================================
echo   %T_ACTIVE%
echo   %T_REVERT%
echo ==================================================
pause
