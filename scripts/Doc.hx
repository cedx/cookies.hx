import haxe.Json;
import sys.FileSystem;
import sys.io.File;

/** Runs the script. **/
function main() {
	if (FileSystem.exists("docs")) Tools.removeDirectory("docs");

	Sys.command("haxe --define doc-gen --no-output --xml var/api.xml build.hxml");
	Sys.command("lix", [
		"run", "dox",
		"--define", "description", "Service for interacting with the HTTP cookies, in Haxe.",
		"--define", "source-path", "https://bitbucket.org/cedx/cookies.hx/src/main/src",
		"--define", "themeColor", "0xffc105",
		"--define", "version", Json.parse(File.getContent("haxelib.json")).version,
		"--define", "website", "https://bitbucket.org/cedx/cookies.hx",
		"--input-path", "var",
		"--output-path", "docs",
		"--title", "Cookies for Haxe",
		"--toplevel-package", "cookies"
	]);

	File.copy("www/favicon.ico", "docs/favicon.ico");
}
