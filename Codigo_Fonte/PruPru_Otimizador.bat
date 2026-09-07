@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Otimizador de Sistema
:: Conecta seu PC ao melhor desempenho possivel, sem enrolacao.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - System Optimizer
    set "T_TITLE=System Optimizer"
    set "T_WHAT=What this script does:"
    set "T_ITEM1=- Creates a restore point before any change"
    set "T_ITEM2=- Cleans temporary files (safe and reversible)"
    set "T_ITEM3=- Sets the power plan to Balanced"
    set "T_ITEM4=- Disables telemetry (DiagTrack) - optional, reversible"
    set "T_ITEM5=- Adjusts SuperFetch/SysMain automatically based on your disk"
    set "T_ITEM6=- Does NOT close any of your programs, does NOT touch your browser,"
    set "T_ITEM7=  does NOT restart the PC without your confirmation"
    set "T_CONFIRM=Continue? (Y/N): "
    set "T_YES=Y"
    set "T_CANCELLED=Operation cancelled. Nothing was changed."
    set "T_STEP1=[1/7] Creating restore point..."
    set "T_STEP1_DONE1=      Done (or a recent point already existed - Windows only allows"
    set "T_STEP1_DONE2=      one per day). If something goes wrong, restore from here."
    set "T_STEP2=[2/7] Cleaning temporary files..."
    set "T_STEP3=[3/7] Flushing DNS cache..."
    set "T_STEP4=[4/7] Setting power plan to Balanced..."
    set "T_STEP5=[5/7] Checking disk type before touching SysMain..."
    set "T_SSD_FOUND=      SSD detected - disabling SysMain ^(no benefit on SSD^)..."
    set "T_HDD_FOUND=      HDD or unrecognized disk - keeping SysMain enabled ^(helps on HDD^)."
    set "T_STEP6=[6/7] Disabling Windows telemetry ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Done. This only reduces data sent to Microsoft, doesn't affect games."
    set "T_STEP7=[7/7] Checking system file integrity..."
    set "T_STEP7_NOTE=      This may take a few minutes."
    set "T_DONE_STEP=      Done."
    set "T_FINISHED=OPTIMIZATION COMPLETE"
    set "T_RECOMMEND1=We recommend restarting the PC to apply everything."
    set "T_RECOMMEND2=To undo the changes, use PruPru_Reverter.bat"
    set "T_RECOMMEND3=or restore the point created in step 1."
    set "T_REBOOT_PROMPT=Restart now? (Y/N): "
    set "T_REBOOTING=Restarting in 10 seconds... ^(close this window to cancel with "shutdown /a"^)"
    set "T_LATER=OK, restart whenever you want to apply 100%% of the changes."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Optimizador del Sistema
    set "T_TITLE=Optimizador del Sistema"
    set "T_WHAT=Lo que hace este script:"
    set "T_ITEM1=- Crea un punto de restauracion antes de cualquier cambio"
    set "T_ITEM2=- Limpia archivos temporales (seguro y reversible)"
    set "T_ITEM3=- Ajusta el plan de energia a Equilibrado"
    set "T_ITEM4=- Desactiva la telemetria (DiagTrack) - opcional, reversible"
    set "T_ITEM5=- Ajusta SuperFetch/SysMain automaticamente segun tu disco"
    set "T_ITEM6=- NO cierra ninguno de tus programas, NO toca tu navegador,"
    set "T_ITEM7=  NO reinicia el PC sin tu confirmacion"
    set "T_CONFIRM=Deseas continuar? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Operacion cancelada. No se cambio nada."
    set "T_STEP1=[1/7] Creando punto de restauracion..."
    set "T_STEP1_DONE1=      Completado (o ya existia un punto reciente - Windows solo permite"
    set "T_STEP1_DONE2=      uno por dia). Si algo sale mal, restaura desde aqui."
    set "T_STEP2=[2/7] Limpiando archivos temporales..."
    set "T_STEP3=[3/7] Limpiando cache de DNS..."
    set "T_STEP4=[4/7] Ajustando el plan de energia a Equilibrado..."
    set "T_STEP5=[5/7] Verificando el tipo de disco antes de tocar SysMain..."
    set "T_SSD_FOUND=      Disco SSD detectado - desactivando SysMain ^(no aporta beneficio en SSD^)..."
    set "T_HDD_FOUND=      Disco HDD o no identificado - manteniendo SysMain activo ^(ayuda en HDD^)."
    set "T_STEP6=[6/7] Desactivando la telemetria de Windows ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Completado. Esto solo reduce los datos enviados a Microsoft, no afecta juegos."
    set "T_STEP7=[7/7] Verificando la integridad de los archivos del sistema..."
    set "T_STEP7_NOTE=      Esto puede tardar unos minutos."
    set "T_DONE_STEP=      Completado."
    set "T_FINISHED=OPTIMIZACION COMPLETADA"
    set "T_RECOMMEND1=Te recomendamos reiniciar el PC para aplicar todo."
    set "T_RECOMMEND2=Para deshacer los cambios, usa PruPru_Reverter.bat"
    set "T_RECOMMEND3=o restaura el punto creado en el paso 1."
    set "T_REBOOT_PROMPT=Reiniciar ahora? (S/N): "
    set "T_REBOOTING=Reiniciando en 10 segundos... ^(cierra esta ventana para cancelar con "shutdown /a"^)"
    set "T_LATER=Ok, reinicia cuando quieras para aplicar el 100%% de los cambios."
) else (
    title PruPru Digital Services - Otimizador de Sistema
    set "T_TITLE=Otimizador de Sistema"
    set "T_WHAT=O que este script faz:"
    set "T_ITEM1=- Cria um ponto de restauracao antes de qualquer alteracao"
    set "T_ITEM2=- Limpa arquivos temporarios (seguro e reversivel)"
    set "T_ITEM3=- Ajusta o plano de energia para Equilibrado"
    set "T_ITEM4=- Desativa telemetria (DiagTrack) - opcional, reversivel"
    set "T_ITEM5=- Ajusta SuperFetch/SysMain automaticamente conforme seu disco"
    set "T_ITEM6=- NAO fecha nenhum programa seu, NAO mexe no navegador,"
    set "T_ITEM7=  NAO reinicia o PC sem sua confirmacao"
    set "T_CONFIRM=Deseja continuar? (S/N): "
    set "T_YES=S"
    set "T_CANCELLED=Operacao cancelada. Nada foi alterado."
    set "T_STEP1=[1/7] Criando ponto de restauracao..."
    set "T_STEP1_DONE1=      Concluido (ou ja existia um ponto recente - o Windows so permite"
    set "T_STEP1_DONE2=      um por dia). Se algo der errado, restaure o sistema por aqui."
    set "T_STEP2=[2/7] Limpando arquivos temporarios..."
    set "T_STEP3=[3/7] Limpando cache de DNS..."
    set "T_STEP4=[4/7] Ajustando plano de energia para Equilibrado..."
    set "T_STEP5=[5/7] Verificando tipo de disco antes de mexer no SysMain..."
    set "T_SSD_FOUND=      Disco SSD detectado - desativando SysMain ^(nao traz beneficio em SSD^)..."
    set "T_HDD_FOUND=      Disco HDD ou nao identificado - mantendo SysMain ativo ^(ajuda no HDD^)."
    set "T_STEP6=[6/7] Desativando telemetria do Windows ^(DiagTrack^)..."
    set "T_STEP6_DONE=      Concluido. Isso so reduz coleta de dados enviada a Microsoft, nao afeta jogos."
    set "T_STEP7=[7/7] Verificando integridade dos arquivos do sistema..."
    set "T_STEP7_NOTE=      Isso pode demorar alguns minutos."
    set "T_DONE_STEP=      Concluido."
    set "T_FINISHED=OTIMIZACAO CONCLUIDA"
    set "T_RECOMMEND1=Recomendamos reiniciar o PC para aplicar tudo."
    set "T_RECOMMEND2=Para desfazer as alteracoes, use o PruPru_Reverter.bat"
    set "T_RECOMMEND3=ou restaure o ponto criado no passo 1."
    set "T_REBOOT_PROMPT=Reiniciar agora? (S/N): "
    set "T_REBOOTING=Reiniciando em 10 segundos... ^(feche esta janela para cancelar com "shutdown /a"^)"
    set "T_LATER=Ok, reinicie quando quiser para aplicar 100%% das mudancas."
)

:: --- Auto-elevacao (precisa rodar como administrador) ---
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    powershell -windowstyle hidden -command "Start-Process cmd -ArgumentList '/c %~f0' -Verb RunAs"
    exit /b
)

echo ==================================================
echo   PRUPRU DIGITAL SERVICES
echo   %T_TITLE%
echo ==================================================
echo.
echo %T_WHAT%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo   %T_ITEM4%
echo   %T_ITEM5%
echo   %T_ITEM6%
echo   %T_ITEM7%
echo.
set /p CONFIRMA="%T_CONFIRM%"
if /i not "%CONFIRMA%"=="%T_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

echo.
echo %T_STEP1%
powershell -NoProfile -Command "Enable-ComputerRestore -Drive '%SYSTEMDRIVE%\' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'PruPru_Otimizador' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue" >nul 2>&1
echo %T_STEP1_DONE1%
echo %T_STEP1_DONE2%

echo %T_STEP2%
del /q /f /s "%temp%\*" >nul 2>&1
del /q /f /s "%SYSTEMROOT%\Temp\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
ipconfig /flushdns >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP4%
powercfg /S SCHEME_BALANCED >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP5%
set IS_SSD=0
for /f "tokens=1" %%m in ('powershell -NoProfile -Command "(Get-PhysicalDisk | Select-Object -First 1 -ExpandProperty MediaType)"') do (
    echo %%m | find /i "SSD" >nul && set IS_SSD=1
)
if "!IS_SSD!"=="1" (
    echo !T_SSD_FOUND!
    sc config "SysMain" start= disabled >nul 2>&1
    sc stop "SysMain" >nul 2>&1
) else (
    echo !T_HDD_FOUND!
)

echo %T_STEP6%
sc config "DiagTrack" start= disabled >nul 2>&1
sc stop "DiagTrack" >nul 2>&1
echo %T_STEP6_DONE%

echo %T_STEP7%
echo %T_STEP7_NOTE%
sfc /scannow

echo.
echo ==================================================
echo   %T_FINISHED%
echo ==================================================
echo %T_RECOMMEND1%
echo %T_RECOMMEND2%
echo %T_RECOMMEND3%
echo.
set /p REBOOT="%T_REBOOT_PROMPT%"
if /i "%REBOOT%"=="%T_YES%" (
    shutdown /r /t 10
    echo %T_REBOOTING%
) else (
    echo %T_LATER%
)
pause
