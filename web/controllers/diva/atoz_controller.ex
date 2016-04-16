defmodule Exblur.Diva.AtozController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def index(conn, _params) do
    divas =
      Exblur.Entry.diva_facets
      |> Tirexs.Query.result
      |> as_model

    render(conn, "index.html", divas: divas)
  end

  defp as_model(tirexs) do
    names =
      Enum.map(tirexs[:facets][:divas][:terms], fn term ->
        term[:term]
      end)

    Model.query
    |> where([q], q.name in ^names)
    |> order_by([q], [asc: q.kana])
    |> Exblur.Repo.all
  end

end
