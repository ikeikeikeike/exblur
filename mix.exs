defmodule Exblur.Mixfile do
  use Mix.Project

  def project do
    [app: :exblur,
     version: "0.0.1",
     elixir: ">= 1.0.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Exblur, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :mongodb_ecto, :ex_aws,
                    :bing_translator, :exfavicon, :yaml_elixir, :con_cache,
                    :ua_inspector, :calendar, :timex, :quantum]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
     {:httpoison, ">= 0.8.0"},

     {:phoenix, ">= 1.1.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, ">= 2.0.0"},
     {:phoenix_html, ">= 2.4.0"},
     {:phoenix_live_reload, ">= 1.0.0", only: :dev},
     {:gettext, ">= 0.10.0"},
     {:cowboy, ">= 1.0.0"},
     {:mongodb_ecto, ">= 0.1.0"},
     {:bing_translator, ">= 0.2.0"},
     {:exfavicon, ">= 0.3.2"},
     {:arc, ">= 0.2.2"},
     {:arc_ecto, ">= 0.3.0"},
     {:ex_aws, ">= 0.4.10"},
     {:httpoison, ">= 0.8.0"},
     {:tirexs, "~> 0.7.0"},
     # {:tirexs, github: "Zatvobor/tirexs"},
     {:timex, ">= 1.0.1"},
     {:timex_ecto, ">= 0.9.0"},
     {:calendar, ">= 0.12.4"},
     {:exromaji, ">= 0.3.0"},
     {:exkanji, ">= 0.2.0"},
     {:yaml_elixir, ">= 1.0.0"},
     {:yamerl, github: "yakaz/yamerl"},
     {:con_cache, ">= 0.10.0"},
     {:scrivener_html, github: "ikeikeikeike/scrivener_html"},
     {:ua_inspector, ">= 0.10.0"},
     {:phoenix_html_simplified_helpers, ">= 0.3.0"},
     {:simple_format, ">= 0.1.0"},
     {:quantum, ">= 1.7.0"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
