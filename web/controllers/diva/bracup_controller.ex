defmodule Exblur.Diva.BracupController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  def index(conn, _params) do
    bracups =
      Model
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.bracup))
      |> order_by([q], [desc: q.bracup])
      |> Exblur.Repo.all

    render(conn, "index.html", bracups: bracups)
  end

end
