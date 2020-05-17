/** Provides access to the [HTTP Cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies). */
export declare class Cookies extends EventTarget implements Iterable<[string, string | undefined]> {
		
	/** The default cookie options. */
	readonly defaults: CookieOptions;

	/**
	 * An event that is triggered when a cookie is changed (added, modified, or removed).
	 * @event changes
	 */
	static readonly eventChanges: String;

	/**
	 * Creates a new cookie service.
	 * @param defaults The default cookie options.
	 * @param document The underlying HTML document.
	 */
	constructor(defaults?: CookieOptions, document?: Document);

	/** The keys of the cookies associated with the current document. */
	get keys(): String[];

	/** The number of cookies associated with the current document. */
	get length(): Int;

	/**
	 * Returns a new iterator that allows iterating the cookies associated with the current document.
	 * @return An iterator for the cookies of the current document.
	 */
	[Symbol.iterator](): IterableIterator<[string, string | undefined]>;

	/** Removes all cookies associated with the current document. */
	clear(): Void;

	/**
	 * Gets the value associated to the specified key.
	 * @param key The cookie name.
	 * @param defaultValue The value to return if the cookie does not exist.
	 * @return The cookie value, or the default value if the cookie is not found.
	 */
	get(key: String, defaultValue?: String): String | undefined;

	/**
	 * Gets the deserialized value associated to the specified key.
	 * @param key The cookie name.
	 * @param defaultValue The value to return if the cookie does not exist.
	 * @return The deserialized cookie value, or the default value if the cookie is not found.
	 */
	getObject(key: String, defaultValue?: any): any;

	/**
	 * Gets a value indicating whether the current document has a cookie with the specified key.
	 * @param key The cookie name.
	 * @return `true` if the current document has a cookie with the specified key, otherwise `false`.
	 */
	has(key: String): Bool;

	/**
	 * Looks up the cookie with the specified key, or add a new cookie if it isn't there.
	 *
	 * Returns the value associated to `key`, if there is one. Otherwise calls `ifAbsent` to get a new value,
	 * associates `key` to that value, and then returns the new value.
	 *
	 * @param key The key to seek for.
	 * @param ifAbsent The function called to get a new value.
	 * @param options The cookie options.
	 * @return The value associated with the specified key.
	 */
	putIfAbsent(key: String, ifAbsent: () => string, options?: CookieOptions): String;

	/**
	 * Looks up the cookie with the specified key, or add a new cookie if it isn't there.
	 *
	 * Returns the deserialized value associated to `key`, if there is one. Otherwise calls `ifAbsent` to get a new value,
	 * serializes and associates `key` to that value, and then returns the new value.
	 *
	 * @param key The key to seek for.
	 * @param ifAbsent The function called to get a new value.
	 * @param options The cookie options.
	 * @return The deserialized value associated with the specified key.
	 */
	putObjectIfAbsent(key: String, ifAbsent: () => any, options?: CookieOptions): any;

	/**
	 * Removes the cookie with the specified key and its associated value.
	 * @param key The cookie name.
	 * @param options The cookie options.
	 * @return The value associated with the specified key before it was removed.
	 */
	remove(key: String, options?: CookieOptions): String | undefined;

	/**
	 * Associates a given value to the specified key.
	 * @param key The cookie name.
	 * @param value The cookie value.
	 * @param options The cookie options.
	 * @return This instance.
	 * @throws `TypeError` The specified key is invalid.
	 */
	set(key: String, value: String, options?: CookieOptions): this;

	/**
	 * Serializes and associates a given value to the specified key.
	 * @param key The cookie name.
	 * @param value The cookie value.
	 * @param options The cookie options.
	 * @return This instance.
	 */
	setObject(key: String, value: any, options?: CookieOptions): this;

	/**
	 * Converts this object to a map in JSON format.
	 * @return The map in JSON format corresponding to this object.
	 */
	toJSON(): JsonObject;

	/**
	 * Returns a string representation of this object.
	 * @return The string representation of this object.
	 */
	toString(): String;
}

/** Defines the attributes of a HTTP cookie. */
export declare class CookieOptions {

	/** The domain for which the cookie is valid. */
	domain: String;

	/** The expiration date and time for the cookie. An `undefined` value indicates a session cookie. */
	expires?: Date;

	/** The path to which the cookie applies. */
	path: String;

	/** Value indicating whether to transmit the cookie over HTTPS only. */
	secure: Bool;

	/**
	 * Creates new cookie options.
	 * @param options An object specifying values used to initialize this instance.
	 */
	constructor(options?: Partial<CookieOptionsParams>);

	/** The maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. */
	get maxAge(): Int;
	set maxAge(value: Int);

	/**
	 * Creates new options from the specified cookie string.
	 * @param value A string representing a cookie.
	 * @return The instance corresponding to the specified cookie string.
	 */
	static fromString(value: String): CookieOptions;

	/**
	 * Returns a string representation of this object.
	 * @return The string representation of this object.
	 */
	toString(): String;
}

/** Defines the parameters of a `CookieOptions` instance. */
export interface CookieOptionsParams {

	/** The domain for which the cookie is valid. */
	domain: String;

	/** The expiration date and time for the cookie. An `undefined` value indicates a session cookie. */
	expires: Date;

	/** The maximum duration, in seconds, until the cookie expires. A negative value indicates a session cookie. */
	maxAge: Int;

	/** The path to which the cookie applies. */
	path: String;

	/** Value indicating whether to transmit the cookie over HTTPS only. */
	secure: Bool;
}

/** Defines the shape of a JSON value. */
export declare type Json = null | boolean | number | string | Json[] | {
	[property: String]: Json;
};

/** Defines the shape of an object in JSON format. */
export declare type JsonObject = Record<string, Json>;

/** Represents the event parameter used for a change event. */
export declare class SimpleChange {

	/** The previous value, or `undefined` if added. */
	readonly previousValue?: String | undefined;

	/** The current value, or `undefined` if removed. */
	readonly currentValue?: String | undefined;

	/**
	 * Creates a new simple change.
	 * @param previousValue The previous value, or `undefined` if added.
	 * @param currentValue The current value, or `undefined` if removed.
	 */
	constructor(previousValue?: String | undefined, currentValue?: String | undefined);

	/**
	 * Converts this object to a map in JSON format.
	 * @return The map in JSON format corresponding to this object.
	 */
	toJSON(): JsonObject;
}
