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

prefix=dist
$(prefix):
	mkdir -p $(prefix)

DEFINE_HELLO=-DSQLITE_HELLO_VERSION="\"v$(VERSION)\""

TARGET_LOADABLE_HELLO=$(prefix)/hello0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE_HOLA=$(prefix)/hola0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE=$(TARGET_LOADABLE_HELLO) $(TARGET_LOADABLE_HOLA)

loadable: $(TARGET_LOADABLE)

TARGET_STATIC_HELLO=$(prefix)/libsqlite_hello0.a
TARGET_STATIC_HOLA=$(prefix)/libsqlite_hola0.a
TARGET_STATIC=$(TARGET_STATIC_HELLO) $(TARGET_STATIC_HOLA)

static: $(TARGET_STATIC)

$(TARGET_LOADABLE_HELLO): hello.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	$(DEFINE_HELLO) $(CFLAGS) \
	$< -o $@

$(TARGET_STATIC_HELLO): hello.c $(prefix)
	gcc -Ivendor $(DEFINE_HELLO) $(CFLAGS) -DSQLITE_CORE \
	-O3 -c  $< -o $(prefix)/hello.o
	ar rcs $@ $(prefix)/hello.o

$(TARGET_LOADABLE_HOLA): hola.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	$(DEFINE_HELLO) $(CFLAGS) \
	$< -o $@

$(TARGET_STATIC_HOLA): hola.c $(prefix)
	gcc -Ivendor $(DEFINE_HELLO) $(CFLAGS) -DSQLITE_CORE \
	-O3 -c  $< -o $(prefix)/hola.o
	ar rcs $@ $(prefix)/hola.o

clean:
	rm -rf dist/*

test:
	sqlite3 :memory: '.read test.sql'

.PHONY: version loadable static test clean gh-release \
	ruby

gh-release:
	git add VERSION
	git commit -m "v$(VERSION)"
	git tag v$(VERSION)
	git push origin main v$(VERSION)
	gh release create v$(VERSION) --prerelease --notes="" --title=v$(VERSION)

bindings/ruby/lib/version.rb: bindings/ruby/lib/version.rb.tmpl VERSION
	VERSION=$(VERSION) envsubst < $< > $@

version:
	make bindings/ruby/lib/version.rb
