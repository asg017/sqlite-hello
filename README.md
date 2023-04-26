# sqlite-hello

The smallest possible "hello world" SQLite extension. Meant for testing and debugging loadable SQLite extensions.

Exposes a single SQL scalar function `hello()`, that takes a single `name` argument and returns the string `"Hello, name!"`.

```sql
.load ./hello0
select hello('Alex');
'Hello, Alex!'
```
