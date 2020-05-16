package cookies;

import haxe.DynamicAccess;
import js.lib.Date as JsDate;

/** Defines the attributes of a HTTP cookie. **/
@:expose
@:require(js)
class CookieOptions {

  /** The domain for which the cookie is valid. **/
  public var domain: String = '';

  /** The expiration date and time for the cookie. A `null` reference indicates a session cookie. **/
  public var expires: Null<Date> = null;

  /** The maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. **/
  public var maxAge(get, set): Int;

  /** The path to which the cookie applies. **/
  public var path: String = '';

  /** Value indicating whether to transmit the cookie over HTTPS only. **/
  public var secure: Bool = false;

  /** Creates new cookie options. **/
  public function new(?options: CookieOptionsParams) {
    if (options != null) {
      if (options.domain != null) domain = options.domain;
      if (options.expires != null) expires = options.expires;
      if (options.maxAge != null) maxAge = options.maxAge;
      if (options.path != null) path = options.path;
      if (options.secure != null) secure = options.secure;
    }
  }

  /** Gets the maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. **/
  function get_maxAge(): Int {
    if (expires == null) return -1;
    final now = Date.now();
    return expires > now ? Math.ceil((expires.getTime() - now.getTime()) / 1000) : 0;
  }

  /** Sets maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. **/
  function set_maxAge(value: Int): Void
    expires = value < 0 ? null : Date.fromTime(Date.now().getTime() + (value * 1000));

  /** Creates new options from the specified cookie string. **/
  public static function fromString(value: String): CookieOptions {
    final attributes = ['domain', 'expires', 'max-age', 'path', 'secure'];
    final map = new Map<String, String>();
    for (option in value.split('; ').slice(1).map(part -> part.split('='))) {
      final attribute = option[0].toLowerCase();
      if (attributes.includes(attribute)) map.set(attribute, option[1]);
    }

    return new CookieOptions({
      domain: map.exists('domain') ? map.get('domain') : '',
      expires: map.exists('expires') ? Date.fromString(map.get('expires')) : null,
      maxAge: map.exists('max-age') ? Std.parseInt(map.get('max-age')) : -1,
      path: map.exists('path') ? map.get('path') : '',
      secure: map.exists('secure')
    });
  }

  /** Converts this object to a map in JSON format. **/
  /* TODO ?????????
  public function toJSON(): DynamicAccess<Dynamic> {
    return {
      domain: domain,
      expires: expires ? expires.toJSON() : null,
      path: path,
      secure: secure
    };
  } */

  /** Returns a string representation of this object. **/
   public function toString(): String {
    final value = [];
    if (expires != null) value.push('expires=${JsDate.fromHaxeDate(expires).toUTCString()}');
    if (domain.length > 0) value.push('domain=$domain');
    if (path.length > 0) value.push('path=$path');
    if (secure) value.push('secure');
    return value.join('; ');
  }
}

/** Defines the parameters of a `CookieOptions` instance. **/
typedef CookieOptionsParams = {

  /** The domain for which the cookie is valid. **/
  var ?domain: String;

  /** The expiration date and time for the cookie. A `null` reference indicates a session cookie. **/
  var ?expires: Date;

  /** The maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. **/
  var ?maxAge: Int;

  /** The path to which the cookie applies. **/
  var ?path: String;

  /** Value indicating whether to transmit the cookie over HTTPS only. **/
  var ?secure: Bool;
}
