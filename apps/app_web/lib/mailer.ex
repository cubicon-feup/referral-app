defmodule AppWeb.Mailer do
    use Mailgun.Client,
        domain: Application.get_env(:app_web, :mailgun_domain),
        key: Application.get_env(:app_web, :mailgun_key)

        @from "welcome@inspiro.com"

        def send_welcome_text_email(email_address, name) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: welcome_text(name)
        end

        def send_welcome_html_email(email_address, name) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       html: welcome_html(name, email_address)
        end

        def send_welcome_email(email_address, name) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: welcome_text(name),
                       html: welcome_html(name, email_address)
        end

        defp welcome_html(name, email) do
            Phoenix.View.render_to_string(AppWeb.EmailView, "welcome.html", name: name, email: email)
        end

        defp welcome_text(name) do
            "Welcome to Inspiro " <> name <> "\nAccess this link to find more\nhttp://phoenix.local:4000"
        end
  end