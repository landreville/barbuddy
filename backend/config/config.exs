# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :barchef,
  ecto_repos: [Barchef.Repo]

# Configures the endpoint
config :barchef, BarchefWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "e5qSM6OlmMtI3GkIsAQld+DMVRT6BXzuHiEIzjIbRBXckJU25NXiIFxM1OwinseO",
  render_errors: [view: BarchefWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Barchef.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders, json: Poison
config :ecto, :json_library, Poison
#config :poison, keys: :atoms!

config :barchef, Barchef.Auth.Guardian,
       issuer: "barchef",
       secret_key: "a1403929JA8ZTa7b610QC+Bh444ga9eCPjL4lqhfLGvNKoR/BS5kDWOCgTitubqL"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

