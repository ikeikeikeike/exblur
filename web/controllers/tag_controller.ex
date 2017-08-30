defmodule Exblur.TagController do
  use Exblur.Web, :controller

  alias Exblur.Tag

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    render(conn, "index.html", tags: conn.assigns.top_tags)
  end

  def autocomplete(conn, %{"search" => search}) do
    tags =
      ConCache.get_or_store :exblur_cache, "tags_autocomplete:#{search}", fn ->
        word =
          String.split(search, ".")
          |> List.first

        Tag
        |> Exblur.ESx.search(Tag.essuggest(word))
        |> Exblur.ESx.records
        |> Enum.map(&Map.take &1, [
          :id, :name, :kana, :romaji
        ])
        |> Enum.uniq
      end

    render(conn, "autocomplete.json", tags: tags)
  end

end
