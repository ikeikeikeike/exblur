use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :exblur, Exblur.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :exblur, Exblur.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger,
  # :console,
  # format: "[$level] $message\n"

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
  adapter: Mongo.Ecto,
  database: "video",
  # username: "mongodb",
  # password: "mongosb",
  hostname: "localhost",
  pool_size: 5

config :bing_translator,
   client_id: "",
   client_secret: "",
   skip_ssl_verify: false

config :arc,
  # :version_timeout, 15_000 # milliseconds
  # bucket: "uploads"
  # virtual_host: true  # for aws
  asset_host: "https://d3gav2egqolk5.cloudfront.net"

# config :ex_aws,
  # access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  # secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

config :scrivener_html,
  routes_helper: Exblur.Router.Helpers
