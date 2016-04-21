defmodule Exblur.Diva.AtozController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def index(conn, _params) do
    letters =
      Divabuilder.Api.kunrei_romaji
      |> Enum.map(fn letter ->
        divas =
          Model
          |> where([q], q.gyou == ^letter)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.gyou))
          |> Exblur.Repo.all
        {letter, divas}
      end)

    render(conn, "index.html", letters: letters)
  end

end
