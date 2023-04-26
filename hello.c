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


#ifdef _WIN32
__declspec(dllexport)
#endif
int sqlite3_hello_init(sqlite3 *db, char **pzErrMsg, const sqlite3_api_routines *pApi) {
  SQLITE_EXTENSION_INIT2(pApi);
  return sqlite3_create_function_v2(db, "hello", 1, SQLITE_UTF8 | SQLITE_DETERMINISTIC, 0, hello, 0, 0, 0);
}
