defmodule Entrybuilder.BuildDivas do
  use Exblur.Web, :build
  alias Exblur.Entry
  alias Exblur.Diva
  alias Exblur.EntryDiva
  alias Entrybuilder.Filter

  require Logger

  def run, do: run([])
  def run(_args) do

    divas =
      Diva
      |> Repo.all
      |> Enum.filter(fn(d) ->
        Filter.right_name?(d.name)
      end)

    Enum.each(divas, fn(diva) ->
      entries =
        Filter.separate_name(diva.name)
        |> Enum.reduce([], fn(name, total) ->
          entries =
            Entry.query
            |> where([e], like(e.title, ^"%#{name}%"))
            |> Repo.all

          total ++ entries
        end)

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
