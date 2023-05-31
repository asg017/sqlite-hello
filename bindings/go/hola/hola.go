// utilities
package hola

// #cgo LDFLAGS: -lsqlite_hola0
// #cgo CFLAGS: -DSQLITE_CORE
// #include <sqlite3ext.h>
// #include "sqlite-hola.h"
import "C"

// Once called, every future new SQLite3 connection created in this process
// will have the hola extension loaded. It will persist until Cancel() is
// called.
//
// Calls sqlite3_auto_extension() under the hood.
func Auto() {
	C.sqlite3_auto_extension( (*[0]byte) ((C.sqlite3_hola_init)) );
}

// "Cancels" any previous calls to Auto(). Any new SQLite3 connections created
// will not have the hola extension loaded.
//
// Calls sqlite3_cancel_auto_extension() under the hood.
func Cancel() {
	C.sqlite3_cancel_auto_extension( (*[0]byte) (C.sqlite3_hola_init) );
}
