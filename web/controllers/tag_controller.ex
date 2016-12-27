defmodule Exblur.TagController do
  use Exblur.Web, :controller

  alias Exblur.{Entry, Tag}

  def autocomplete(conn, %{"search" => search}) do
    tags =
      ConCache.get_or_store :exblur_cache, "tags_autocomplete:#{search}", fn ->
        word =
          String.split(search, ".")
          |> List.first

        Tag
        |> Exblur.ESx.search(Tag.essuggest(word))
        |> Exblur.ESx.records
      end

    render(conn, "autocomplete.json", tags: tags)
  end

  def index(conn, _params) do
    tags =
      Entry.tag_facets
      |> Extoon.ESx.results

    render(conn, "index.html", tags: tags)
  end

end
