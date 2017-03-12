defmodule Exblur.Mixfile do
  use Mix.Project

  def project do
    [app: :exblur,
     version: version(),
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  defp version do
    v = "18.3.11"
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
       :ecto,
       :ex_aws,
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
       :common_device_detector,
       # :exsentry,

       :rdtype,
       :esx,
       :scrivener_esx,
       :tzdata,
       :sweet_xml,
     ],
     included_applications: [
       :arc,
       :timex_ecto,
       :scrivener,
       :simple_format,
       :bing_translator,
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

       :exsyslog,
       :syslog,
       :crontab,
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
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:ecto, "== 2.1.4", override: true},
      {:postgrex, "== 0.13.2"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},

      {:httpoison, "~> 0.11.1", override: true},
      {:poison, "~> 3.1", override: true},
      {:yamerl, "~> 0.4", override: true},
      {:hackney, "~> 1.6", override: true},

      {:arc, "~> 0.7", override: true},
      {:timex, "~> 3.0", override: true},

      {:timex_ecto, "~> 3.1"},
      {:arc_ecto, "~> 0.5"},
      {:sweet_xml, "~> 0.6"},
      {:ex_aws, "~> 1.1"},

      {:mongodb_ecto, github: "ikeikeikeike/mongodb_ecto", branch: "ecto-2"},

      {:bing_translator, "~> 0.5"},
      {:exfavicon, "~> 0.3"},

      {:calendar, "~> 0.12"},
      {:exromaji, "~> 0.3"},
      {:exkanji, "~> 0.2"},
      {:yaml_elixir, "~> 1.0"},
      {:con_cache, "~> 0.10"},

      {:common_device_detector, github: "ikeikeikeike/common_device_detector"},

      {:simple_format, "~> 0.1"},
      {:quantum, ">= 1.9.0"},

      {:rdtype, "~> 0.5"},

      {:exrm, "~> 1.0"},
      {:mailgun, "~> 0.1"},
      {:mogrify, "~> 0.2"},
      {:redisank, "~> 0.1"},

      {:tzdata, "~> 0.1.8 or ~> 0.5"},

      {:sitemap, ">= 0.0.0"},
      {:phoenix_html_simplified_helpers, "~> 1.1"},
      {:html_entities, "~> 0.3"},

      # {:exsentry, "~> 0.7"},

      ### belows are resolving dependencies
      # {:scrivener_esx, "~> 0.2"},
      # {:scrivener_html, "~> 1.1"},
      {:scrivener_esx, github: "ikeikeikeike/scrivener_esx", branch: "expand"},
      {:scrivener_html, github: "ikeikeikeike/scrivener_html"},
      #### until this line

      {:esx, "~> 0.2"},
      {:scrivener, "~> 2.0"},
      {:scrivener_ecto, "== 1.1.1"},

      # Throw syslog
      {:exsyslog, "~> 1.0"},
      # {:sentry, "~> 2.2"},

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
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]

  end
end
