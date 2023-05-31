defmodule SqliteHello.MixProject do
  use Mix.Project

  @source_url "https://github.com/asg017/sqlite-hello/bindings/elixir"
  @version File.read!(Path.expand("../../VERSION", __DIR__)) |> String.trim()

  def project do
    [
      app: :sqlite_hello,
      version: @version,
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
      description: description(),
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

    defp description() do
    "sqlite-hello please."
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "sqlite-hello-checksum.exs"
      ],
      links: %{"GitHub" => @source_url},
      maintainers: ["Alex Garcia", "Tommy Rodriguez"],
      licenses: ["MIT"],
    ]
  end
end
