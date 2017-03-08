defmodule Exblur.Divabuilder.Build do
  use Exblur.Web, :build

  alias Exblur.Diva

  require Logger

  def run, do: run([])
  def run(args) do
    responses = if length(args) > 0, do: Exblur.Divabuilder.getdata(args), else: Exblur.Divabuilder.getdata

    # models =
      responses
      |> Enum.flat_map(fn(response) ->
        case (for {_key, val} <- response, into: %{}, do: val) do
          %{ok: data} -> data["Actresses"]
        end
      end)
      |> Enum.map(fn(actress) ->
        Repo.transaction fn ->
          case Diva.diva_creater(actress) do
            {:error, reason} ->
              Repo.rollback(reason); Logger.error("#{inspect reason}")
              nil

            {:ok, _model} ->
              nil

            {:new, model} ->
              model
          end
        end
      end)
      |> Enum.filter(fn(result) ->
        case result do
          {:ok, %Diva{} = model} ->
            Diva.put_es_document model
            true
          _ ->
            false
        end
      end)
      |> Enum.map(&elem(&1, 1))

    # Put built up document to Elasticsearch
    # if length(models) > 0 do
      # Exblur.Diva.reindex
      # Logger.debug("finish reindex")
    # end

    Logger.info "Finish to build diva"
  end
end
