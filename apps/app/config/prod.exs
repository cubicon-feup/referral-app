use Mix.Config

if System.get_env("DATA_DB_USER") do
    config :app, App.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: System.get_env("DATA_DB_USER"),
    password: System.get_env("DATA_DB_PASS"),
    hostname: System.get_env("DATA_DB_HOST"),
    database: "gonano",
    pool_size: 10
else
    #import_config "prod.secret.exs"
end


