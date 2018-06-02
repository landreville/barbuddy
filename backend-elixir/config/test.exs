use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :barbuddy, BarBuddyWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :barbuddy, BarBuddy.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "peacock",
  hostname: "172.17.0.2",
  pool: Ecto.Adapters.SQL.Sandbox
