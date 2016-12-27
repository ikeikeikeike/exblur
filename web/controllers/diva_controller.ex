defmodule Exblur.DivaController do
  use Exblur.Web, :controller

  alias Exblur.{Diva, Repo}

  def index(conn, _params) do
    divas =
      from q in Diva,
        where: q.appeared > 0,
        order_by: [desc: q.appeared]

    render(conn, "index.html", divas: Repo.all(divas))
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
