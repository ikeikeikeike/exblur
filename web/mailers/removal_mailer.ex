# https://github.com/chrismccord/mailgun/
defmodule Exblur.RemovalMailer do
  @config domain: Application.get_env(:exblur, :mailer)[:mailgun_domain],
          key: Application.get_env(:exblur, :mailer)[:mailgun_key]
  use Mailgun.Client, @config

  @from Application.get_env(:exblur, :mailer)[:from]

  def send_removal_request(email, subject, message) do
    send_email to: Application.get_env(:exblur, :mailer)[:me],
               from: @from,
               subject: "From Mailgun: #{subject}",
               text: message

    send_email to: email,
               from: @from,
               subject: "We've received your message.",
               text: """
               We've received your message below.

               ---
               #{subject}
               #{message}

               ---
               Thanks.
               """
  end

  # def send_welcome_html_email(email) do
    # send_email to: email,
               # from: @from,
               # subject: "hello!",
               # html: "<strong>Welcome!</strong>"
  # end
end

