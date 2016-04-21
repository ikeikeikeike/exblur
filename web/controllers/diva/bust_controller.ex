defmodule Exblur.Diva.BustController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  def index(conn, _params) do
    busts =
      [60, 70, 80, 90, 100, 110, 120, 130, 140]
      |> Enum.map(fn bust ->
        divas =
          Model
          |> where([q], q.bust >= ^bust)
          |> where([q], q.bust < ^(bust + 10))
          |> where([q], q.bust > 50)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.bust))
          |> order_by([q], [asc: q.bust])
          |> Exblur.Repo.all
        {bust, divas}
      end)

    render(conn, "index.html", busts: busts)
  end

end
