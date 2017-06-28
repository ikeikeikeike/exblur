defmodule Exblur.ReceptionController do
  use Exblur.Web, :controller

  # plug :scrub_params, "reception" when action in [:removal]
  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def removal(conn, %{"reception" => params, "g-recaptcha-response" => recaptcha}) do
    with {:ok, %{challenge_ts: _isotime}} <- Recaptcha.verify(recaptcha),
         {:ok, _} <- Exblur.ReceptionMailer.send_removal_request(params) do
      conn
      |> put_flash(:info, "Accepted your message.")
      |> redirect(to: reception_path(conn, :removal, h: randstr(5)))
    else _error ->
      conn
      |> put_flash(:error, "Could not send your message.")
      |> redirect(to: reception_path(conn, :removal, h: randstr(5)))
    end
  end

  def removal(conn, _params) do
    render conn, "removal.html"
  end

  def contact(conn, %{"contact" => params, "g-recaptcha-response" => recaptcha}) do
    with {:ok, %{challenge_ts: _isotime}} <- Recaptcha.verify(recaptcha),
         {:ok, _} <- Exblur.ReceptionMailer.send_contact(params) do
      conn
      |> put_flash(:info, "Accepted your message.")
      |> redirect(to: reception_path(conn, :contact, h: randstr(5)))
    else _error ->
      conn
      |> put_flash(:error, "Could not send your message.")
      |> redirect(to: reception_path(conn, :contact, h: randstr(5)))
    end
  end

  def contact(conn, _params) do
    render conn, "contact.html"
  end

end
