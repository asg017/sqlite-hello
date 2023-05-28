import sqlite3
import sqlite_hello

db = sqlite3.connect(':memory:')
db.enable_load_extension(True)
sqlite_hello.load(db)
db.enable_load_extension(False)

version, result = db.execute('select hello_version(), hello("alex")').fetchone()

print(version, result)
