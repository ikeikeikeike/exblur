defmodule Exblur.Builders.Removal do
  import Exblur.Builders.Base
  import Exblur.Checks, only: [blank?: 1]
  import Ecto.Query, only: [from: 2]

  alias Exblur.{Repo, Entry}

  require Logger

  def run, do: run []
  def run([]) do
    entries =
      from q in Entry,
      where: q.removal == true
         and not is_nil(q.published_at)

    Enum.map(Repo.all(entries), fn entry ->
      entry
      |> Entry.changeset(%{"published_at" => nil})
      |> Repo.update!
    end)
    |> Enum.each(fn entry ->
      :timer.sleep(300)
      Entry.delete_es_document entry
    end)
  end

end
