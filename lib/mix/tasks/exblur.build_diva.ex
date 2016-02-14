defmodule Mix.Tasks.Exblur.BuildDiva do
  use Exblur.Web, :task
  alias Exblur.Diva

  require Logger

  @shortdoc "Builds diva table using apiactress.appspot.com data."

  @moduledoc """
  nothing
  """
  def run(args) do
    setup

    responses = if length(args) > 0, do: Divabuilder.getdata(args), else: Divabuilder.getdata

    models =
      responses
      |> Enum.flat_map(fn(response) ->
        case (for {_key, val} <- response, into: %{}, do: val) do
          %{ok: data} ->
            data["Actresses"]
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
          {:ok, %Exblur.Diva{}} ->
            true
          _ ->
            false
        end
      end)
      |> Enum.map(&elem(&1, 1))

    # Put built up document to Elasticsearch
    if length(models) > 0 do
      Es.Diva.reindex
      Logger.debug("finish reindex")
    end

    Mix.shell.info "Finish to build diva"
  end

  def setup do
    ConCache.start_link([], name: :exblur_cache)
    Repo.start_link
    HTTPoison.start
  end

  # We can define other functions as needed here.
end
