# Iteration
The [`CookieStore`](usage/api.md) class is iterable: it implements the [`KeyValueIterable<String, String>`](https://api.haxe.org/KeyValueIterable.html) protocol.
You can go through all key/value pairs contained using a `for` loop:

```haxe
import cookies.CookieStore;

function main() {
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
}
```

> The order of keys is user-agent defined, so you should not rely on it.

If you have configured the instance to use a [key prefix](usage/key_prefix.md), the iteration will only loop over the values that have that same key prefix:

```haxe
import cookies.CookieStore;

function main() {
  final cookieStore = new CookieStore();
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
```

> The prefix is stripped from the keys returned by the iteration.
