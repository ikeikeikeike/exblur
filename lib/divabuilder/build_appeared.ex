defmodule Divabuilder.BuildAppeared do
  use Exblur.Web, :build

  alias Exblur.Diva

  require Logger

  def run, do: run([])
  def run(_args) do

    tirexs =
      Exblur.Entry.diva_facets(10000)
      # |> Tirexs.Query.result

    models =
      tirexs[:facets][:divas][:terms]
      |> Enum.map(fn(term) ->
        Repo.transaction fn ->
          case Diva.find_or_create_by_name(term[:term]) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")

            {_, model} ->
              params = %{appeared: term[:count]}
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
