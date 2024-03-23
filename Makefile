VERSION=$(shell cat VERSION)

ifeq ($(shell uname -s),Darwin)
CONFIG_DARWIN=y
else ifeq ($(OS),Windows_NT)
CONFIG_WINDOWS=y
else
CONFIG_LINUX=y
endif

ifdef CONFIG_DARWIN
LOADABLE_EXTENSION=dylib
endif

ifdef CONFIG_LINUX
LOADABLE_EXTENSION=so
endif

ifdef CONFIG_WINDOWS
LOADABLE_EXTENSION=dll
endif


ifdef python
PYTHON=$(python)
else
PYTHON=python3
endif


ifdef IS_MACOS_ARM
RENAME_WHEELS_ARGS=--is-macos-arm
else
RENAME_WHEELS_ARGS=
endif

prefix=dist
$(prefix):
	mkdir -p $(prefix)

DEFINE_HELLO=-DSQLITE_HELLO_VERSION="\"v$(VERSION)\""

TARGET_LOADABLE_HELLO=$(prefix)/hello0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE_HOLA=$(prefix)/hola0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE=$(TARGET_LOADABLE_HELLO) $(TARGET_LOADABLE_HOLA)

TARGET_STATIC_HELLO=$(prefix)/libsqlite_hello0.a
TARGET_STATIC_HELLO_H=$(prefix)/sqlite-hello.h
TARGET_STATIC_HOLA=$(prefix)/libsqlite_hola0.a
TARGET_STATIC_HOLA_H=$(prefix)/sqlite-hola.h
TARGET_STATIC=$(TARGET_STATIC_HELLO) $(TARGET_STATIC_HELLO_H) $(TARGET_STATIC_HOLA) $(TARGET_STATIC_HOLA_H)


loadable: $(TARGET_LOADABLE)
static: $(TARGET_STATIC)

$(TARGET_LOADABLE_HELLO): sqlite-hello.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	$(DEFINE_HELLO) $(CFLAGS) \
	$< -o $@

$(TARGET_STATIC_HELLO): sqlite-hello.c $(prefix)
	gcc -Ivendor $(DEFINE_HELLO) $(CFLAGS) -DSQLITE_CORE \
	-O3 -c  $< -o $(prefix)/hello.o
	ar rcs $@ $(prefix)/hello.o

$(TARGET_STATIC_HELLO_H): sqlite-hello.h $(prefix)
	cp $< $@

$(TARGET_LOADABLE_HOLA): sqlite-hola.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	$(DEFINE_HELLO) $(CFLAGS) \
	$< -o $@

$(TARGET_STATIC_HOLA): sqlite-hola.c $(prefix)
	gcc -Ivendor $(DEFINE_HELLO) $(CFLAGS) -DSQLITE_CORE \
	-O3 -c  $< -o $(prefix)/hola.o
	ar rcs $@ $(prefix)/hola.o

$(TARGET_STATIC_HOLA_H): sqlite-hola.h $(prefix)
	cp $< $@

clean:
	rm -rf dist/*

test:
	sqlite3 :memory: '.read test.sql'

.PHONY: version loadable static test clean gh-release \
	ruby

gh-release:
	make version
	git add --all
	git commit -m "v$(VERSION)"
	git tag v$(VERSION)
	git push origin main v$(VERSION)
	gh release create v$(VERSION) --prerelease --notes="" --title=v$(VERSION)


TARGET_WHEELS=$(prefix)/wheels
INTERMEDIATE_PYPACKAGE_EXTENSION=bindings/python/sqlite_hello/

$(TARGET_WHEELS): $(prefix)
	mkdir -p $(TARGET_WHEELS)

bindings/rust/Cargo.toml: bindings/rust/Cargo.toml.tmpl VERSION
	VERSION=$(VERSION) envsubst < $< > $@

bindings/rust/Cargo.lock: bindings/rust/Cargo.toml
	cargo update --manifest-path=$<

bindings/go/hello/sqlite-hello.h: sqlite-hello.h
	cp $< $@

bindings/go/hola/sqlite-hola.h: sqlite-hola.h
	cp $< $@

rust: bindings/rust/Cargo.toml bindings/rust/Cargo.lock

version:
	make rust
