package hola

// #cgo LDFLAGS: -lsqlite_hola0
// #cgo CFLAGS: -DSQLITE_CORE
// #include <sqlite3ext.h>
// #include "sqlite-hola.h"
import "C"

func Auto() {
	C.sqlite3_auto_extension( (*[0]byte) ((C.sqlite3_hola_init)) );
}
func Cancel() {
	C.sqlite3_cancel_auto_extension( (*[0]byte) (C.sqlite3_hola_init) );
}
