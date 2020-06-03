#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
Set-Location (Split-Path $PSScriptRoot)

$version = (Get-Content haxelib.json | ConvertFrom-Json).version
haxe --define doc-gen --xml var/api.xml build.hxml
haxelib run dox `
	--define description "Service for interacting with the HTTP cookies, in Haxe and JavaScript. An event-based API to manage cookie changes." `
	--define logo "https://api.belin.io/cookies.hx/favicon.ico" `
	--define source-path "https://git.belin.io/cedx/cookies.hx/src/branch/master/src" `
	--define themeColor 0xffc105 `
	--define version $version `
	--define website "https://belin.io" `
	--input-path var `
	--output-path doc/api `
	--title "Cookies.hx" `
	--toplevel-package cookies

Copy-Item doc/img/favicon.ico doc/api
mkdocs build --config-file=etc/mkdocs.yaml
