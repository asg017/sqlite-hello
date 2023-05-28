require 'sqlite3'
require 'sqlite_hello'

db = SQLite3::Database.new(':memory:')
db.enable_load_extension(true)
SqliteHello.load(db)
db.enable_load_extension(false)

result = db.execute('SELECT hello("Alex")')
puts result.first.first
