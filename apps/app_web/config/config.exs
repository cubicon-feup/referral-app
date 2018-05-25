# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app_web,
  namespace: AppWeb,
  ecto_repos: [App.Repo]

# Configures the endpoint
config :app_web, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+zQWkb5v4Lgk1rPshsw5h+9N1YzkFo7E1dxwT2bKy8nhJsdCbzG1J09KwGuJ+gNx",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AppWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :app_web, :generators,
  context_app: :app

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
import_config "config_mailgun.exs"
