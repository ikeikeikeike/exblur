use Mix.Config

# For production, we configure the host to read the PORT
# from the system environment. Therefore, you will need
# to set PORT=80 before running your server.
#
# You should also configure the url host to something
# meaningful, we use this information when generating URLs.
#
# Finally, we also include the path to a manifest
# containing the digested version of static files. This
# manifest is generated by the mix phoenix.digest task
# which you typically run after static files are built.
myhost = String.replace(File.read!("config/myhost"), "\n", "")

config :exblur, Exblur.Endpoint,
  http: [port: 5700],
  url: [host: myhost, port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  server: true

config :logger,
  level: :warn,
  backends: [
    {ExSyslog, :exsyslog_error},
    {ExSyslog, :exsyslog_debug},
    {ExSyslog, :exsyslog_json}
  ]

# config :logger, level: :warn,
  # format: "$date $time $metadata[$level]$levelpad$message\n",
  # metadata: [:user_id, :request_id, :application, :module, :file, :line]

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :exblur, Exblur.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :exblur, Exblur.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :exblur, Exblur.Endpoint, server: true
#

config :quantum, :exblur,
  cron: [
    sitemaps_gen_sitemap: [
      schedule: "20 22 */3 * *",
      task: "Exblur.Sitemaps.gen_sitemap",
      args: []
    ],
    build_diva: [
      schedule: "47 3 3 * *",
      task: "Exblur.Divabuilder.Build.run",
      args: []
    ],
    build_image_brushup: [
      schedule: "7 21 * * *",
      task: "Exblur.Divabuilder.BuildImage.run",
      args: [:brushup]
    ],
    build_image_fillup: [
      schedule: "32 22 * * *",
      task: "Exblur.Divabuilder.BuildImage.run",
      args: [:fillup]
    ],
    build_image_all: [
      schedule: "53 23 * * *",
      task: "Exblur.Divabuilder.BuildImage.run",
      args: [:all]
    ],
    build_appeared: [
      schedule: "35 */3 * * *",
      task: "Exblur.Divabuilder.BuildAppeared.run",
      args: []
    ],
    build_divas: [
      schedule: "50 5 * * *",
      task: "Exblur.Entrybuilder.BuildDivas.run",
      args: []
    ],
    build_scrapy: [
      schedule: "*/20 * * * *",
      task: "Exblur.Entrybuilder.Build.run",
      args: []
    ],
    publish_entry: [
      schedule: "15 * * * *",
      task: "Exblur.Entrybuilder.Publish.run",
      args: []
    ],
    ranking_run: [
      schedule: "50,59 * * * *",
      task: "Exblur.Builders.Ranking.run",
      args: []
    ],
    hottest_run: [
      schedule: "55 1 * * *",
      task: "Exblur.Builders.Hottest.run",
      args: []
    ],
    like_run: [
      schedule: "22 18 * * *",
      task: "Exblur.Builders.Like.run",
      args: []
    ],
    removal_run: [
      schedule: "* * * * *",  # XXX: Until impliment es code in python.
      task: "Exblur.Builders.Removal.run",
      args: []
    ],
    builders_touch_run: [
      schedule: "* * * * *",
      task: "Exblur.Builders.Touch.run",
      args: []
    ],
    builders_notify_summarize: [
      schedule: "35 20 * * *",  # UTC: 20:35
      task: "Exblur.Builders.Notify.summarize",
      args: []
    ]
  ]

config :esx, ESx.Model,
  repo: Exblur.Repo,
  protocol: "http",
  host: "127.0.0.1",
  port: 9200,
  trace: false

config :sitemap, [
  host: "http://#{myhost}",
  public_path: "",
  files_path: "static/",
]

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
