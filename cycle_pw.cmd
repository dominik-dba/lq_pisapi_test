@echo off
setlocal
pwsh -NoProfile -ExecutionPolicy Bypass -File "%~dp0cycle_pw.ps1" %*
exit /b %ERRORLEVEL%
