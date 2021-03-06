defmodule BarBuddy.Mixfile do
  use Mix.Project

  def project do
    [
      app: :barbuddy,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BarBuddy.Application, []},
      extra_applications: [:corsica, :logger, :runtime_tools, :httpoison, :postgrex, :ecto]
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
      {:phoenix, "~> 1.3.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:httpoison, dependency: "~> 1.0", override: true},
      {:plug, "~> 1.0"},
      {:corsica, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:fastimage, "~> 1.0.0-rc2"},
      {:distillery, "~> 1.5", runtime: false},
      {:guardian, "~> 1.1.0", git: "https://github.com/ueberauth/guardian.git"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
