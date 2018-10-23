defmodule Issues.MixProject do
  use Mix.Project

  def project do
    [
      app: :issues,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: escript_config(),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :httpoison, :jsx]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:httpoison, "~> 0.4"},
      {:jsx, "~> 2.0"}
    ]
  end

  def escript_config do
    [main_module: Issues.CLI]
  end

  defp package do
    [
      maintainers: ["Anton Fagerberg"],
      description: "A concurrent project",
      licenses: ["Apache 2"],
      links: %{"GitHub" => "https://github.com/SteveJeson/kv_umbrella/tree/master/apps/issues"},
      files: [
        "mix.exs",
        "README.md",
      ]
    ]
  end
end
