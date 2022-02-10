import js.Syntax;
import tink.testrunner.Reporter.AnsiFormatter;
import tink.testrunner.Reporter.BasicReporter;
import tink.testrunner.Runner;
import tink.unit.TestBatch;

/** Runs the test suite. **/
function main() {
	final tests = TestBatch.make([
		new cookies.CookieOptionsTest(),
		new cookies.CookiesTest()
	]);

	ANSI.stripIfUnavailable = false;
	Runner
		.run(tests, new BasicReporter(new AnsiFormatter()))
		.handle(outcome -> Syntax.code("exit({0})", outcome.summary().failures.length));
}
