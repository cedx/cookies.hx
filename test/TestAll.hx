import cookies.*;
import haxe.ds.List;
import utest.Assert;

/** Runs the test suites. **/
class TestAll {

  /** Application entry point. **/
  public static function main(): Void {
    Assert.results = new List();
    Mocha.describe('CookieOptions', new CookieOptionsTest().run);
    Mocha.describe('Cookies', new CookiesTest().run);
  }
}
