use libsqlite3_sys::sqlite3_auto_extension;
use rusqlite::{Connection, Result};
use sqlite_hello;

fn main() -> Result<()> {
    unsafe {
        sqlite3_auto_extension(Some(sqlite_hello::sqlite3_hello_init));
        sqlite3_auto_extension(Some(sqlite_hello::sqlite3_hola_init));
    }

    let conn = Connection::open_in_memory()?;
    let mut stmt = conn.prepare("SELECT 1 + 1, hello('alex'), hola('alex')")?;
    let mut rows = stmt.query([]).unwrap();
    let row = rows.next().unwrap().unwrap();

    let value: i32 = row.get(0).unwrap();
    println!("{:?}", value);

    let value: String = row.get(1).unwrap();
    println!("{:?}", value);

    let value: String = row.get(2).unwrap();
    println!("{:?}", value);

    Ok(())
}
