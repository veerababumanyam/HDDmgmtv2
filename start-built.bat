@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Build and preview production on Windows
cd /d "%~dp0"

where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js not found. Please install Node.js LTS from https://nodejs.org and re-run this file.
  pause
  exit /b 1
)

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
    echo [INFO] Installing dependencies with npm...
    npm install || goto :error
  )
)

where bun >nul 2>nul
if %errorlevel%==0 (
  echo [INFO] Building with Bun...
  bun run build || goto :error
  set PORT=8080
  start "" http://localhost:%PORT%/
  echo [INFO] Starting preview with Bun...
  bun run preview
) else (
  echo [INFO] Building with npm...
  npm run build || goto :error
  set PORT=8080
  start "" http://localhost:%PORT%/
  echo [INFO] Starting preview with npm...
  npm run preview
)

exit /b 0

:error
echo [ERROR] An error occurred. Please review the messages above.
pause
exit /b 1
