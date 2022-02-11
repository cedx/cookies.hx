package cookies;

import js.Browser.document;
import #if tink_json tink.Json #else haxe.Json #end;
using StringTools;

/** Tests the features of the `CookieStore` class. **/
@:asserts class CookieStoreTest {

	/** Creates a new test. **/
	public function new() {}

	/** This method is invoked before each test. **/
	@:before public function before() {
		for (key in CookieStore.all.keys()) removeCookie(key);
		return Noise;
	}

	/** Tests the `keys` property. **/
	public function testKeys() {
		// It should return an empty array for an empty cookie store.
		final service = new CookieStore();
		asserts.assert(service.keys.length == 0);

		// It should return the list of keys for a non-empty cookie store.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		var keys = service.keys;
		asserts.assert(keys.length == 2);
		asserts.assert(keys.contains("foo") && keys.contains("prefix:baz"));

		// It should handle the key prefix.
		keys = new CookieStore({keyPrefix: "prefix:"}).keys;
		asserts.assert(keys.length == 1 && keys[0] == "baz");

		return asserts.done();
	}

	/** Tests the `length` property. **/
	public function testLength() {
		// It should return zero for an empty cookie store.
		final service = new CookieStore();
		asserts.assert(service.length == 0);

		// It should return the number of entries for a non-empty cookie store.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");
		asserts.assert(service.length == 2);

		// It should handle the key prefix.
		asserts.assert(new CookieStore({keyPrefix: "prefix:"}).length == 1);
		return asserts.done();
	}

	/** Tests the `addEventListener("change")` method. **/
	/* TODO
	public function testAddEventListener() {
		it("should trigger an event when a cookie is added", function(done) {
			setCookie("onChanges=; expires=Thu, 01 Jan 1970 00:00:00 GMT";

			final listener = event -> {
				final entries = [...event.detail.entries()];
				Assert(entries).to.have.lengthOf(1);

				final [key, record] = entries[0];
				Assert.equals(key).to.equal("onChanges");
				Assert.equals(record.currentValue).to.equal("foo");
				Assert(record.previousValue).to.be.undefined;

				done();
			};

			final service = new CookieStore();
			service.addEventListener(CookieStore.eventChanges, listener);
			service.set("onChanges", "foo");
			service.removeEventListener(CookieStore.eventChanges, listener);
		});

		it("should trigger an event when a cookie is updated", function(done) {
			setCookie("onChanges=foo";

			final listener = event -> {
				final entries = [...event.detail.entries()];
				Assert(entries).to.have.lengthOf(1);

				final [key, record] = entries[0];
				Assert.equals(key).to.equal("onChanges");
				Assert.equals(record.currentValue).to.equal("bar");
				Assert.equals(record.previousValue).to.equal("foo");

				done();
			};

			final service = new CookieStore();
			service.addEventListener(CookieStore.eventChanges, listener);
			service.set("onChanges", "bar");
			service.removeEventListener(CookieStore.eventChanges, listener);
		});

		it("should trigger an event when a cookie is removed", function(done) {
			setCookie("onChanges=bar";

			final listener = event -> {
				final entries = [...event.detail.entries()];
				Assert(entries).to.have.lengthOf(1);

				final [key, record] = entries[0];
				Assert.equals(key).to.equal("onChanges");
				Assert(record.currentValue).to.be.undefined;
				Assert.equals(record.previousValue).to.equal("bar");

				done();
			};

			final service = new CookieStore();
			service.addEventListener(CookieStore.eventChanges, listener);
			service.remove("onChanges");
			service.removeEventListener(CookieStore.eventChanges, listener);
		});

		it("should trigger an event when all the cookies are removed", function(done) {
			setCookie("onChanges1=foo";
			setCookie("onChanges2=bar";

			final listener = event -> {
				final entries = [...event.detail.entries()];
				Assert(entries).to.have.lengthOf.at.least(2);

				let records = entries.filter(item -> item[0] == "onChanges1").map(item -> item[1]);
				Assert(records).to.have.lengthOf(1);
				Assert(records[0].currentValue).to.be.undefined;
				Assert.equals(records[0].previousValue).to.equal("foo");

				records = entries.filter(item -> item[0] == "onChanges2").map(item -> item[1]);
				Assert(records).to.have.lengthOf(1);
				Assert(records[0].currentValue).to.be.undefined;
				Assert.equals(records[0].previousValue).to.equal("bar");

				done();
			};

			final service = new CookieStore();
			service.addEventListener(CookieStore.eventChanges, listener);
			service.clear();
			service.removeEventListener(CookieStore.eventChanges, listener);
		});
	}*/

	/** Tests the `clear()` method. **/
	public function testClear() {
		// It should remove all cookies.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		new CookieStore().clear();
		asserts.assert(document.cookie.length == 0);

		// It should handle the key prefix.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		new CookieStore({keyPrefix: "prefix:"}).clear();
		asserts.assert(document.cookie == "foo=bar");

		return asserts.done();
	}

	/** Tests the `exists()` method. **/
	public function testExists() {
		// It should return `false` if the specified key is not contained.
		var service = new CookieStore();
		asserts.assert(!service.exists("foo"));

		// It should return `true` if the specified key is contained.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		asserts.assert(!service.exists("foo:bar"));
		asserts.assert(service.exists("foo") && service.exists("prefix:baz"));

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(!service.exists("foo"));
		asserts.assert(service.exists("baz"));

		return asserts.done();
	}

	/** Tests the `get()` method. **/
	public function testGet() {
		// It should properly get the cookies.
		var service = new CookieStore();
		asserts.assert(service.get("foo") == None);

		setCookie("foo", "bar");
		asserts.assert(service.get("foo").equals("bar"));

		setCookie("foo", "123");
		asserts.assert(service.get("foo").equals("123"));

		removeCookie("foo");
		asserts.assert(service.get("foo") == None);

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(service.get("baz") == None);

		setCookie("prefix:baz", "qux");
		asserts.assert(service.get("baz").equals("qux"));

		setCookie("prefix:baz", "456");
		asserts.assert(service.get("baz").equals("456"));

		removeCookie("prefix:baz");
		asserts.assert(service.get("baz") == None);

		return asserts.done();
	}

	/** Tests the `getObject()` method. **/
	public function testGetObject() {
		// It should properly get the deserialized cookies.
		var service = new CookieStore();
		asserts.assert(service.getObject("foo") == None);

		setCookie("foo", '"bar"');
		asserts.assert(service.getObject("foo").equals("bar"));

		setCookie("foo", "123");
		asserts.assert(service.getObject("foo").equals(123));

		setCookie("foo", '{"key": "value"}');
		asserts.compare(Some({key: "value"}), service.getObject("foo"));

		setCookie("foo", "{bar[123]}");
		asserts.assert(service.getObject("foo") == None);

		removeCookie("foo");
		asserts.assert(service.getObject("foo") == None);

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(service.getObject("baz") == None);

		setCookie("prefix:baz", '"qux"');
		asserts.assert(service.getObject("baz").equals("qux"));

		setCookie("prefix:baz", "456");
		asserts.assert(service.getObject("baz").equals(456));

		setCookie("prefix:baz", '{"key": "value"}');
		asserts.compare(Some({key: "value"}), service.getObject("baz"));

		setCookie("prefix:baz", "{qux[456]}");
		asserts.assert(service.getObject("baz") == None);

		removeCookie("prefix:baz");
		asserts.assert(service.getObject("baz") == None);

		return asserts.done();
	}

	/** Tests the `keyValueIterator()` method. **/
	public function testKeyValueIterator() {
		final service = new CookieStore();

		// It should end iteration immediately if the cookie store is empty.
		var iterator = service.keyValueIterator();
		asserts.assert(!iterator.hasNext());

		// It should iterate over the values if the cookie store is not empty.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		iterator = service.keyValueIterator();
		asserts.assert(iterator.hasNext());
		asserts.compare({key: "foo", value: "bar"}, iterator.next());
		asserts.assert(iterator.hasNext());
		asserts.compare({key: "prefix:baz", value: "qux"}, iterator.next());
		asserts.assert(!iterator.hasNext());

		// It should handle the key prefix.
		iterator = new CookieStore({keyPrefix: "prefix:"}).keyValueIterator();
		asserts.assert(iterator.hasNext());
		asserts.compare({key: "baz", value: "qux"}, iterator.next());
		asserts.assert(!iterator.hasNext());

		return asserts.done();
	}

	/** Tests the `putIfAbsent()` method. **/
	public function testPutIfAbsent() {
		// It should add a new entry if it does not exist.
		var service = new CookieStore();
		asserts.assert(getCookie("foo") == null);
		asserts.assert(service.putIfAbsent("foo", () -> "bar").equals("bar"));
		asserts.assert(getCookie("foo") == "bar");

		// It should not add a new entry if it already exists.
		setCookie("foo", "123");
		asserts.assert(service.putIfAbsent("foo", () -> "XYZ").equals("123"));
		asserts.assert(getCookie("foo") == "123");

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(getCookie("prefix:baz") == null);
		asserts.assert(service.putIfAbsent("baz", () -> "qux").equals("qux"));
		asserts.assert(getCookie("prefix:baz") == "qux");

		setCookie("prefix:baz", "456");
		asserts.assert(service.putIfAbsent("baz", () -> "XYZ").equals("456"));
		asserts.assert(getCookie("prefix:baz") == "456");

		return asserts.done();
	}

	/** Tests the `putObjectIfAbsent()` method. **/
	public function testPutObjectIfAbsent() {
		// It should add a new entry if it does not exist.
		var service = new CookieStore();
		asserts.assert(getCookie("foo") == null);
		asserts.assert(service.putObjectIfAbsent("foo", () -> "bar").equals("bar"));
		asserts.assert(getCookie("foo") == '"bar"');

		// It should not add a new entry if it already exists.
		setCookie("foo", "123");
		asserts.assert(service.putObjectIfAbsent("foo", () -> 999).equals(123));
		asserts.assert(getCookie("foo") == "123");

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(getCookie("prefix:baz") == null);
		asserts.assert(service.putObjectIfAbsent("baz", () -> "qux").equals("qux"));
		asserts.assert(getCookie("prefix:baz") == '"qux"');

		setCookie("prefix:baz", "456");
		asserts.assert(service.putObjectIfAbsent("baz", () -> 999).equals(456));
		asserts.assert(getCookie("prefix:baz") == "456");

		return asserts.done();
	}

	/** Tests the `remove()` method. **/
	public function testRemove() {
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		// It should properly remove the cookies.
		new CookieStore().remove("foo");
		asserts.assert(document.cookie == "prefix:baz=qux");
		asserts.assert(getCookie("foo") == null);

		// It should handle the key prefix.
		new CookieStore({keyPrefix: "prefix:"}).remove("baz");
		asserts.assert(document.cookie.length == 0);
		asserts.assert(getCookie("prefix:baz") == null);

		return asserts.done();
	}

	/** Tests the `set()` method. **/
	public function testSet() {
		// It should properly set the cookies.
		var service = new CookieStore();
		asserts.assert(getCookie("foo") == null);

		service.set("foo", "bar");
		asserts.assert(getCookie("foo") == "bar");

		service.set("foo", "123");
		asserts.assert(getCookie("foo") == "123");

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(getCookie("prefix:baz") == null);

		service.set("baz", "qux");
		asserts.assert(getCookie("prefix:baz") == "qux");

		service.set("baz", "456");
		asserts.assert(getCookie("prefix:baz") == "456");

		return asserts.done();
	}

	/** Tests the `setObject()` method. **/
	public function testSetObject() {
		// It should properly serialize and set the cookies.
		var service = new CookieStore();
		asserts.assert(getCookie("foo") == null);

		service.setObject("foo", "bar");
		asserts.assert(getCookie("foo") == '"bar"');

		service.setObject("foo", 123);
		asserts.assert(getCookie("foo") == "123");

		service.setObject("foo", {key: "value"});
		asserts.assert(getCookie("foo") == '{"key":"value"}');

		// It should handle the key prefix.
		service = new CookieStore({keyPrefix: "prefix:"});
		asserts.assert(getCookie("prefix:baz") == null);

		service.setObject("baz", "qux");
		asserts.assert(getCookie("prefix:baz") == '"qux"');

		service.setObject("baz", 456);
		asserts.assert(getCookie("prefix:baz") == "456");

		service.setObject("baz", {key: "value"});
		asserts.assert(getCookie("prefix:baz") == '{"key":"value"}');

		return asserts.done();
	}

	/** Tests the `toJSON()` method. **/
	public function testToJson() {
		// It should return an empty array for an empty cookie store.
		final service = new CookieStore();
		asserts.assert(Json.stringify(service) == "[]");

		// It should return a non-empty array for a non-empty cookie store.
		setCookie("foo", "bar");
		setCookie("prefix:baz", "qux");

		var json = Json.stringify(service);
		asserts.assert(json.contains('["foo","bar"]'));
		asserts.assert(json.contains('["prefix:baz","qux"]'));

		// It should handle the key prefix.
		json = Json.stringify(new CookieStore({keyPrefix: "prefix:"}));
		asserts.assert(!json.contains('["foo","bar"]'));
		asserts.assert(json.contains('["baz","qux"]'));

		return asserts.done();
	}

	/** Tests the `toString()` method. **/
	public function testToString()
		return assert(new CookieStore().toString() == document.cookie);

	/** Gets the value of the cookie with the specified name. **/
	inline function getCookie(name: String) return CookieStore.all[name];

	/** Removes the cookie with the specified name. **/
	inline function removeCookie(name: String) document.cookie = '$name=; expires=Thu, 01 Jan 1970 00:00:00 GMT; max-age=0';

	/** Sets a cookie with the specified name and value. **/
	inline function setCookie(name: String, value: String) document.cookie = '$name=${value.urlEncode()}';
}
