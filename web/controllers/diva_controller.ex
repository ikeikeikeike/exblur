defmodule Exblur.DivaController do
  use Exblur.Web, :controller

  # import DeviceDetector
  alias Exblur.Diva, as: Model

  import Ecto.Query
  require Tirexs.Query

  def index(conn, _params) do
    params = [page: 1, page_size: 1, repo: Exblur.Repo, query: Model.query]
    entries =
      Exblur.Entry.search(nil, params)
      |> Tirexs.Query.result

    render(conn, "ranking.html", divas: entries)

    # where = %{divas: {not: nil}}
    # ignore some sites
    # if mobile?(conn) do
      # where = where.merge site_name: {not: Site::JAPAN_WHORES}
    # end


    # @divas = VideoEntry.search(
      # '*',
      # {
        # where: where,
        # facets: {divas: {where: where, limit: 100}},
        # limit: 1,
      # }
    # )
  end

  def autocomplete(conn, %{"search" => search}) do
    divas =
      ConCache.get_or_store :exblur_cache, "divas_autocomplete:#{search}", fn ->
        search
        |> String.split(".")
        |> List.first
        |> Model.search
        |> Tirexs.Query.result
        |> as_model
      end

    render(conn, "autocomplete.json", divas: divas)
  end

  defp as_model(tirexs) do
    Enum.map tirexs[:hits], fn(hit) ->
      Model
      |> where([q], q.id == ^hit[:_id])
      |> Exblur.Repo.one
    end
  end

end
