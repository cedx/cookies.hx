import cookies.CookieStore;

/** Iterates over the key/value pairs of the cookie store. **/
function main() {
	// Loop over all entries of the cookie store.
	final cookieStore = new CookieStore();
	cookieStore.set("foo", "bar");
	cookieStore.set("bar", "baz");
	cookieStore.set("baz", "qux");

	for (key => value in cookieStore) {
		trace('$key => $value');
		// Round 1: "foo => bar"
		// Round 2: "bar => baz"
		// Round 3: "baz => qux"
	}

	cookieStore.clear();

	// Loop over entries of the cookie store that use the same key prefix.
	cookieStore.set("foo", "bar");
	cookieStore.set("prefix:bar", "baz");

	final prefixedStore = new CookieStore({keyPrefix: "prefix:"});
	prefixedStore.set("baz", "qux");

	for (key => value in prefixedStore) {
		trace('$key => $value');
		// Round 1: "bar => baz"
		// Round 2: "baz => qux"
	}
}
