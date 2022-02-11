package cookies;

/** Defines the values of the `SameSite` cookie attribute. **/
enum abstract SameSite(String) to String {

	/** Only send cookies for top level navigation requests. **/
	var Lax = "lax";

	/** No restrictions on cross-site requests. **/
	var None = "none";

	/** Prevents the cookie from being sent to the target site in all cross-site browsing context. **/
	var Strict = "strict";
}
