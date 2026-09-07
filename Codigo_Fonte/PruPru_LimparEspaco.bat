@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Limpar Espaco em Disco
:: Remove apenas arquivos temporarios/cache reconstruiveis.
:: Mostra quanto espaco foi liberado no final.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Free Up Disk Space
    set "T_HEADER=PRUPRU DIGITAL SERVICES - FREE UP DISK SPACE"
    set "T_INTRO1=What will be cleaned (everything is automatically rebuilt"
    set "T_INTRO2=by Windows when needed, no personal files touched):"
    set "T_ITEM1=- User and Windows temporary files"
    set "T_ITEM2=- Thumbnail cache"
    set "T_ITEM3=- Already-installed update cache"
    set "T_CONFIRM_PROMPT=Continue? (Y/N): "
    set "T_CONFIRM_YES=Y"
    set "T_CANCELLED=Cancelled. Nothing was changed."
    set "T_STEP1=[1/4] Cleaning user temporary files..."
    set "T_STEP2=[2/4] Cleaning Windows temporary files..."
    set "T_STEP3=[3/4] Cleaning thumbnail cache..."
    set "T_STEP4=[4/4] Cleaning already-installed update cache..."
    set "T_DONE_STEP=      Done."
    set "T_RECYCLE_PROMPT=Also empty the Recycle Bin? (Y/N): "
    set "T_RECYCLE_YES=Y"
    set "T_RECYCLE_DONE=      Recycle Bin emptied."
    set "T_FINISHED=CLEANUP COMPLETE"
    set "T_FREED_LABEL=Space freed: approximately"
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Liberar Espacio en Disco
    set "T_HEADER=PRUPRU DIGITAL SERVICES - LIBERAR ESPACIO EN DISCO"
    set "T_INTRO1=Lo que se va a limpiar (todo se reconstruye automaticamente"
    set "T_INTRO2=por Windows cuando sea necesario, ningun archivo personal):"
    set "T_ITEM1=- Temporales del usuario y de Windows"
    set "T_ITEM2=- Cache de miniaturas"
    set "T_ITEM3=- Cache de actualizaciones ya instaladas"
    set "T_CONFIRM_PROMPT=Continuar? (S/N): "
    set "T_CONFIRM_YES=S"
    set "T_CANCELLED=Cancelado. No se cambio nada."
    set "T_STEP1=[1/4] Limpiando temporales del usuario..."
    set "T_STEP2=[2/4] Limpiando temporales de Windows..."
    set "T_STEP3=[3/4] Limpiando cache de miniaturas..."
    set "T_STEP4=[4/4] Limpiando cache de actualizaciones ya instaladas..."
    set "T_DONE_STEP=      Completado."
    set "T_RECYCLE_PROMPT=Vaciar tambien la Papelera de reciclaje? (S/N): "
    set "T_RECYCLE_YES=S"
    set "T_RECYCLE_DONE=      Papelera vaciada."
    set "T_FINISHED=LIMPIEZA COMPLETADA"
    set "T_FREED_LABEL=Espacio liberado: aproximadamente"
) else (
    title PruPru Digital Services - Limpar Espaco em Disco
    set "T_HEADER=PRUPRU DIGITAL SERVICES - LIMPAR ESPACO EM DISCO"
    set "T_INTRO1=O que vai ser limpo (tudo reconstruido automaticamente"
    set "T_INTRO2=pelo Windows quando necessario, nada de arquivo pessoal):"
    set "T_ITEM1=- Temporarios do usuario e do Windows"
    set "T_ITEM2=- Cache de miniaturas (thumbnails)"
    set "T_ITEM3=- Cache de atualizacoes ja instaladas"
    set "T_CONFIRM_PROMPT=Continuar? (S/N): "
    set "T_CONFIRM_YES=S"
    set "T_CANCELLED=Cancelado. Nada foi alterado."
    set "T_STEP1=[1/4] Limpando temporarios do usuario..."
    set "T_STEP2=[2/4] Limpando temporarios do Windows..."
    set "T_STEP3=[3/4] Limpando cache de miniaturas..."
    set "T_STEP4=[4/4] Limpando cache de atualizacoes ja instaladas..."
    set "T_DONE_STEP=      Concluido."
    set "T_RECYCLE_PROMPT=Esvaziar tambem a Lixeira? (S/N): "
    set "T_RECYCLE_YES=S"
    set "T_RECYCLE_DONE=      Lixeira esvaziada."
    set "T_FINISHED=LIMPEZA CONCLUIDA"
    set "T_FREED_LABEL=Espaco liberado: aproximadamente"
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
echo %T_INTRO1%
echo %T_INTRO2%
echo   %T_ITEM1%
echo   %T_ITEM2%
echo   %T_ITEM3%
echo.
set /p CONFIRMA="%T_CONFIRM_PROMPT%"
if /i not "%CONFIRMA%"=="%T_CONFIRM_YES%" (
    echo %T_CANCELLED%
    pause
    exit /b
)

for /f "usebackq delims=" %%f in (`powershell -NoProfile -Command "(Get-PSDrive C).Free"`) do set FREE_BEFORE=%%f

echo.
echo %T_STEP1%
del /q /f /s "%temp%\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP2%
del /q /f /s "%SYSTEMROOT%\Temp\*" >nul 2>&1
echo %T_DONE_STEP%

echo %T_STEP3%
taskkill /f /im explorer.exe >nul 2>&1
del /q /f /s "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo %T_DONE_STEP%

echo %T_STEP4%
net stop wuauserv >nul 2>&1
del /q /f /s "%SYSTEMROOT%\SoftwareDistribution\Download\*" >nul 2>&1
net start wuauserv >nul 2>&1
echo %T_DONE_STEP%

echo.
set /p LIXEIRA="%T_RECYCLE_PROMPT%"
if /i "%LIXEIRA%"=="%T_RECYCLE_YES%" (
    powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"
    echo %T_RECYCLE_DONE%
)

for /f "usebackq delims=" %%f in (`powershell -NoProfile -Command "(Get-PSDrive C).Free"`) do set FREE_AFTER=%%f
for /f "usebackq delims=" %%g in (`powershell -NoProfile -Command "[math]::Round((%FREE_AFTER% - %FREE_BEFORE%)/1MB,0)"`) do set FREED_MB=%%g

echo.
echo ==================================================
echo   %T_FINISHED%
echo   !T_FREED_LABEL! %FREED_MB% MB
echo ==================================================
pause
