# The `datasette-sqlite-hello` Datasette Plugin

`datasette-sqlite-hello` is a [Datasette plugin](https://docs.datasette.io/en/stable/plugins.html) that loads the [`sqlite-hello`](https://github.com/asg017/sqlite-hello) extension in Datasette instances.

```
datasette install datasette-sqlite-hello
```

See [`docs.md`](../../docs.md) for a full API reference for the hello SQL functions.

Alternatively, when publishing Datasette instances, you can use the `--install` option to install the plugin.

```
datasette publish cloudrun data.db --service=my-service --install=datasette-sqlite-hello

```
