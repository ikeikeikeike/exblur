defmodule Exblur.DivaController do
  use Exblur.Web, :controller

  alias Exblur.{Diva, Repo}

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    render conn, "index.html", divas: conn.assigns.top_divas
  end

  def autocomplete(conn, %{"search" => search}) do
    divas =
      ConCache.get_or_store :exblur_cache, "divas_autocomplete:#{search}", fn ->
        word =
          String.split(search, ".")
          |> List.first

        Diva
        |> Exblur.ESx.search(Diva.essuggest(word))
        |> Exblur.ESx.records
      end

    render(conn, "autocomplete.json", divas: divas)
  end

end
