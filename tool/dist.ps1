#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

tool/clean.ps1
tool/version.ps1
haxe build.hxml

if (-not (Test-Path build)) { New-Item build -ItemType Directory | Out-Null }
Copy-Item lib/cookies.js build/cookies.js
node_modules/.bin/terser.ps1 --config-file=etc/terser.json --output=build/cookies.min.js build/cookies.js
