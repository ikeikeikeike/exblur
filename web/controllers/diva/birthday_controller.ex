defmodule Exblur.Diva.BirthdayController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def index(conn, _params) do
    birthdays =
      Exblur.Entry.diva_facets
      |> Tirexs.Query.result
      |> as_date

    render(conn, "index.html", birthdays: birthdays)
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end

  defp as_date(tirexs) do
    names =
      Enum.map(tirexs[:facets][:divas][:terms], fn term ->
        term[:term]
      end)

    Model
    |> group_by([p], p.birthday)
    |> select([p], p.birthday)
    |> where([q], q.name in ^names)
    |> order_by([q], [desc: q.birthday])
    |> Exblur.Repo.all
    |> Enum.uniq_by(fn birthday ->
      if birthday, do: birthday.year
    end)
  end

end
