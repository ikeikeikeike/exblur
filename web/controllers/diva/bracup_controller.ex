defmodule Exblur.Diva.BracupController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  plug Exblur.Ctrl.Plug.AssignTag
  plug Exblur.Ctrl.Plug.AssignDiva

  def index(conn, _params) do
    bracups =
      Enum.map(?A..?Z, &IO.iodata_to_binary([&1]))
      |> Enum.map(fn bracup ->
        divas =
          Model
          |> where([q], q.bracup == ^bracup)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.bracup))
          |> order_by([q], [asc: q.bust])
          |> Exblur.Repo.all
        {bracup, divas}
      end)

    render(conn, "index.html", bracups: bracups)
  end

end
