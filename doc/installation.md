# Installation

## Requirements
Before installing **Cookies.hx**, you need to make sure you have either
[Haxe](https://haxe.org) or [Node.js](https://nodejs.org) up and running.

You can verify if you're already good to go with the following commands:

=== "Haxe"
		:::shell
		haxe --version
		# 4.1.4

		haxelib version
		# 4.0.2

=== "JavaScript"
		:::shell
		node --version
		# v15.1.0

		npm --version
		# 7.0.8

!!! info
	If you plan to play with the package sources, you will also need
	[PowerShell](https://docs.microsoft.com/en-us/powershell) and [Material for MkDocs](https://squidfunk.github.io/mkdocs-material).

## Installing with a package manager

=== "Haxe"
	From a command prompt, run:

		:::shell
		haxelib install cookies

	Now in your [Haxe](https://haxe.org) code, you can use:

		:::haxe
		import cookies.CookieOptions;
		import cookies.Cookies;

=== "JavaScript"
	From a command prompt, run:

		:::shell
		npm install @cedx/cookies.hx

	Now in your [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) code, you can use:

		:::js
		// CommonJS module.
		const {CookieOptions, Cookies} = require("@cedx/cookies.hx");

		// ECMAScript module.
		import {CookieOptions, Cookies} from "@cedx/cookies.hx";

## Installing from a content delivery network
This library is also available as a ready-made JavaScript bundle.
To install it, add one of these code snippets to the `<head>` of your HTML document:

``` html
<!-- jsDelivr -->
<script src="https://cdn.jsdelivr.net/npm/@cedx/cookies.hx/build/cookies.min.js"></script>

<!-- UNPKG -->
<script src="https://unpkg.com/@cedx/cookies.hx/build/cookies.min.js"></script>
```

The classes of this library are exposed as `cookies` property on the `window` global object:

``` html
<script>
	const {Cookies, CookieOptions} = window.cookies;
</script>
```
