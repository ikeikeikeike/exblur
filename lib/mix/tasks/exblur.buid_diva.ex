defmodule Mix.Tasks.Exblur.BuildDiva do
  use Exblur.Web, :task
  alias Exblur.Diva

  require Logger

  @shortdoc "Builds diva table from apiactress.appspot.com"

  @moduledoc """
  nothing
  """
  def run(_args) do
    setup

    {:ok, divas} = Divabuilder.getdata

    models = 
      Enum.map divas, fn(diva) ->
        Repo.transaction fn ->
          case Diva.diva_creater(diva) do
            {:error, reason} ->
              Repo.rollback(reason); Logger.error("#{inspect reason}") 

              nil
            {_ok, model} ->
              Diva.already_post(diva) 

              model
          end
        end
      end
      |> Enum.filter(&(&1 != nil)) 
        
    # Put built up document to Elasticsearch
    models
    |> Es.Diva.put_document

  end

  def setup do
    Repo.start_link
    HTTPoison.start
  end

  # We can define other functions as needed here.
end
