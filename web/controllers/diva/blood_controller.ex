defmodule Exblur.Diva.BloodController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query

  def index(conn, _params) do
    bloods =
      ["A", "B", "O", "AB"]
      |> Enum.map(fn blood ->
        divas =
          Model
          |> where([q], q.blood == ^blood)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.blood))
          |> Exblur.Repo.all
        {blood, divas}
      end)

    render(conn, "index.html", bloods: bloods)
  end

end
