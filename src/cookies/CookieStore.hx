package cookies;

import haxe.Json;
import js.Browser.document;
using Lambda;
using StringTools;

/** Provides access to the [HTTP Cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies). **/
class CookieStore {

	/** The default cookie options. **/
	public final defaults = new CookieOptions();

	/** The keys of this cookie store. **/
	public var keys(get, never): Array<String>;

	/** The number of entries in this cookie store. **/
	public var length(get, never): Int;

	/** The stream of cookie events. **/
	public final onChange: Signal<CookieEvent>;

	/** A string prefixed to every key so that it is unique globally in the whole cookie store. **/
	final keyPrefix = "";

	/** The controller of cookie events. **/
	final onChangeTrigger: SignalTrigger<CookieEvent> = Signal.trigger();

	/** Creates a new cookie service. **/
	public function new(?options: CookieStoreOptions) {
		this.onChange = onChangeTrigger.asSignal();
		if (options != null) {
			if (options.defaults != null) defaults = options.defaults;
			if (options.keyPrefix != null) keyPrefix = options.keyPrefix;
		}
	}

	/** Gets the keys of this cookie store. **/
	function get_keys()
		return [for (key in getAllCookies().keys()) if (key.startsWith(keyPrefix)) key.substring(keyPrefix.length)];

	/** Gets the number of entries in this cookie store. **/
	inline function get_length() return keys.length;

	/** Removes all entries from this cookie store. **/
	public function clear(?options: CookieOptions) keys.iter(key -> remove(key, options));

	/** Gets a value indicating whether this cookie store contains the specified `key`. **/
	public function exists(key: String) return getAllCookies().exists(buildKey(key));

	/** Gets the value associated to the specified `key`. Returns `None` if the `key` does not exist. **/
	public function get(key: String): Option<String> {
		final value = getAllCookies().get(buildKey(key));
		return value == null ? None : Some(value);
	}

	/**
		Gets the deserialized value associated to the specified `key`.
		Returns `None` if the `key` does not exist or its value cannot be deserialized.
	**/
	public function getObject<T>(key: String): Option<T> {
		final value = getAllCookies().get(buildKey(key));
		return value == null ? None : switch Error.catchExceptions(() -> Json.parse(value)) {
			case Failure(_): None;
			case Success(json): Some(json);
		}
	}

	/** Returns a new iterator that allows iterating the entries of this cookie store. **/
	public inline function keyValueIterator(): KeyValueIterator<String, String>
		return new CookieStoreIterator(this);

	/**
		Looks up the value of the specified `key`, or add a new value if it isn't there.
		Returns the value associated to `key`, if there is one.
		Otherwise calls `ifAbsent` to get a new value, associates `key` to that value, and then returns the new value.
	**/
	public function putIfAbsent(key: String, ifAbsent: () -> String, ?options: CookieOptions) return switch get(key) {
		case Some(value): Success(value);
		case None: final value = ifAbsent(); set(key, value, options).map(_ -> value);
	}

	/**
		Looks up the value of the specified `key`, or add a new value if it isn't there.
		Returns the deserialized value associated to `key`, if there is one.
		Otherwise calls `ifAbsent` to get a new value, serializes it and associates `key` to that value, and then returns the new value.
	**/
	public function putObjectIfAbsent<T>(key: String, ifAbsent: () -> T, ?options: CookieOptions) return switch getObject(key) {
		case Some(value): Success(value);
		case None: final value = ifAbsent(); setObject(key, value, options).map(_ -> value);
	}

	/**
		Removes the value associated to the specified `key`.
		Returns the value associated with the `key` before it was removed.
	**/
	public function remove(key: String, ?options: CookieOptions) {
		final oldValue = get(key);
		// TODO: removeValue(buildKey(key), options);
		onChangeTrigger.trigger(new CookieEvent(Some(key), oldValue));
		return oldValue;
	}

	/** Associates a given `value` to the specified `key`. **/
	public function set(key: String, value: String, ?options: CookieOptions): Outcome<Noise, Error> {
		// TODO ??? if (key.length == 0) throw new Exception("Invalid cookie name."); // TODO: replace by Outcome!

		/* TODO
		final cookieOptions = getOptions(options).toString();
		var cookieValue = '${key.urlEncode()}=${value.urlEncode()}';
		if (cookieOptions.length > 0) cookieValue += '; $cookieOptions';

		final oldValue = get(key);
		document.cookie = cookieValue;
		emit(key, oldValue, value);
		return this;*/

		final oldValue = get(key);
		// TODO document.cookie = cookieValue;
		onChangeTrigger.trigger(new CookieEvent(Some(key), oldValue, Some(value)));
		return Success(Noise);
	}

	/** Serializes and associates a given `value` to the specified `key`. **/
	public function setObject<T>(key: String, value: T, ?options: CookieOptions): Outcome<Noise, Error>
		return switch Error.catchExceptions(() -> Json.stringify(value)) {
			case Failure(_): Failure(new Error(UnprocessableEntity, "Unable to encode the specified value in JSON."));
			case Success(json): set(key, json, options);
		}

	#if !tink_json
	/** Converts this cookie store to a JSON representation. **/
	public function toJSON() return [for (key => value in this) [key, value]];
	#end

	/** Builds a normalized storage key from the given `key`. **/
	function buildKey(key: String) return '$keyPrefix$key';

	/** Returns a map of all cookies. **/
	function getAllCookies() {
		final map: Map<String, String> = [];
		for (cookie in document.cookie.split(";")) {
			final parts = cookie.ltrim().split("=");
			if (parts.length < 2) continue;
			map[parts[0]] = parts[1].urlDecode(); // TODO: parts[0].urlDecode() ?
		}

		return map;
	}

	/** Merges the default cookie options with the specified ones. **/
	/*
	function getOptions(?options: CookieOptions): CookieOptions {
		if (options == null) options = new CookieOptions();
		return new CookieOptions({
			domain: options.domain.length > 0 ? options.domain : defaults.domain,
			expires: options.expires != null ? options.expires : defaults.expires,
			path: options.path.length > 0 ? options.path : defaults.path,
			secure: options.secure ? options.secure : defaults.secure
		});
	}*/

	/** Removes the value associated to the specified `key`. **/
	function removeValue(key: String, ?options: CookieOptions) {
		/* TODO
		if (!exists(key)) return;
		final cookieOptions = getOptions(options);
		cookieOptions.expires = Date.fromTime(0);
		document.cookie = '${key.urlEncode()}=; $cookieOptions'; */
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
	public function hasNext() return index < keys.length;

	/** Returns the current item of the iterator and advances to the next one. **/
	public function next() {
		final key = keys[index++];
		return {key: key, value: cookieStore.get(key).sure()};
	}
}

/** Defines the options of a `CookieStore` instance. **/
typedef CookieStoreOptions = {

	/** The default cookie options. **/
	?defaults: CookieOptions,

	/** A string prefixed to every key so that it is unique globally in the whole cookie store. **/
	?keyPrefix: String
}
