defmodule Mix.Tasks.Exblur.BuildDiva do
  use Exblur.Web, :task
  alias Exblur.Diva

  require Logger

  @shortdoc "Builds diva table from apiactress.appspot.com"

  @moduledoc """
  nothing
  """
  def run(args) do
    setup
    
    responses = if length(args) > 0, do: Divabuilder.getdata(args), else: Divabuilder.getdata

    models = 
      responses
      |> Enum.map(fn(response) ->
        case response do
          {:ok, data} ->
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
      |> Enum.filter(&(&1 != nil)) 
        
    # Put built up document to Elasticsearch
    if length(models) > 0, do: Es.Diva.put_document(models)

  end

  def setup do
    Repo.start_link
    HTTPoison.start
  end

  # We can define other functions as needed here.
end
