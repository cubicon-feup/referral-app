defmodule AppWeb.Mailer do
    use Mailgun.Client,
        domain: Application.get_env(:app_web, :mailgun_domain),
        key: Application.get_env(:app_web, :mailgun_key)
        #mode: :test, # Alternatively use Mix.env while in the test environment.
        #test_file_path: "/tmp/mailgun.json"

        @from "us@example.com"

        def send_welcome_text_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: "Welcome to HelloPhoenix!"
        end

        def send_welcome_html_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       html: "<strong>Welcome to HelloPhoenix</strong>"
        end

        def send_welcome_email(email_address) do
            send_email to: email_address,
                       from: @from,
                       subject: "Welcome!",
                       text: "Welcome to HelloPhoenix!",
                       html: "<strong>Welcome to HelloPhoenix</strong>"
        end
  end