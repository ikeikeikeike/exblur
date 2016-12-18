# https://github.com/chrismccord/mailgun/
defmodule Exblur.ReceptionMailer do
  @config domain: Application.get_env(:exblur, :mailer)[:mailgun_domain],
          key: Application.get_env(:exblur, :mailer)[:mailgun_key]
  use Mailgun.Client, @config

  @from Application.get_env(:exblur, :mailer)[:from]

  def send_removal_request(%{"email" => email, "subject" => subject, "body" => body}) do
    send_email to: Application.get_env(:exblur, :mailer)[:me],
               from: @from,
               subject: "From Mailgun as removal request: #{subject}",
               text: """
               email: #{email}
               subject: #{subject}
               body: #{body}
               """

    send_email to: email,
               from: @from,
               subject: "We've received your body.",
               text: """
               We've received your body below.

               ---
               subject: #{subject}
               body: #{body}

               ---
               Thanks.
               """
  end

  def send_contact(%{"email" => email, "subject" => subject, "body" => body}) do
    send_email to: Application.get_env(:exblur, :mailer)[:me],
               from: @from,
               subject: "From Mailgun as contact: #{subject}",
               text: """
               email: #{email}
               subject: #{subject}
               body: #{body}
               """

    send_email to: email,
               from: @from,
               subject: "We've received your message.",
               text: """
               We've received your message below.

               ---
               subject: #{subject}
               body: #{body}

               ---
               Thank you for your contact.
               """
  end

end

