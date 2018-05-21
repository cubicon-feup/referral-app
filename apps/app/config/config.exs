use Mix.Config

config :app, ecto_repos: [App.Repo]

config :app, App.Scheduler, jobs: []

import_config "#{Mix.env()}.exs"
