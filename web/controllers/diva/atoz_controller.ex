defmodule Exblur.Diva.AtozController do
  use Exblur.Web, :controller

  import Ecto.Query

  alias Exblur.Diva

  def index(conn, _params) do
    letters =
      Divabuilder.Api.kunrei_romaji
      |> Enum.map(fn letter ->
        divas =
          Diva
          |> where([q], q.gyou == ^letter)
          |> where([q], q.appeared > 0)
          |> where([q], not is_nil(q.gyou))
          |> Exblur.Repo.all
        {letter, divas}
      end)

    render(conn, "index.html", letters: letters)
  end

end
