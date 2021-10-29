package cookies;

import haxe.DynamicAccess;
import haxe.Json;
import js.Browser.*;
import js.html.EventTarget;
import js.html.StorageEvent;
import js.lib.Object;
import js.lib.Symbol;
import js.lib.Error.TypeError;

using StringTools;

/** Provides access to the [HTTP Cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies). **/
@:expose
@:require(js)
class Cookies extends EventTarget {

	/** The default cookie options. **/
	public var defaults(default, null): CookieOptions;

	/** The keys of the cookies associated with the current document. **/
	public var keys(get, never): Array<String>;

	/** The number of cookies associated with the current document. **/
	public var length(get, never): Int;

	/** Creates a new cookie service. **/
	public function new(?defaults: CookieOptions) {
		super();
		this.defaults = defaults != null ? defaults : new CookieOptions();
	}

	/** Gets the keys of the cookies associated with the current document. **/
	function get_keys(): Array<String> {
		final keys = ~/((?:^|\s*;)[^=]+)(?=;|$)|^\s*|\s*(?:=[^;]*)?(?:\1|$)/g.replace(document.cookie, "");
		return keys.length > 0 ? ~/\s*(?:=[^;]*)?;\s*/.split(keys).map(StringTools.urlDecode) : [];
	}

	/** Gets the number of cookies associated with the current document. **/
	function get_length(): Int
		return keys.length;

	/** Removes all cookies associated with the current document. **/
	public function clear(): Void {
		for (key in keys) removeItem(key);
		emit(null, null, null);
	}

	/**
		Gets the value associated to the specified `key`.
		Returns the given `defaultValue` if the cookie does not exist.
	**/
	public function get(key: String, ?defaultValue: String): Null<String> {
		if (!has(key)) return defaultValue;

		try {
			final token = key.urlEncode().replace(~/[-.+*]/g, "\\$&");
			final scanner = new EReg('(?:(?:^|.*;)\\s*$token\\s*=\\s*([^;]*).*$)|^.*$');
			return document.cookie.replace(scanner, "$1").urlDecode();
		}

		catch (err) {
			return defaultValue;
		}
	}

	/**
		Gets the deserialized value associated to the specified `key`.
		Returns the given `defaultValue` if the cookie does not exist.
	**/
	public function getObject(key: String, ?defaultValue: Any): Dynamic {
		try {
			final value = get(key);
			return value != null ? Json.parse(value) : defaultValue;
		}

		catch (err) {
			return defaultValue;
		}
	}

	/** Gets a value indicating whether the current document has a cookie with the specified `key`. **/
	public function has(key: String): Bool {
		final token = key.urlEncode().replace(~/[-.+*]/g, "\\$&");
		return new EReg('(?:^|;\\s*)$token\\s*=').test(document.cookie);
	}

	/** Returns a new iterator that allows iterating the cookies associated with the current document. **/
	public function keyValueIterator(): KeyValueIterator<String, String>
		return new CookieIterator(this);

	/**
		Looks up the cookie with the specified `key`, or add a new cookie if it isn't there.

		Returns the value associated to `key`, if there is one.
		Otherwise calls `ifAbsent` to get a new value, associates `key` to that value, and then returns the new value.
	**/
	public function putIfAbsent(key: String, ifAbsent: () -> String, ?options: CookieOptions): String {
		if (!has(key)) set(key, ifAbsent(), options);
		return get(key);
	}

	/**
		Looks up the cookie with the specified `key`, or add a new cookie if it isn't there.

		Returns the deserialized value associated to `key`, if there is one.
		Otherwise calls `ifAbsent` to get a new value, serializes and associates `key` to that value, and then returns the new value.
	**/
	public function putObjectIfAbsent(key: String, ifAbsent: () -> Any, ?options: CookieOptions): Dynamic {
		if (!has(key)) setObject(key, ifAbsent(), options);
		return getObject(key);
	}

	/**
		Removes the cookie with the specified `key` and its associated value.
		Returns the cookie with the specified `key` before it was removed.
	**/
	public function remove(key: String, ?options: CookieOptions): Null<String> {
		final oldValue = get(key);
		removeItem(key, options);
		emit(key, oldValue, null);
		return oldValue;
	}

	/**
		Associates a given `value` to the specified `key`.
		Returns this instance, throws a `TypeError` if specified key is invalid.
	**/
	public function set(key: String, value: String, ?options: CookieOptions): Cookies {
		if (!key.length) throw new TypeError("Invalid cookie name.");

		final cookieOptions = getOptions(options).toString();
		var cookieValue = '${key.urlEncode()}=${value.urlEncode()}';
		if (cookieOptions.length) cookieValue += '; $cookieOptions';

		final oldValue = get(key);
		document.cookie = cookieValue;
		emit(key, oldValue, value);
		return this;
	}

	/**
		Serializes and associates a given `value` to the specified `key`.
		Returns this instance.
	**/
	public function setObject(key: String, value: Any, ?options: CookieOptions): Cookies
		return set(key, Json.stringify(value), options);

	/** Converts this object to a map in JSON format. **/
	public function toJSON(): DynamicAccess<String> {
		final map: DynamicAccess<String> = {};
		for (key => value in this) map[key] = value;
		return map;
	}

	/** Returns a string representation of this object. **/
	public function toString(): String
		return document.cookie;

	/** Emits a new cookie event. **/
	function emit(key: Null<String>, oldValue: Null<String>, newValue: Null<String>): Void
		dispatchEvent(new StorageEvent("change", {
			key: key,
			newValue: newValue,
			oldValue: oldValue,
			storageArea: document.cookie,
			url: location.href
		}));

	/** Merges the default cookie options with the specified ones. **/
	function getOptions(?options: CookieOptions): CookieOptions {
		if (options == null) options = new CookieOptions();
		return new CookieOptions({
			domain: options.domain.length > 0 ? options.domain : defaults.domain,
			expires: options.expires != null ? options.expires : defaults.expires,
			path: options.path.length > 0 ? options.path : defaults.path,
			secure: options.secure ? options.secure : defaults.secure
		});
	}

	/** Removes the value associated to the specified `key`. **/
	function removeItem(key: String, ?options: CookieOptions): Void {
		if (!has(key)) return;
		final cookieOptions = getOptions(options);
		cookieOptions.expires = Date.fromTime(0);
		document.cookie = '${key.urlEncode()}=; $cookieOptions';
	}
}

/** Permits iteration over elements of a `Cookies` instance. **/
private class CookieIterator {

	/** The instance to iterate. **/
	final cookies: Cookies;

	/** The underlying key iterator. **/
	final keys: ArrayIterator<String>;

	/** Creates a new cookie iterator. **/
	public function new(cookies: Cookies) {
		this.cookies = cookies;
		keys = new ArrayIterator<String>(cookies.keys);
	}

	/** Returns a value indicating whether the iteration is complete. **/
	public function hasNext(): Bool
		return keys.hasNext();

	/** Returns the current item of the iterator and advances to the next one. **/
	public function next(): {key: String, value: String} {
		final key = keys.next();
		return {key: key, value: cookies.get(key)};
	}
}
