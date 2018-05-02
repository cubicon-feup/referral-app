use Mix.Config

config :app_web,
       mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
       mailgun_key: System.get_env("MAILGUN_KEY")
       