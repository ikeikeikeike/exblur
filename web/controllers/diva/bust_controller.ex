defmodule Exblur.Diva.BustController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    busts =
      [60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135]
      |> Enum.map(fn bust ->
        divas =
          Model
          |> where([q], q.bust >= ^bust)
          |> where([q], q.bust < ^(bust + 5))
          |> where([q], q.bust > 60)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.bust))
          |> order_by([q], [asc: q.bust])
          |> Exblur.Repo.all
        {bust, divas}
      end)

    render(conn, "index.html", busts: busts)
  end

end
