defmodule Exblur.ReceptionController do
  use Exblur.Web, :controller

  # plug :scrub_params, "reception" when action in [:removal]

  def removal(conn, %{"reception" => params}) do
    case Exblur.ReceptionMailer.send_removal_request(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Accepted your message.")
        |> redirect(to: reception_path(conn, :removal))
      _ ->
        conn
        |> put_flash(:error, "Could not send your message.")
        |> render("removal.html")
    end
  end

  def removal(conn, _params) do
    render conn, "removal.html"
  end

  def contact(conn, %{"contact" => params}) do
    case Exblur.ReceptionMailer.send_contact(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Accepted your message.")
        |> redirect(to: reception_path(conn, :contact))
      _ ->
        conn
        |> put_flash(:error, "Could not send your message.")
        |> render("contact.html")
    end
  end

  def contact(conn, _params) do
    render conn, "contact.html"
  end

end
