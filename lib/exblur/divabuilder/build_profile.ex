defmodule Exblur.Divabuilder.BuildProfile do
  use Exblur.Web, :build
  alias Exblur.Diva
  alias Exblur.Divabuilder.Client
  require Logger

  def run, do: run([])
  def run(_args) do
    endpoint = Application.get_env(:exblur, :diva)[:profile]
    bauth = [basic_auth: Application.get_env(:exblur, :diva)[:basic_auth]]

    {:ok, response} =
      case Client.get(endpoint, [], [hackney: bauth]) do
        {:ok, response} -> Poison.decode(response.body)
        {:error, reason} -> Logger.error("#{inspect reason}")
      end

    models =
      Enum.map(response, fn(profile) ->
        Repo.transaction fn ->
          case Diva.find_or_create_by_name(profile["Name"]) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")

            {_, model} ->
              case Repo.update(Diva.changeset_profile(model, profile)) do
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

    Logger.info "Finish to build diva's profile #{length models}"
  end
end
