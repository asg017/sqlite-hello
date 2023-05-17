# sqlite-hello

The smallest possible "hello world" SQLite extension. Meant for testing and debugging loadable SQLite extensions.

Exposes a single SQL scalar function `hello()`, that takes a single `name` argument and returns the string `"Hello, name!"`.

```sql
.load ./hello0
select hello('Alex');
'Hello, Alex!'
```

- [ ] Python
- [ ] Node.js
- [ ] Deno
- [ ] Datasette
- [ ] loadable sqlite3

- [ ] spm

- [ ] Ruby
- [ ] Go
- [ ] Rust
- [ ] C/C++

## loadable

```
.
├── sqlite-hello-v0.1.0-loadable-macos-x86_64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── hello0.dylib
│   └── hola0.dylib
├── sqlite-hello-v0.1.0-loadable-macos-aarch64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── hello0.dylib
│   └── hola0.dylib
├── sqlite-hello-v0.1.0-loadable-linux-x86_64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── hello0.so
│   └── hola0.so
└── sqlite-hello-v0.1.0-loadable-windows-x86_64.zip
    ├── README
    ├── LICENSE
    ├── hello0.dll
    └── hola0.dll
```

## static

```
.
├── sqlite-hello-v0.1.0-static-macos-x86_64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── sqlite-hello.h
│   ├── hello0.a
│   └── hola0.a
├── sqlite-hello-v0.1.0-static-macos-aarch64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── sqlite-hello.h
│   ├── hello0.a
│   └── hola0.a
├── sqlite-hello-v0.1.0-static-linux-x86_64.tar.gz
│   ├── README
│   ├── LICENSE
│   ├── sqlite-hello.h
│   ├── hello0.a
│   └── hola0.a
└── sqlite-hello-v0.1.0-static-windows-x86_64.zip
    ├── README
    ├── LICENSE
    ├── sqlite-hello.h
    ├── hello0.a
    └── hola0.a
```

```
.
├── .github
│   └── workflows
│     releases
│     ├── release.yaml
│     └── test.yaml
├── bindings
│   ├── datasette
│   ├── deno
│   ├── elixir
│   ├── go
│   ├── node
│   ├── python
│   ├── ruby
│   └── rust
├── scripts
│   ├── npm_generate_platform_packages.sh
│   ├── rename_wheels.py
│   ├── ruby_generate_package.sh
│   └── deno_generate_package.sh
├── tests
│   └── test-loadable.py
├── examples
│   ├── datasette
│   ├── deno
│   ├── elixir
│   ├── go
│   ├── node
│   ├── python
│   ├── ruby
│   └── rust
├── .gitignore
├── Makefile
├── README.md
├── sqlite-hello.c
├── sqlite-hello.h
├── sqlite-hola.c
├── sqlite-hola.h
└── VERSION
```
