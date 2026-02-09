@echo off
REM Windows wrapper for GLM command - Claude Polyglot
REM Usage: glm.bat [claude-args...]

setlocal enabledelayedexpansion

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"
set "PROJECT_DIR=%SCRIPT_DIR%"

REM Set the environment variables for GLM (Z.AI)
set "ANTHROPIC_AUTH_TOKEN=b493c271d4bf4119884670e62a638c0b.JPltLiE1K2FzfiPz"
set "ANTHROPIC_MODEL=claude-opus-4-6"
set "ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic"
set "API_TIMEOUT_MS=3000000"

REM Display startup info
echo ===============================================================
echo   Launching Claude Code
echo   Provider: GLM-4.7 (Z.AI)
echo   Model:    claude-opus-4-6
echo ===============================================================
echo.

REM Launch Claude Code with the environment
"C:\Users\AndrejGalad\.local\bin\claude.exe" %*

endlocal
