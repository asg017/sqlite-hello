package hello

// #cgo LDFLAGS: -lsqlite_hello0 -lsqlite_hola0
// #cgo CFLAGS: -I. -DSQLITE_CORE
// #include <sqlite3ext.h>
//
// extern int sqlite3_hello_init(sqlite3*, char**, const sqlite3_api_routines*);
// extern int sqlite3_hola_init(sqlite3*, char**, const sqlite3_api_routines*);
//
import "C"

func Auto() {
	C.sqlite3_auto_extension( (*[0]byte) ((C.sqlite3_hello_init)) );
	C.sqlite3_auto_extension( (*[0]byte) ((C.sqlite3_hola_init)) );
}
func Cancel() {
	C.sqlite3_cancel_auto_extension( (*[0]byte) (C.sqlite3_hello_init) );
	C.sqlite3_cancel_auto_extension( (*[0]byte) (C.sqlite3_hola_init) );
}
