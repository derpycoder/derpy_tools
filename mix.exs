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
      deps: deps(),
      name: "Derpy Tools",
      source_url: "https://github.com/derpycoder/derpy_tools",
      homepage_url: "https://derpytools.site",
      docs: docs()
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
      {:argon2_elixir, "~> 3.1"},
      {:bandit, "~> 1.0.0-pre.12"},
      {:brotli, "~> 0.3.2", runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dotenvy, "~> 0.8.0"},
      {:ecto_sql, "~> 3.10"},
      {:ecto_sqlite3, ">= 0.10.3"},
      {:ecto_sqlite3_extras, "~> 1.2.0"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:ex_doc, "~> 0.30"},
      {:finch, "~> 0.16"},
      {:floki, "~> 0.34"},
      {:gettext, "~> 0.23"},
      {:imgproxy, "~> 3.0"},
      {:jason, "~> 1.4"},
      {:pathex, "~> 2.5"},
      {:phoenix, "~> 1.7.7"},
      {:phoenix_bakery, "~> 0.1.2", runtime: false},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.8.1"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 0.19.5"},
      {:prom_ex, "~> 1.8.0"},
      {:redirect, "~> 0.4.0"},
      {:req, "~> 0.3.11"},
      {:sobelow, "~> 0.13", only: [:dev, :test], runtime: false},
      {:swoosh, "~> 1.11"},
      {:tailwind, "~> 0.2.1", runtime: Mix.env() == :dev},
      {:tailwind_formatter, "~> 0.3.7", only: [:dev, :test], runtime: false},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:timex, "~> 3.7"},
      {:unplug, "~> 1.0"},
      {:uuidv7, "~> 0.2.0"}
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
      "meilisearch.setup": ["run priv/meilisearch/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end

  defp docs do
    [
      main: "DerpyTools",
      source_ref: "main",
      formatters: ["html"],
      extra_section: "GUIDES",
      api_reference: true,
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules(),
      assets: "images"
      # canonical
    ]
  end

  defp extras do
    [
      "README.md",
      "livebooks/architecture.livemd",
      "guides/overview.md"
    ]
  end

  defp groups_for_extras do
    [
      Livebooks: ~r/livebooks\/[^\/]+\.livemd/,
      Guides: ~r/guides\/[^\/]+\.md/
    ]
  end

  defp groups_for_modules do
    [
      # "Mix Tasks": [
      #   Mix.Tasks.App.Setup
      # ],
      Utils: [
        DerpyToolsWeb.Nav,
        DerpyToolsWeb.Permit
      ],
      Blog: [
        DerpyCoderWeb.BlogPosts,
        DerpyToolsWeb.CodeSnippets
      ]
    ]
  end
end
