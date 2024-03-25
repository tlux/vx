defmodule Vx.MixProject do
  use Mix.Project

  @github_url "https://github.com/tlux/vx"
  @version "0.4.0"

  def project do
    [
      app: :vx,
      version: @version,
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.post": :test,
        coveralls: :test,
        credo: :test,
        dialyzer: :test,
        test: :test
      ],
      dialyzer: dialyzer(),

      # Docs
      name: "Vx",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:castore, "~> 1.0", only: :test, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test]}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Readme"]
      ],
      main: "readme",
      source_url: @github_url,
      source_ref: "v#{@version}",
      groups_for_modules: [
        Types: [
          Vx.Any,
          Vx.Atom,
          Vx.Float,
          Vx.Integer,
          Vx.List,
          Vx.Literal,
          Vx.Boolean,
          Vx.Enum,
          Vx.Map,
          Vx.Number,
          Vx.String,
          Vx.Struct,
          Vx.Tuple
        ],
        Combinations: [
          Vx.Intersect,
          Vx.Union
        ],
        Modifiers: [
          Vx.Not,
          Vx.Nullable,
          Vx.Optional
        ],
        Helpers: [
          Vx.Match,
          Vx.Validator
        ],
        Protocols: [
          Vx.Validatable,
          Vx.Inspectable
        ],
        "Low-Level API": [
          Vx.Type,
          Vx.Constraint
        ]
      ]
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/vx.plt"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def package do
    [
      description: "An Elixir schema parser",
      exclude_patterns: [~r/\Apriv\/plts/],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @github_url
      }
    ]
  end
end
