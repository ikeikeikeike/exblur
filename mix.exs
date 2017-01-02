defmodule Exblur.Mixfile do
  use Mix.Project

  def project do
    [app: :exblur,
     version: version,
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  defp version do
    v = "0.10.2"
    File.write! "VERSION", v
    v
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Exblur, []},
     applications: [
       :phoenix,
       :phoenix_html,
       :phoenix_pubsub,
       :cowboy,
       :logger,
       :gettext,
       :phoenix_ecto,
       :postgrex,
       :mongodb_ecto,
       :ex_aws,
       :bing_translator,
       :exfavicon,
       :yaml_elixir,
       :con_cache,
       :ua_inspector,
       :calendar,
       :timex,
       :quantum,
       :sitemap,
       :html_entities,
       :redisank,
       # :exsentry,

       :esx,
       :scrivener_esx,
     ],
     included_applications: [
       :arc,
       :timex_ecto,
       :scrivener,
       :simple_format,
       # :tirexs,
       :exkanji,
       :exromaji,
       :arc_ecto,
       :phoenix_html_simplified_helpers,
       :scrivener_html,
       :floki,
       :mailgun,
       :mogrify,
       :redix,
       :scrivener_ecto,
       :jsx,
       # :ex_sitemap_generator
     ]
   ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
     {:phoenix, "~> 1.1"},
     {:phoenix_ecto, "~> 2.0"},
     {:phoenix_html, "~> 2.5.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.10"},
     {:cowboy, "~> 1.0"},
     {:httpoison, "~> 0.8"},
     {:mongodb_ecto, "~> 0.1"},
     {:bing_translator, "~> 0.2"},
     {:exfavicon, "~> 0.3"},
     {:arc, "~> 0.2"},
     {:arc_ecto, "~> 0.3"},
     {:ex_aws, "~> 0.4"},
     {:httpoison, "~> 0.8"},
     # {:tirexs, "~> 0.7"},
     {:timex, "~> 2.1", override: true},  # {:tirexs, github: "Zatvobor/tirexs"},
     {:timex_ecto, "~> 1.0"},
     {:calendar, "~> 0.12"},
     {:exromaji, "~> 0.3"},
     {:exkanji, "~> 0.2"},
     {:yaml_elixir, "~> 1.0"},
     {:yamerl, github: "yakaz/yamerl"},
     {:con_cache, "~> 0.10"},
     # {:ex_admin, github: "smpallen99/ex_admin"},
     {:ua_inspector, "~> 0.10"},
     {:simple_format, "~> 0.1"},
     {:quantum, "~> 1.7"},
     {:exrm, "~> 1.0"},
     {:mailgun, "~> 0.1"},
     {:mogrify, "~> 0.2"},
     {:redisank, "~> 0.1"},

     {:sitemap, ">= 0.0.0"},
     {:phoenix_html_simplified_helpers, "~> 0.8"},
     {:html_entities, "~> 0.3"},

     # {:exsentry, "~> 0.7"},

     ### belows are resolving dependencies
     {:ecto, "~> 1.1", override: true},
     {:postgrex, "~> 0.11"},
     # {:postgrex, ">= 0.0.0"},
     # {:scrivener_esx, "~> 0.2"},
     # {:scrivener_html, "~> 1.1"},
     {:scrivener_esx, github: "ikeikeikeike/scrivener_esx", branch: "expand"},
     {:scrivener_html, github: "ikeikeikeike/scrivener_html"},
     #### until this line

     {:esx, "~> 0.2"},
     {:scrivener, "~> 2.0"},
     {:scrivener_ecto, "~> 1.0"},

     {:credo, "~> 0.5", only: [:dev, :test]},
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
