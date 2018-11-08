use Mix.Config

# Configures the endpoint
config :hc, HcWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7nQMIorrnx1492E00ZbviIAZANwvzLHqHg8YEk+5ISAX96F9ezHAWrfEqBRhAdeb",
  render_errors: [view: HcWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Hc.PubSub, adapter: Phoenix.PubSub.PG2]

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :hc, HcWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      "--colors",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

# Watch static and templates for browser reloading.
config :hc, HcWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|vue)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/hc_web/views/.*(ex)$},
      ~r{lib/hc_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
# config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure MySensors Repo
config :my_sensors, MySensors.Repo,
  adapter: Sqlite.Ecto2,
  database: "my_sensnors_#{Mix.env()}.sqlite",
  loggers: []
