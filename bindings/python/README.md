# The `sqlite-hello` Python package

`sqlite-hello` is also distributed on PyPi as a Python package, for use in Python applications. It works well with the builtin [`sqlite3`](https://docs.python.org/3/library/sqlite3.html) Python module.

```
pip install sqlite-hello
```

## Usage

The `sqlite-hello` python package exports two functions: `loadable_path()`, which returns the full path to the loadable extension, and `load(conn)`, which loads the `sqlite-hello` extension into the given [sqlite3 Connection object](https://docs.python.org/3/library/sqlite3.html#connection-objects).

```python
import sqlite_hello
print(sqlite_hello.loadable_path())
# '/.../venv/lib/python3.9/site-packages/sqlite_hello/hello0'

import sqlite3
conn = sqlite3.connect(':memory:')
sqlite_hello.load(conn)
conn.execute('select hello_version(), hello("alex")').fetchone()
```

See [the full API Reference](#api-reference) for the Python API, and [`docs.md`](../docs.md) for documentation on the `sqlite-hello` SQL API.

See [`datasette-sqlite-hello`](../datasette_sqlite_hello/) for a Datasette plugin that is a light wrapper around the `sqlite-hello` Python package.

## Compatibility

Currently the `sqlite-hello` Python package is only distributed on PyPi as pre-build wheels, it's not possible to install from the source distribution. This is because the underlying `sqlite-hello` extension requires a lot of build dependencies like `make`, `cc`, and `cargo`.

If you get a `unsupported platform` error when pip installing `sqlite-hello`, you'll have to build the `sqlite-hello` manually and load in the dynamic library manually.

## API Reference

<h3 name="loadable_path"><code>loadable_path()</code></h3>

Returns the full path to the locally-install `sqlite-hello` extension, without the filename.

This can be directly passed to [`sqlite3.Connection.load_extension()`](https://docs.python.org/3/library/sqlite3.html#sqlite3.Connection.load_extension), but the [`sqlite_hello.load()`](#load) function is preferred.

```python
import sqlite_hello
print(sqlite_hello.loadable_path())
# '/.../venv/lib/python3.9/site-packages/sqlite_hello/hello0'
```

> Note: this extension path doesn't include the file extension (`.dylib`, `.so`, `.dll`). This is because [SQLite will infer the correct extension](https://www.sqlite.org/loadext.html#loading_an_extension).

<h3 name="load"><code>load(connection)</code></h3>

Loads the `sqlite-hello` extension on the given [`sqlite3.Connection`](https://docs.python.org/3/library/sqlite3.html#sqlite3.Connection) object, calling [`Connection.load_extension()`](https://docs.python.org/3/library/sqlite3.html#sqlite3.Connection.load_extension).

```python
import sqlite_hello
import sqlite3
conn = sqlite3.connect(':memory:')

conn.enable_load_extension(True)
sqlite_hello.load(conn)
conn.enable_load_extension(False)

conn.execute('select hello_version(), hello()').fetchone()
# ('v0.1.0', '01gr7gwc5aq22ycea6j8kxq4s9')
```
