package cookies;

import haxe.Json;
import js.Browser.document;
using Lambda;
using StringTools;

/** Provides access to the [HTTP Cookies](https://developer.mozilla.org/docs/Web/HTTP/Cookies). **/
@:jsonStringify(cookieStore -> [for (key => value in cookieStore) key => value])
class CookieStore {

	/** The map of all cookies. **/
	public static var all(get, never): Map<String, String>;
		static function get_all() {
			final cookies = document.cookie.length == 0 ? [] : [for (item in document.cookie.split(";")) {
				final parts = item.ltrim().split("=");
				if (parts.length >= 2) new Named(parts[0], parts.slice(1).join("=").urlDecode());
			}];

			return [for (cookie in cookies) cookie.name => cookie.value];
		}

	/** The default cookie options. **/
	public final defaults: CookieOptions;

	/** The keys of this cookie store. **/
	public var keys(get, never): Array<String>;
		function get_keys() return [for (key in all.keys()) if (key.startsWith(keyPrefix)) key.substr(keyPrefix.length)];

	/** The number of entries in this cookie store. **/
	public var length(get, never): Int;
		inline function get_length() return keys.length;

	/** The stream of cookie events. **/
	public final onChange: Signal<CookieEvent>;

	/** A string prefixed to every key so that it is unique globally in the whole cookie store. **/
	final keyPrefix: String;

	/** The controller of cookie events. **/
	final onChangeTrigger: SignalTrigger<CookieEvent> = Signal.trigger();

	/** Creates a new cookie store. **/
	public function new(?options: CookieStoreOptions) {
		defaults = options?.defaults ?? new CookieOptions();
		keyPrefix = options?.keyPrefix ?? "";
		this.onChange = onChangeTrigger.asSignal();
	}

	/** Removes all entries from this cookie store. **/
	public function clear(?options: CookieOptions): Void
		keys.iter(key -> remove(key, options));

	/** Gets a value indicating whether this cookie store contains the specified `key`. **/
	public function exists(key: String): Bool
		return all.exists(buildKey(key));

	/** Gets the value associated with the specified `key`. Returns `None` if the `key` does not exist. **/
	public function get(key: String): Option<String> {
		final value = all[buildKey(key)];
		return value == null ? None : Some(value);
	}

	/**
		Gets the deserialized value associated with the specified `key`.
		Returns `None` if the `key` does not exist or its value cannot be deserialized.
	**/
	public function getObject<T>(key: String): Option<T> {
		final value = all[buildKey(key)];
		return value == null ? None : switch Error.catchExceptions(() -> Json.parse(value)) {
			case Failure(_): None;
			case Success(json): Some(json);
		}
	}

	/** Returns a new iterator that allows iterating the entries of this cookie store. **/
	public inline function keyValueIterator(): KeyValueIterator<String, String>
		return new CookieStoreIterator(this);

	/**
		Removes the value associated with the specified `key`.
		Returns the value associated with the `key` before it was removed.
	**/
	public function remove(key: String, ?options: CookieOptions): Option<String> {
		final oldValue = get(key);
		removeItem(buildKey(key), options);
		onChangeTrigger.trigger(new CookieEvent(key, oldValue));
		return oldValue;
	}

	/** Associates a given `value` with the specified `key`. **/
	public function set(key: String, value: String, ?options: CookieOptions): Outcome<Noise, Error> {
		if (key.length == 0 || key.contains("=") || key.contains(";")) return Failure(new Error(BadRequest, "Invalid cookie name."));

		final cookieOptions = getOptions(options).toString();
		var cookie = '${buildKey(key)}=${value.urlEncode()}';
		if (cookieOptions.length > 0) cookie += '; $cookieOptions';

		final oldValue = get(key);
		document.cookie = cookie;
		onChangeTrigger.trigger(new CookieEvent(key, oldValue, Some(value)));
		return Success(Noise);
	}

	/** Serializes and associates a given `value` with the specified `key`. **/
	public function setObject<T>(key: String, value: T, ?options: CookieOptions): Outcome<Noise, Error>
		return switch Error.catchExceptions(() -> Json.stringify(value)) {
			case Failure(_): Failure(new Error(UnprocessableEntity, "Unable to encode the specified value in JSON."));
			case Success(json): set(key, json, options);
		}

	/** Returns a string representation of this object. **/
	public function toString(): String
		return keyPrefix.length == 0 ? document.cookie : [for (key => value in this) '$key=${value.urlEncode()}'].join("; ");

	/** Builds a normalized cookie key from the given `key`. **/
	function buildKey(key: String): String
		return '$keyPrefix$key';

	/** Merges the default cookie options with the specified ones. **/
	function getOptions(?options: CookieOptions): CookieOptions {
		if (options == null) options = new CookieOptions();
		return {
			domain: options.domain.or(defaults.domain.orNull()),
			expires: options.expires.or(defaults.expires.orNull()),
			maxAge: options.maxAge.or(defaults.maxAge.orNull()),
			path: options.path.or(defaults.path.orNull()),
			sameSite: options.sameSite.or(defaults.sameSite.orNull()),
			secure: options.secure.or(defaults.secure.orNull())
		};
	}

	/** Removes the value associated with the specified `key`. **/
	function removeItem(key: String, ?options: CookieOptions) {
		final cookieOptions = getOptions(options);
		cookieOptions.expires = Some(Date.fromTime(0));
		cookieOptions.maxAge = Some(0);
		document.cookie = '$key=; $cookieOptions';
	}
}

/** Permits iteration over elements of a `CookieStore` instance. **/
private class CookieStoreIterator {

	/** The cookie store to iterate. **/
	final cookieStore: CookieStore;

	/** The current index. **/
	var index = 0;

	/** The keys of the cookie store. **/
	final keys: Array<String>;

	/** Creates a new cookie iterator. **/
	public function new(cookieStore: CookieStore) {
		this.cookieStore = cookieStore;
		keys = cookieStore.keys;
	}

	/** Returns a value indicating whether the iteration is complete. **/
	public function hasNext(): Bool
		return index < keys.length;

	/** Returns the current item of the iterator and advances to the next one. **/
	public function next(): {key: String, value: String} {
		final key = keys[index++];
		return {key: key, value: cookieStore.get(key).sure()};
	}
}

/** Defines the options of a `CookieStore` instance. **/
typedef CookieStoreOptions = {

	/** The default cookie options. **/
	var ?defaults: CookieOptions;

	/** A string prefixed to every key so that it is unique globally in the whole cookie store. **/
	var ?keyPrefix: String;
}
