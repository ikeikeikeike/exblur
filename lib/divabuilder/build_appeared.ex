defmodule Divabuilder.BuildAppeared do
  use Exblur.Web, :build

  alias Exblur.{Entry, Diva}

  require Logger

  def run, do: run([])
  def run(_args) do

    divas =
      Entry
      |> Exblur.ESx.search(Entry.diva_facets(10000))
      |> Exblur.ESx.results

    models =
      divas.aggregations["divas"]["buckets"]
      |> Enum.map(fn term ->
        Repo.transaction fn ->
          case Diva.find_or_create_by_name(term["key"]) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")

            {_, model} ->
              params = %{appeared: term["doc_count"]}
              case Repo.update(Diva.changeset(model, params)) do
                {:error, reason} ->
                  Repo.rollback(reason)
                  Logger.error("#{inspect reason}")

                {_, model} -> model
              end
          end
        end
      end)
      |> Enum.filter(fn(result) ->
        case result do
          {:ok, %Diva{}} ->
            true
          _ ->
            false
        end
      end)

    Logger.info "Finish to build diva's appeared #{length models}"
  end
end
