defmodule Exblur.TagController do
  use Exblur.Web, :controller

  alias Exblur.Tag, as: Model

  import Ecto.Query
  require Tirexs.Query

  def autocomplete(conn, %{"search" => search}) do
    tags =
      ConCache.get_or_store :exblur_cache, "tags_autocomplete:#{search}", fn ->
        search
        |> String.split(".")
        |> List.first
        |> Es.Tag.search
        |> Tirexs.Query.result
        |> as_model
      end

    render(conn, "autocomplete.json", tags: tags)
  end

  defp as_model(tirexs) do
    Enum.map tirexs[:hits], fn(hit) ->
      Model
      |> where([q], q.id == ^hit[:_id])
      |> Exblur.Repo.one
    end
  end

end