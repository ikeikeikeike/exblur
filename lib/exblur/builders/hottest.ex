defmodule Exblur.Builders.Hottest do
  import Exblur.Builders.Base
  import Exblur.Checks, only: [blank?: 1]
  import Ecto.Query, only: [from: 2]

  alias Exblur.{Repo, Entry}

  require Logger

  def run, do: run []
  def run([]) do
    ids = Redisank.top :weekly, 0, 50_000, []
    ids =
      if blank?(ids) do
        Redisank.sum :weekly
        Redisank.top :weekly, 0, 50_000, []
      else
        ids
      end

    ranking =
      from(q in Entry, where: q.id in ^ids)
      |> Entry.relates
      |> Repo.all

    sorted_entries =
      Enum.map(ids, fn id ->
        case Enum.filter(ranking, & id == &1.id) do
          [elm] -> elm
          _     -> nil
        end
      end)
      |> Enum.filter(& not is_nil &1)

    result =
      Enum.map Enum.with_index(sorted_entries, 1), fn {entry, index} ->
        :timer.sleep(300)

        changeset = Entry.changeset entry, %{sort: index}

        Repo.transaction fn ->
          case Repo.update(changeset) do
            {:ok, entry} ->
              entry
            {_, err} ->
              setback entry, err
          end
        end
      end

    Enum.map(result, fn
      {:error, entry} ->
        skip entry, "final"
      {_, entry} ->
        Entry.put_es_document entry
        nil
    end)
    |> Enum.filter(&is_nil/1)
    |> length
  end

end
