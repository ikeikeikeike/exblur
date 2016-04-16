defmodule Exblur.Diva.BirthdayController do
  use Exblur.Web, :controller

  alias Exblur.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def month(conn, %{"year" => year, "month" => month}) do
    render(conn, "month.html")
  end

  def year(conn, %{"year" => year}) do
    birthdays =
      Model
      |> select([p], p.birthday)
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> where([q], q.birthday <= ^"#{year}-12-31")
      |> where([q], q.birthday >= ^"#{year}-01-01")
      |> order_by([q], [asc: q.birthday])
      |> Exblur.Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.month
      end)

    render(conn, "year.html", birthdays: birthdays)
  end

  def index(conn, _params) do
    birthdays =
      Model
      |> group_by([p], p.birthday)
      |> select([p], p.birthday)
      |> where([q], q.appeared > 0)
      |> where([q], not is_nil(q.birthday))
      |> order_by([q], [desc: q.birthday])
      |> Exblur.Repo.all
      |> Enum.uniq_by(fn birthday ->
        if birthday, do: birthday.year
      end)

    render(conn, "index.html", birthdays: birthdays)
  end

end
