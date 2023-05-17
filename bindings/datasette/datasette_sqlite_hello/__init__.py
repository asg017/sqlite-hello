from datasette import hookimpl
import sqlite_hello

from datasette_sqlite_hello.version import __version_info__, __version__

@hookimpl
def prepare_connection(conn):
    conn.enable_load_extension(True)
    sqlite_hello.load(conn)
    conn.enable_load_extension(False)
