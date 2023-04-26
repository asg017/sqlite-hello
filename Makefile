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

TARGET_LOADABLE_HELLO=$(prefix)/hello0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE_HOLA=$(prefix)/hola0.$(LOADABLE_EXTENSION)
TARGET_LOADABLE=$(TARGET_LOADABLE_HELLO) $(TARGET_LOADABLE_HOLA)
loadable: $(TARGET_LOADABLE)

$(TARGET_LOADABLE_HELLO): hello.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	-DSQLITE_HELLO_VERSION="\"v$(VERSION)\"" \
	$(CFLAGS) \
	$< -o $@

$(TARGET_LOADABLE_HOLA): hola.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	-DSQLITE_HELLO_VERSION="\"v$(VERSION)\"" \
	$(CFLAGS) \
	$< -o $@

clean:
	rm -rf dist/*

test:
	sqlite3 :memory: '.read test.sql'
	
.PHONY: loadable test clean gh-release

gh-release:
	git add VERSION
	git commit -m "v$(VERSION)"
	git tag v$(VERSION)
	git push origin main v$(VERSION)
	gh release create v$(VERSION) --prerelease --notes="" --title=v$(VERSION)