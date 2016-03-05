defmodule Exblur.DivaController do
  use Exblur.Web, :controller

  require Tirexs.Query
  # import DeviceDetector

  alias Exblur.Diva, as: Model

  def index(conn, _params) do
    params = [page: 1, page_size: 1, repo: Exblur.Repo, query: Model.query]
    entries =
      Es.Entry.search(nil, params)
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

end
