package hello

import (
	hello "github.com/asg017/sqlite-hello/bindings/go/hello"
	hola "github.com/asg017/sqlite-hello/bindings/go/hola"
)


func init() {
	hello.Auto()
	hola.Auto()
}
