defmodule Exblur.Diva.AgeController do
  use Exblur.Web, :controller

  alias Exblur.Repo
  alias Exblur.Diva, as: Model
  import Ecto.Query
  require Tirexs.Query

  def index(conn, _params) do
    render(conn, "index.html", ages: ages)
  end

  def age(conn, %{"age" => age}) do
    {one, _} = Float.parse age

    divas =
      Repo.execute_and_load """
      SELECT * FROM divas WHERE
        EXTRACT(YEAR from AGE(birthday)) = $1
          AND appeared > 0
      """, [one], Model

    render(conn, "age.html", ages: ages, divas: divas)
  end

  defp ages do
    r =
      Ecto.Adapters.SQL.query! Repo, """
      SELECT EXTRACT(YEAR from AGE(birthday)) as age
      FROM
        divas
      WHERE
        birthday IS NOT NULL
          AND
        appeared > 0
      GROUP BY
        age
      ORDER BY
        age
      """, []

    Enum.map(r.rows, fn row ->
      round(List.first(row))
    end)
    |> Enum.filter(& &1 < 200)
  end

end
