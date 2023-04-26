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

TARGET_LOADABLE=$(prefix)/hello0.$(LOADABLE_EXTENSION)
loadable: $(TARGET_LOADABLE)

$(TARGET_LOADABLE): hello.c $(prefix)
	gcc -fPIC -shared \
	-Ivendor \
	-O3 \
	-DSQLITE_HELLO_VERSION="\"v$(VERSION)\"" \
	$< -o $@

clean:
	rm dist/*

test:
	sqlite3 :memory: '.read test.sql'
	
.PHONY: loadable test clean