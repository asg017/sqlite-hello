package hello

import (
	hello "github.com/asg017/sqlite-hello/go/hello"
	hola "github.com/asg017/sqlite-hello/go/hola"
)


func init() {
	hello.Auto()
	hola.Auto()
}
