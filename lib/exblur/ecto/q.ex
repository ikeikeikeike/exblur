defmodule Exblur.Ecto.Q do
  import Ecto.Query, only: [from: 1, from: 2]

  alias Exblur.Blank
  alias Exblur.Repo
  alias Exblur.Diva

  def exists?(queryable) do
    query =
      Ecto.Query.from(x in queryable, limit: 1)
      |> Ecto.Queryable.to_query

    case Repo.all(query) do
      [] -> false
      _  -> true
    end
  end

  def fuzzy_find(mod, name) when is_nil(name), do: fuzzy_find(mod, [])
  def fuzzy_find(mod, name) when is_bitstring(name) do
    case String.split(name, ~r(、|（|）)) do
      names when length(names) == 1 ->
        if model = Repo.get_by(mod, name: List.first(names)) do
          model
        else
          fuzzy_find mod, names
        end

      names when length(names)  > 1 ->
        fuzzy_find mod, names

      _ -> nil
    end
  end
  def fuzzy_find(_mod, []), do: nil
  def fuzzy_find(mod, [name|tail]) do
    case Blank.blank?(name) do
      true  -> fuzzy_find(mod, tail)
      false ->
        query =
          from q in mod,
            where: ilike(q.name, ^"%#{name}%"),
            limit: 1

        fuzzy_find(mod, [], Repo.one(query))
    end
  end
  def fuzzy_find(_mod, [], model), do: model

  def nearly_search(:measurements, queryable, %Diva{} = model) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.bust  < ^(model.bust + 5)  and q.bust  > ^(model.bust - 5)
           and q.waste < ^(model.waste + 3) and q.waste > ^(model.waste - 3)
           and q.hip   < ^(model.hip + 5)   and q.hip   > ^(model.hip - 5),
        limit: 10

    queryable
    |> nearly_order([desc: :bust])
    |> Repo.all
  end
  def nearly_search(:bust, queryable, bust) when is_integer(bust) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.bust < ^(bust + 5)
           and q.bust > ^(bust - 5),
        limit: 10

    queryable
    |> nearly_order([desc: :bust])
    |> Repo.all
  end
  def nearly_search(:bracup, queryable, bracup) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.bracup == ^bracup,
        limit: 10

    queryable
    |> nearly_order([desc: :bracup])
    |> Repo.all
  end
  def nearly_search(:waist, queryable, waist) when is_integer(waist) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.waste < ^(waist + 2)
           and q.waste > ^(waist - 2),
        limit: 5

    queryable
    |> nearly_order([desc: :waste])
    |> Repo.all
  end
  def nearly_search(:hip, queryable, hip) when is_integer(hip) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.hip < ^(hip + 3)
           and q.hip > ^(hip - 3),
        limit: 5

    queryable
    |> nearly_order([desc: :hip])
    |> Repo.all
  end
  def nearly_search(:blood, queryable, blood) do
    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.blood == ^blood,
        limit: 5

    queryable
    |> nearly_order([desc: :blood])
    |> Repo.all
  end
  def nearly_search(:birthday, queryable, nil), do: []
  def nearly_search(:birthday, queryable, %Ecto.Date{} = birthday) do
    thismonth = Timex.to_datetime {{birthday.year, birthday.month, 01}, {0, 0, 0}}
    nextmonth = Timex.shift(thismonth, months: 1)

    queryable =
      from q in queryable,
        where: q.appeared > 0
           and q.birthday <  ^nextmonth
           and q.birthday >= ^thismonth,
        limit: 5

    queryable
    |> nearly_order([desc: :birthday])
    |> Repo.all
  end

  defp nearly_order(queryable, order_by) do
    case Enum.random [1, 2, 3] do
      1 ->
        from queryable, order_by: [desc: :appeared]
      2 ->
        from queryable, order_by: ^order_by
      3 ->
        queryable
    end
  end

end
