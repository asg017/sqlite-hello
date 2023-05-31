defmodule SqliteHello.MixProject do
  use Mix.Project

  @source_url "https://github.com/asg017/sqlite-hello/bindings/elixir"

  def project do
    [
      app: :sqlite_hello,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "sqlite_hello",
      source_url: "https://github.com/asg017/sqlite-hello",
      homepage_url: "https://github.com/asg017/sqlite-hello",
      docs: [
        main: "SqliteHello",
        extras: ["README.md"],
        source_ref: "v0.1.0"
      ],
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, inets: :optional, ssl: :optional],
      mod: {SqliteHello, []},
      env: [default: []]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},
      {:ecto_sqlite3, ">= 0.0.0"},
      {:castore, ">= 0.0.0"},
      {:hex_core, "~> 0.10.0"}
    ]
  end

  defp package do
    [
      name: "sqlite-hello",
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "checksum-sqlite-hello.exs"
      ],
      links: %{"GitHub" => @source_url},
      maintainers: ["Alex Garcia", "Tommy Rodriguez"]
      licenses: ["MIT"],
    ]
  end
end
