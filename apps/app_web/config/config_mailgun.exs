use Mix.Config

if System.get_env("MAILGUN_DOMAIN") do
    if System.get_env("MAILGUN_DOMAIN") != "" do
        config :app_web,
            mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
            mailgun_key: System.get_env("MAILGUN_KEY")
    else
        import_config "mailgun.secret.exs"
    end
end

       