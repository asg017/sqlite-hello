Mix.install([
  {:sqlite_hello, path: "../"},
  {:exqlite, "~> 0.13.0"}
], verbose: true)

Mix.Task.run("sqlite_hello.install")

alias Exqlite.Basic

{:ok, conn} = Basic.open("example.db")

:ok = Exqlite.Basic.enable_load_extension(conn)
Exqlite.Basic.load_extension(conn, SqliteHello.loadable_path_hola0())
Exqlite.Basic.load_extension(conn, SqliteHello.loadable_path_hello0())

{:ok, [[version]], [_]} = Basic.exec(conn, "select hello_version()") |> Basic.rows()

IO.puts("version: #{version}")
