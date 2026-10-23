@echo off
rem
rem sync.bat - Quick Windows launcher for sync.ps1
rem
setlocal
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync.ps1" %*
endlocal
