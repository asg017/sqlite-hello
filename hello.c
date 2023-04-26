#include "sqlite3ext.h"

SQLITE_EXTENSION_INIT1

static void hello(sqlite3_context *context, int argc, sqlite3_value **argv) {
  sqlite3_result_text(
      context, 
      (char *) sqlite3_mprintf("Hello, %s!", sqlite3_value_text(argv[0])), 
      -1, 
      sqlite3_free
  );
}
static void hello_version(sqlite3_context *context, int argc, sqlite3_value **argv) {
  sqlite3_result_text(context, SQLITE_HELLO_VERSION, -1, SQLITE_STATIC);
}


#ifdef _WIN32
__declspec(dllexport)
#endif
int sqlite3_hello_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi) {
  SQLITE_EXTENSION_INIT2(pApi);
  int rc = SQLITE_OK;
  if(rc == SQLITE_OK) rc = sqlite3_create_function_v2(db, "hello", 1, SQLITE_UTF8 | SQLITE_DETERMINISTIC, 0, hello, 0, 0, 0);
  if(rc == SQLITE_OK) rc = sqlite3_create_function_v2(db, "hello_version", 0, SQLITE_UTF8 | SQLITE_DETERMINISTIC, 0, hello_version, 0, 0, 0);
  return rc;
}
