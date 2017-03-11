defmodule Exblur.Builders.Removal do
  import Exblur.Builders.Base
  import Exblur.Checks, only: [blank?: 1]
  import Ecto.Query, only: [from: 2]

  alias Exblur.{Repo, Entry}

  require Logger

  def run, do: run []
  def run([]) do
    entries =
      from(q in Entry, where: q.removal == true)
      |> Repo.all

    Enum.map entries, fn entry ->
      :timer.sleep(300)
      Entry.put_es_document entry
    end
  end

end
