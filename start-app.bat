@echo off
setlocal ENABLEDELAYEDEXPANSION

REM One-click launcher for Windows users to run the app
REM Prerequisite: Node.js LTS installed (https://nodejs.org)

cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js not found. Please install Node.js LTS from https://nodejs.org and re-run this file.
  pause
  exit /b 1
)

REM Install dependencies if node_modules is missing
if not exist node_modules (
  where bun >nul 2>nul
  if %errorlevel%==0 (
    echo [INFO] Installing dependencies with Bun...
    bun install || goto :error
  ) else (
    where npm >nul 2>nul
    if errorlevel 1 (
      echo [ERROR] npm not found. Please reinstall Node.js.
      pause
      exit /b 1
    )
    echo [INFO] Installing dependencies with npm (this may take a few minutes)...
    npm install || goto :error
  )
) else (
  echo [INFO] Dependencies already installed. Skipping install.
)

set PORT=8080
set URL=http://localhost:%PORT%/
start "" "%URL%"

where bun >nul 2>nul
if %errorlevel%==0 (
  echo [INFO] Starting development server with Bun...
  bun run dev
) else (
  echo [INFO] Starting development server with npm...
  npm run dev
)

exit /b 0

:error
echo [ERROR] An error occurred. Please review the messages above.
pause
exit /b 1
