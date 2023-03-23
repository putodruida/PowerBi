@echo off

REM .bat con permisos de administrador
REM .bat with administrator permissions
:-------------------------------------
REM --> Analizando los permisos
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If there is an error, it means that there are no administrator permissions.
if '%errorlevel%' NEQ '0' (

REM not shown --> echo Solicitando permisos de administrador... 

REM not shown --> echo Requesting administrative privileges... 

REM not shown --> echo Anfordern Administratorrechte ...

goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params = %*:"=""
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"
:--------------------------------------
cls

REM Download the PowerBi installer
"%~dp0wget" -c "https://download.microsoft.com/download/8/8/0/880BCA75-79DD-466A-927D-1ABF1F5454B0/PBIDesktopSetup_x64.exe"

cls
@echo --- LOADED INSTALLER ... ---
echo .
@echo -- WAIT FOR IT TO INSTALL --

REM Run setup as administrator
"%~dp0PBIDesktopSetup_x64.exe"

REM Delete the installer to free up space
DEL /F /A "%~dp0PBIDesktopSetup_x64.exe"
cls
@echo -- IF Power Bi OPENS AUTOMATICALLY, CLOSE IT --

@echo .
@echo .
@echo .

PAUSE
EXIT
