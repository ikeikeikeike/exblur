defmodule Entrybuilder.BuildDivas do
  use Exblur.Web, :build
  alias Exblur.Entry
  alias Exblur.Diva
  alias Exblur.EntryDiva

  require Logger

  def run, do: run([])
  def run(_args) do
    reHKA3 = ~r/^([ぁ-んー－]|[ァ-ヴー－]|[a-z]){3,4}$/iu

    divas =
      Diva
      |> Repo.all
      |> Enum.filter(fn(d) ->
        !Regex.match?(reHKA3, d.name) && String.length(d.name) > 2
      end)

    Enum.each(divas, fn(diva) ->
      entries =
        Entry.query
        |> where([e], like(e.title, ^"%#{diva.name}%"))
        |> Repo.all

      Enum.each(entries, fn(entry) ->
        case EntryDiva.find_or_create(entry, diva) do
          {:error, reason} ->
            Repo.rollback(reason)
            Logger.error("#{inspect reason}")

          {:ok, _model} -> nil

          {:new, _model} ->
            %{entry | divas: entry.divas ++ [diva]}
            |> Entry.put_document
        end
      end)
    end)

    Logger.info "Finish to build entry diva."
  end
end
