defmodule Exblur.Diva.WasteController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    wastes =
      [40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100]
      |> Enum.map(fn waste ->
        divas =
          Model
          |> where([q], q.waste >= ^waste)
          |> where([q], q.waste < ^(waste + 5))
          |> where([q], q.waste > 40)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.waste))
          |> order_by([q], [asc: q.waste])
          |> Exblur.Repo.all
        {waste, divas}
      end)

    render(conn, "index.html", wastes: wastes)
  end

end
