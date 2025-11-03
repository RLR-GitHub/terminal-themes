@echo off
REM Rory Terminal Themes - Windows CMD Installer
REM This is a wrapper that launches the PowerShell installer

echo ========================================
echo  Rory Terminal Themes Installer
echo ========================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found.
    echo Please install PowerShell to use this installer.
    echo.
    echo Download from: https://aka.ms/powershell
    pause
    exit /b 1
)

echo Launching PowerShell installer...
echo.

REM Run PowerShell installer
powershell -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installation completed successfully!
) else (
    echo.
    echo Installation encountered errors.
    echo Please check the output above for details.
)

echo.
pause

