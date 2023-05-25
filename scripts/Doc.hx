//! --class-path src --library tink_core
import cookies.Version;
import sys.FileSystem;
import sys.io.File;

/** Builds the documentation. **/
function main() {
	if (FileSystem.exists("docs")) Tools.removeDirectory("docs");

	Sys.command("haxe --define doc-gen --no-output --xml var/api.xml build.hxml");
	Sys.command("lix", ["run", "dox",
		"--define", "description", "Service for interacting with the HTTP cookies, in Haxe.",
		"--define", "source-path", "https://github.com/cedx/cookies.hx/blob/main/src",
		"--define", "themeColor", "0xea8220",
		"--define", "version", Version.packageVersion,
		"--define", "website", "https://docs.belin.io/cookies.hx",
		"--input-path", "var",
		"--output-path", "docs",
		"--title", "Cookies for Haxe",
		"--toplevel-package", "cookies"
	]);

	File.copy("www/favicon.ico", "docs/favicon.ico");
}
