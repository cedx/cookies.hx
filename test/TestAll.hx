import cookies.*;
import Mocha.*;
import haxe.ds.List;
import utest.Assert;

/** Runs the test suites. **/
class TestAll {

	/** Application entry point. **/
	public static function main(): Void {
		Assert.results = new List();
		describe("CookieOptions", new CookieOptionsTest().run);
		describe("Cookies", new CookiesTest().run);
	}
}
