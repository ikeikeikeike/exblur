use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :exblur, Exblur.Endpoint,
  http: [port: 4000],
  url: [host: "127.0.0.1", port: 80],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  # cache_static_lookup: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]

# Watch static and templates for browser reloading.
config :exblur, Exblur.Endpoint,
  live_reload: [
    patterns: [
      # ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/models/.*(ex)$},
      ~r{web/controllers/.*(ex)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger,
  # :console,
  # format: "[$level] $message\n"

config :logger,
  level: :debug,
  backends: [
    :console,
    {ExSyslog, :exsyslog_error},
    {ExSyslog, :exsyslog_debug},
    {ExSyslog, :exsyslog_json}
  ]

# config :logger, level: :warn
config :logger, :console,
  format: "$date $time $metadata[$level]$levelpad$message\n",
  metadata: [:user_id, :request_id, :application, :module, :file, :line]

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :exblur, Exblur.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "exblur_dev",
  hostname: "localhost",
  pool_size: 20

config :exblur, Exblur.Mongo,
  database: "video",
  # username: "mongodb",
  # password: "mongosb",
  hostname: "localhost",
  pool_size: 5

config :esx, ESx.Model,
  repo: Exblur.Repo,
  protocol: "http",
  host: "127.0.0.1",
  port: 9200,
  trace: true

config :sitemap, [
  host: "http://127.0.0.1",
  public_path: "",
  files_path: "log/",
]

config :quantum, :exblur,
  cron: [
    "* * * * *":   fn -> System.cmd("touch", ["/tmp/tmp_"]) end,
    build_appeared: [
      schedule: "43 * * * *",
      task: "Exblur.Divabuilder.BuildAppeared.run",
      args: []
    ]
  ]

config :redisank, :redis,
  ranking: "redis://127.0.0.1:6379/14"

config :exblur, :redis,
  broken: "redis://127.0.0.1:6379/13",
  like: "redis://127.0.0.1:6379/12"

import_config "dev.secret.exs"

