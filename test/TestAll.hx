import Mocha.*;
import cookies.*;
import haxe.ds.List;
import utest.Assert;

/** Runs the test suites. **/
class TestAll {

	/** Application entry point. **/
	static function main() {
		Assert.results = new List();
		describe("CookieOptions", new CookieOptionsTest().run);
		describe("Cookies", new CookiesTest().run);
	}
}
