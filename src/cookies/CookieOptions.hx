package cookies;

import js.lib.Date as JsDate;

/** Defines the attributes of a HTTP cookie. **/
@:structInit class CookieOptions {

	/** The domain for which the cookie is valid. **/
	public var domain: Option<String>;

	/** The expiration date and time for the cookie. **/
	public var expires: Option<Date>;

	/** The maximum duration, in seconds, until the cookie expires. **/
	public var maxAge: Option<Int>;

	/** The path to which the cookie applies. **/
	public var path: Option<String>;

	/** The cross-site requests policy. **/
	public var sameSite: Option<SameSite>;

	/** Value indicating whether to transmit the cookie over HTTPS only. **/
	public var secure: Option<Bool>;

	/** Creates new cookie options. **/
	public function new(?domain: String, ?expires: Date, ?maxAge: Int, ?path: String, ?sameSite: SameSite, ?secure: Bool) {
		this.domain = domain == null ? None : Some(domain);
		this.expires = expires == null ? None : Some(expires);
		this.maxAge = maxAge == null ? None : Some(maxAge);
		this.path = path == null ? None : Some(path);
		this.sameSite = sameSite == null ? None : Some(sameSite);
		this.secure = secure == null ? None : Some(secure);
	}

	/** Returns a string representation of this object. **/
	public function toString() {
		final value = [];
		if (domain != None) value.push('domain=${domain.sure()}');
		if (expires != None) value.push('expires=${JsDate.fromHaxeDate(expires.sure()).toUTCString()}');
		if (maxAge != None) value.push('max-age=${maxAge.sure()}');
		if (path != None) value.push('path=${path.sure()}');
		if (sameSite != None) value.push('samesite=${sameSite.sure()}');
		if (secure.equals(true)) value.push("secure");
		return value.join("; ");
	}
}
