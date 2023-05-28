#ifndef _SQLITE_HELLO_H
#define _SQLITE_HELLO_H

//#include "sqlite3.h"

#ifdef __cplusplus
extern "C" {
#endif

int sqlite3_hello_init(sqlite3*, char**, const sqlite3_api_routines*);

#ifdef __cplusplus
}  /* end of the 'extern "C"' block */
#endif

#endif /* ifndef _SQLITE_HELLO_H */
