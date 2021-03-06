defmodule Exblur.Diva.HeightController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    heights =
      [130, 135, 140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190]
      |> Enum.map(fn height ->
        divas =
          Model
          |> where([q], q.height >= ^height)
          |> where([q], q.height < ^(height + 5))
          |> where([q], q.height > 130)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.height))
          |> order_by([q], [asc: q.height])
          |> Exblur.Repo.all
        {height, divas}
      end)

    render(conn, "index.html", heights: heights)
  end

end
