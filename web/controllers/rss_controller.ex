defmodule Exblur.RssController do
  use Exblur.Web, :controller
  alias Exblur.Entry

  def index(conn, _params) do
    entries =
      Entry.query
      |> Entry.published
      |> Entry.latest(50)
      |> Repo.all

    conn
    |> put_layout(:none)
    |> put_resp_content_type("application/xml")
    |> render("rdf.xml", entries: entries)
  end

end
