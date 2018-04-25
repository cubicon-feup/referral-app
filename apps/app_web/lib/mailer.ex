defmodule AppWeb.Mailer do
    use Mailgun.Client,
        domain: Application.get_env(:app_web, :mailgun_domain),
        key: Application.get_env(:app_web, :mailgun_key)

        @from "welcome@inspiro.com"

        def send_welcome_text_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: "Welcome to Inspiro!"
        end

        def send_welcome_html_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       html: "<strong>Welcome to Inspiro</strong>"
        end

        def send_welcome_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: "Welcome to Inspiro!",
                       html: "<strong>Welcome to Inspiro</strong>"
        end
  end