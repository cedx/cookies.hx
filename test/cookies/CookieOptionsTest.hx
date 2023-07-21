package cookies;

/** Tests the features of the `CookieOptions` class. **/
final class CookieOptionsTest {

	/** Creates a new test. **/
	public function new() {}

	/** Tests the `toString()` method. **/
	@:variant({}, "")
	@:variant({expires: Date.fromTime(0), path: "/path", secure: true}, "expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/path; secure")
	@:variant({domain: "domain.com", maxAge: 123, sameSite: Strict}, "domain=domain.com; max-age=123; samesite=strict")
	public function toString(input: CookieOptions, output: String)
		return assert(input.toString() == output);
}
