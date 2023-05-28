#[cfg(feature = "hello")]
#[link(name = "sqlite_hello0")]
extern "C" {
    pub fn sqlite3_hello_init();
}

#[cfg(feature = "hola")]
#[link(name = "sqlite_hola0")]
extern "C" {
    pub fn sqlite3_hola_init();
}

#[cfg(test)]
mod tests {
    use super::*;

    use libsqlite3_sys::sqlite3_auto_extension;
    use rusqlite::Connection;

    #[test]
    fn test_rusqlite_auto_extension() {
        unsafe {
            sqlite3_auto_extension(Some(sqlite3_hello_init));
            sqlite3_auto_extension(Some(sqlite3_hola_init));
        }

        let conn = Connection::open_in_memory().unwrap();

        let result: String = conn
            .query_row("select hello(?)", ["alex"], |x| x.get(0))
            .unwrap();

        assert_eq!(result, "Hello, alex!");

        let result: String = conn
            .query_row("select hola(?)", ["alex"], |x| x.get(0))
            .unwrap();

        assert_eq!(result, "¡Hola, alex!");
    }
}
