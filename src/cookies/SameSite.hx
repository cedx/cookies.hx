package cookies;

/** Defines the values of the `SameSite` cookie attrbite. **/
enum abstract SameSite(String) to String {

	/** Only send cookies for top level navigation requests. **/
	var Lax = "lax";

	/** No restrictions on cross-site requests. **/
	var None = "none";

	/** Prevents the cookie from being sent by the browser to the target site in all cross-site browsing context, even when following a regular link. **/
	var Strict = "strict";
}
