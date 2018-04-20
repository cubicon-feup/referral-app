defmodule App.Mixfile do
  use Mix.Project

  def project do
    [
      app: :app,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(), 
      test_coverage: [ 
        tool: ExCoveralls 
      ], 
      preferred_cli_env: [ 
        "coveralls": :test, 
        "coveralls.detail": :test, 
        "coveralls.post": :test, 
        "coveralls.html": :test 
      ] 
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {App.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:credo, "~> 0.3", only: [:dev, :test]},
      {:excoveralls, "~> 0.7", only: [:dev, :test]},
      {:guardian, "~> 1.0-beta"},
      {:comeonin, "~> 4.0"},
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:bcrypt_elixir, "~> 0.12"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
