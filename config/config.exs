# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :exblur, Exblur.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "ezQ86ORqGpUkX7Omn+vK19bu6vXe3ckRU0iLSOCwe2mB5B/nsHSRWu4GkzLrYrg2",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Exblur.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
# config :logger, :console,
  # format: "$time $metadata[$level] $message\n",
  # metadata: [:request_id]

config :logger, :console,
  format: "$date $time $metadata[$level]$levelpad$message\n",
  metadata: [:user_id, :request_id, :application, :module, :file, :line]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :tirexs,
   uri: URI.parse("http://127.0.0.1:9200")

config :scrivener_html,
  routes_helper: Exblur.Router.Helpers

config :ua_inspector,
  database_path: Path.join(File.cwd!, "config/ua_inspector")

config :exblur, Exblur.Gettext,
  default_locale: "ja",
  locales: ~w(en es ja)

# config :phoenix, Exblur.Router,
  # session: [store: :cookie,
            # key: "_exblur_key"]

# filters
import_config "translate_filters.exs"

# consts
import_config "consts.exs"
