$ErrorActionPreference = 'Stop'

function Write-Info($message) { Write-Host "[INFO] $message" -ForegroundColor Cyan }
function Write-ErrorMsg($message) { Write-Host "[ERROR] $message" -ForegroundColor Red }
function Test-CommandExists($name) { $null -ne (Get-Command $name -ErrorAction SilentlyContinue) }

try {
  Set-Location -LiteralPath $PSScriptRoot

  if (-not (Test-CommandExists 'node')) {
    Write-ErrorMsg 'Node.js is not installed.'
    Write-Host 'Install Node.js LTS from https://nodejs.org then re-run this file.' -ForegroundColor Red
    Pause; exit 1
  }

  $useBun = Test-CommandExists 'bun'
  if (-not (Test-Path -LiteralPath './node_modules')) {
    if ($useBun) { Write-Info 'Installing dependencies with Bun...'; bun install }
    else { Write-Info 'Installing dependencies with npm...'; npm install }
  }

  Write-Info 'Building production bundle...'
  if ($useBun) { bun run build } else { npm run build }

  $port = 8080
  $url = "http://localhost:$port/"
  Write-Info "Opening $url in your default browser..."
  Start-Process $url | Out-Null

  Write-Info 'Starting production preview server...'
  if ($useBun) { bun run preview } else { npm run preview }
} catch {
  Write-ErrorMsg $_.Exception.Message
  Write-Host "If script execution is blocked, run this once in PowerShell:" -ForegroundColor Yellow
  Write-Host "  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned" -ForegroundColor Yellow
  Pause
  exit 1
}


