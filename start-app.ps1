# Requires: Windows 10/11, Node.js (v16+), Git (optional)
# Purpose: One-click launcher to install dependencies, start dev server, and open the app.

$ErrorActionPreference = 'Stop'

function Write-Info($message) {
  Write-Host "[INFO] $message" -ForegroundColor Cyan
}

function Write-Warn($message) {
  Write-Host "[WARN] $message" -ForegroundColor Yellow
}

function Write-ErrorMsg($message) {
  Write-Host "[ERROR] $message" -ForegroundColor Red
}

function Test-CommandExists($name) {
  $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

function Ensure-NodeInstalled() {
  if (-not (Test-CommandExists 'node')) {
    Write-ErrorMsg "Node.js is not installed."
    Write-Host "Please install Node.js LTS from https://nodejs.org and re-run this file." -ForegroundColor Red
    Pause
    exit 1
  }
}

function Install-Dependencies() {
  $useBun = Test-CommandExists 'bun'
  if (Test-Path -LiteralPath './node_modules') {
    Write-Info 'Dependencies already installed. Skipping install.'
    return
  }
  if ($useBun) {
    Write-Info 'Installing dependencies with Bun...'
    bun install
  } else {
    if (-not (Test-CommandExists 'npm')) {
      Write-ErrorMsg 'npm not found. It should come with Node.js. Please reinstall Node.js.'
      Pause
      exit 1
    }
    Write-Info 'Installing dependencies with npm (this may take a few minutes)...'
    npm install
  }
}

function Start-App() {
  $port = 8080
  $url = "http://localhost:$port/"
  Write-Info "Opening $url in your default browser..."
  Start-Process $url | Out-Null

  $useBun = Test-CommandExists 'bun'
  if ($useBun) {
    Write-Info 'Starting development server with Bun...'
    bun run dev
  } else {
    Write-Info 'Starting development server with npm...'
    npm run dev
  }
}

try {
  Set-Location -LiteralPath $PSScriptRoot
  Write-Info 'Checking prerequisites...'
  Ensure-NodeInstalled
  Install-Dependencies
  Start-App
} catch {
  Write-ErrorMsg $_.Exception.Message
  Write-Host "If script execution is blocked, run this once in PowerShell:" -ForegroundColor Yellow
  Write-Host "  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned" -ForegroundColor Yellow
  Pause
  exit 1
}


