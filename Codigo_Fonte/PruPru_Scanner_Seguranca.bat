@echo off
setlocal enabledelayedexpansion
color 0B

:: ============================================================
:: PruPru Digital Services - prupru.org
:: Scanner de Seguranca (SOMENTE LEITURA)
:: Este script NAO apaga, NAO encerra e NAO altera nada.
:: Ele apenas gera um relatorio para voce decidir o que fazer.
:: ============================================================

set "PP_LANG=pt"
if exist "%LocalAppData%\PruPru\lang.txt" for /f "usebackq delims=" %%L in ("%LocalAppData%\PruPru\lang.txt") do set "PP_LANG=%%L"

if /i "%PP_LANG%"=="en" (
    title PruPru Digital Services - Security Scanner
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - SECURITY REPORT"
    set "T_GENERATED=Generated on"
    set "T_INFO_ONLY=This report is informational. Nothing was deleted."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - SECURITY SCANNER"
    set "T_MODE=Read-only mode: nothing will be deleted or closed"
    set "T_STEP1=[1/4] Looking for known mining processes..."
    set "T_PROC_SECTION=-- SUSPICIOUS PROCESSES FOUND --"
    set "T_PROC_ALERT=[WARNING] Process running:"
    set "T_PROC_NONE=No known mining process found."
    set "T_STEP2=[2/4] Listing startup programs (Run keys)..."
    set "T_RUN_HKCU=-- STARTUP ITEMS (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- STARTUP ITEMS (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listed in the report. Review and manually disable"
    set "T_RUN_NOTE2=(Task Manager ^> Startup) anything you don't recognize."
    set "T_STEP3=[3/4] Listing scheduled tasks (for your manual review)..."
    set "T_TASKS_SECTION=-- SCHEDULED TASKS (excluding Microsoft's own) --"
    set "T_TASKS_NOTE=Listed in the report."
    set "T_STEP4=[4/4] Checking startup folders for unusual shortcuts..."
    set "T_STARTUP_USER=-- FILES IN THE USER STARTUP FOLDER --"
    set "T_STARTUP_ALL=-- FILES IN THE ALL USERS STARTUP FOLDER --"
    set "T_DONE=SCAN COMPLETE - NOTHING WAS CHANGED"
    set "T_SAVED=Report saved to:"
    set "T_FOOTER1=If you find something suspicious in the report that you"
    set "T_FOOTER2=don't recognize, send it to PruPru Digital Services to review"
    set "T_FOOTER3=before removing anything manually."
) else if /i "%PP_LANG%"=="es" (
    title PruPru Digital Services - Escaner de Seguridad
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - INFORME DE SEGURIDAD"
    set "T_GENERATED=Generado el"
    set "T_INFO_ONLY=Este informe es informativo. No se elimino nada."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - ESCANER DE SEGURIDAD"
    set "T_MODE=Modo de solo lectura: no se eliminara ni cerrara nada"
    set "T_STEP1=[1/4] Buscando procesos de mineria conocidos..."
    set "T_PROC_SECTION=-- PROCESOS SOSPECHOSOS ENCONTRADOS --"
    set "T_PROC_ALERT=[ATENCION] Proceso en ejecucion:"
    set "T_PROC_NONE=No se encontro ningun proceso minero conocido."
    set "T_STEP2=[2/4] Listando programas de inicio (claves Run)..."
    set "T_RUN_HKCU=-- ELEMENTOS DE INICIO (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- ELEMENTOS DE INICIO (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listados en el informe. Revisa y desactiva manualmente"
    set "T_RUN_NOTE2=(Administrador de tareas ^> Inicio) lo que no reconozcas."
    set "T_STEP3=[3/4] Listando tareas programadas (para tu revision manual)..."
    set "T_TASKS_SECTION=-- TAREAS PROGRAMADAS (excluyendo las predeterminadas de Microsoft) --"
    set "T_TASKS_NOTE=Listadas en el informe."
    set "T_STEP4=[4/4] Verificando carpetas de inicio en busca de accesos inusuales..."
    set "T_STARTUP_USER=-- ARCHIVOS EN LA CARPETA STARTUP DEL USUARIO --"
    set "T_STARTUP_ALL=-- ARCHIVOS EN LA CARPETA STARTUP GENERAL --"
    set "T_DONE=ANALISIS COMPLETADO - NO SE CAMBIO NADA"
    set "T_SAVED=Informe guardado en:"
    set "T_FOOTER1=Si encuentras algo sospechoso en el informe que no"
    set "T_FOOTER2=reconoces, enviaselo a PruPru Digital Services para revisarlo"
    set "T_FOOTER3=antes de eliminar algo manualmente."
) else (
    title PruPru Digital Services - Scanner de Seguranca
    set "T_HEADER_REPORT=PRUPRU DIGITAL SERVICES - RELATORIO DE SEGURANCA"
    set "T_GENERATED=Gerado em"
    set "T_INFO_ONLY=Este relatorio e informativo. Nada foi apagado."
    set "T_HEADER_CONSOLE=PRUPRU DIGITAL SERVICES - SCANNER DE SEGURANCA"
    set "T_MODE=Modo somente-leitura: nada sera apagado ou fechado"
    set "T_STEP1=[1/4] Procurando processos de mineracao conhecidos..."
    set "T_PROC_SECTION=-- PROCESSOS SUSPEITOS ENCONTRADOS --"
    set "T_PROC_ALERT=[ALERTA] Processo em execucao:"
    set "T_PROC_NONE=Nenhum processo minerador conhecido encontrado."
    set "T_STEP2=[2/4] Listando programas de inicializacao (Run keys)..."
    set "T_RUN_HKCU=-- ITENS DE INICIALIZACAO (HKCU\...\Run) --"
    set "T_RUN_HKLM=-- ITENS DE INICIALIZACAO (HKLM\...\Run) --"
    set "T_RUN_NOTE1=Listados no relatorio. Revise e desative manualmente"
    set "T_RUN_NOTE2=(Gerenciador de Tarefas ^> Inicializar) o que nao reconhecer."
    set "T_STEP3=[3/4] Listando tarefas agendadas (para sua revisao manual)..."
    set "T_TASKS_SECTION=-- TAREFAS AGENDADAS (excluindo as padrao da Microsoft) --"
    set "T_TASKS_NOTE=Listadas no relatorio."
    set "T_STEP4=[4/4] Verificando pastas de inicializacao por atalhos incomuns..."
    set "T_STARTUP_USER=-- ARQUIVOS NA PASTA STARTUP DO USUARIO --"
    set "T_STARTUP_ALL=-- ARQUIVOS NA PASTA STARTUP GERAL --"
    set "T_DONE=SCAN CONCLUIDO - NADA FOI ALTERADO"
    set "T_SAVED=Relatorio salvo em:"
    set "T_FOOTER1=Se encontrar algo suspeito no relatorio que voce nao"
    set "T_FOOTER2=reconhece, envie para PruPru Digital Services revisar"
    set "T_FOOTER3=antes de remover qualquer coisa manualmente."
)

set DESKTOP=
for /f "usebackq delims=" %%d in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set DESKTOP=%%d
if "%DESKTOP%"=="" set DESKTOP=%USERPROFILE%\Desktop

set REPORT=%DESKTOP%\PruPru_Relatorio_Scan_%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%.txt
set REPORT=%REPORT: =0%

echo ==================================================  > "%REPORT%"
echo   %T_HEADER_REPORT%  >> "%REPORT%"
echo   %T_GENERATED% %date% %time%                           >> "%REPORT%"
echo   %T_INFO_ONLY%   >> "%REPORT%"
echo ==================================================  >> "%REPORT%"

echo ==================================================
echo   %T_HEADER_CONSOLE%
echo   %T_MODE%
echo ==================================================
echo.

echo %T_STEP1%
echo.>> "%REPORT%"
echo %T_PROC_SECTION%                >> "%REPORT%"
set FOUND_PROC=0
for %%p in (xmrig.exe minerd.exe ccminer.exe nheqminer.exe ethminer.exe cpuminer.exe t-rex.exe phoenixminer.exe lolminer.exe nbminer.exe teamredminer.exe claymore.exe wildrig.exe srbminer.exe) do (
    tasklist /fi "imagename eq %%p" 2>nul | find /i "%%p" >nul
    if not errorlevel 1 (
        echo   %T_PROC_ALERT% %%p
        echo   %T_PROC_ALERT% %%p >> "%REPORT%"
        set FOUND_PROC=1
    )
)
if "!FOUND_PROC!"=="0" (
    echo   %T_PROC_NONE%
    echo   %T_PROC_NONE% >> "%REPORT%"
)

echo.
echo %T_STEP2%
echo.>> "%REPORT%"
echo %T_RUN_HKCU%           >> "%REPORT%"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>nul
echo.>> "%REPORT%"
echo %T_RUN_HKLM%           >> "%REPORT%"
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" >> "%REPORT%" 2>nul
echo   %T_RUN_NOTE1%
echo   %T_RUN_NOTE2%

echo.
echo %T_STEP3%
echo.>> "%REPORT%"
echo %T_TASKS_SECTION% >> "%REPORT%"
powershell -NoProfile -Command "Get-ScheduledTask | Where-Object { $_.TaskPath -notlike '\Microsoft\*' } | ForEach-Object { \"$($_.TaskPath)$($_.TaskName)  [$($_.State)]\" }" >> "%REPORT%" 2>nul
echo   %T_TASKS_NOTE%

echo.
echo %T_STEP4%
echo.>> "%REPORT%"
echo %T_STARTUP_USER%            >> "%REPORT%"
dir /b "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup" >> "%REPORT%" 2>nul
echo.>> "%REPORT%"
echo %T_STARTUP_ALL%                 >> "%REPORT%"
dir /b "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp" >> "%REPORT%" 2>nul

echo.
echo ==================================================
echo   %T_DONE%
echo   %T_SAVED%
echo   %REPORT%
echo ==================================================
echo %T_FOOTER1%
echo %T_FOOTER2%
echo %T_FOOTER3%
echo.
pause
