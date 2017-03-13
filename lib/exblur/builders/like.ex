defmodule Exblur.Builders.Like do
  import Exblur.Builders.Base
  import Ecto.Query

  alias Exblur.{Repo, Entry, Redis.Like}

  require Logger

  def run, do: run []
  def run([]) do
    Like.ids
    |> Stream.map(&increment/1)
    |> Stream.filter(& !!&1)
    |> Stream.each(&putdoc/1)
    |> Stream.run
  end

  defp increment(key) do
    id = numlize key

    if id do
      from(q in Entry, where: q.id == ^id)
      |> Repo.update_all(inc: [likes: Like.length(key)])
    end

    Like.del key

    id
  end

  defp putdoc(id) do
    Entry.put_es_document Repo.get!(Entry, id)
    :timer.sleep(300)
  end

  defp numlize(key) do
    result =
      key
      |> String.split(":")
      |> List.last
      |> Integer.parse

    case result do
      :error -> nil
      {n, _} -> n
    end
  end

end
