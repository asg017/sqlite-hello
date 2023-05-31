defmodule Mix.Tasks.SqliteHello.Install do
  @shortdoc "Installs SqliteHello extension files"
  use Mix.Task

  @impl true
  def run(_args) do
    Application.ensure_all_started(:sqlite_hello)

    SqliteHello.install()
  end
end
