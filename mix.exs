defmodule DerpyTools.MixProject do
  use Mix.Project

  def project do
    [
      app: :derpy_tools,
      version: "0.1.1",
      elixir: "~> 1.15.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {DerpyTools.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:argon2_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7.6"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_sqlite3, ">= 0.10.3"},
      {:ecto_sqlite3_extras, "~> 1.2.0"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19.0"},
      {:floki, ">= 0.30.0"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:req, "~> 0.3.0"},
      {:dotenvy, "~> 0.8.0"},
      {:prom_ex, "~> 1.8.0"},
      {:bandit, "~> 1.0-pre"},
      {:redirect, "~> 0.4.0"},
      {:timex, "~> 3.7"},
      {:imgproxy, "~> 3.0"},
      {:phoenix_bakery, "~> 0.1.2", runtime: false},
      {:brotli, "~> 0.3.2", runtime: false},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:unplug, "~> 1.0"},
      {:pathex, "~> 2.5"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:tailwind_formatter, "~> 0.3.6", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
