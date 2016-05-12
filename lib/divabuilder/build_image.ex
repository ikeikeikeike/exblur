defmodule Divabuilder.BuildImage do
  use Exblur.Web, :build
  alias Exblur.Diva

  alias Divabuilder.Image.Bing
  alias Divabuilder.Image.Detector

  require Logger

  def run, do: run(:brushup)
  def run(:brushup) do
    Diva
    |> where([q], q.appeared > 0)
    |> order_by([q], [asc: q.updated_at])
    |> limit([q], 20)
    |> run
  end

  def run(:fillup) do
    Diva
    |> where([q], is_nil(q.image))
    |> order_by([q], [asc: q.updated_at])
    |> limit([q], 20)
    |> run
  end

  def run(:all) do
    Diva
    |> order_by([q], [asc: q.updated_at])
    |> limit([q], 20)
    |> run
  end

  def run(%Ecto.Query{} = divas) do
    divas =
      divas
      |> Repo.all
      |> failures

    models =
      Enum.map(divas, fn diva ->
        Repo.transaction fn ->
          case Diva.find_or_create_by_name(diva.name) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")

            {_, model} ->
              img = Bing.make_plug!(diva.name)
              case Repo.update(Diva.changeset(model, %{image: img})) do
                {:error, } ->
                  Diva.changeset(model, %{updated_at: Ecto.DateTime})
                  |> Repo.update

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

    Logger.info "Finish to build profile's image: #{length models} records."
  end

  defp failures([%Exblur.Diva{} | divas]) do
    Enum.map(divas, fn diva ->
      imageurl = if diva.image, do: Diva.get_thumb(diva), else: nil
      case Detector.urlinfo(imageurl) do
        {:ng, _} ->
          diva
        {:ok, info} ->
          cond do
            info.width  < 200 -> diva
            info.height < 400 -> diva
            true -> nil
          end
      end
    end)
    |> Enum.filter(fn(result) ->
      case result do
        %Exblur.Diva{} ->
          true
        _ ->
          false
      end
    end)
  end

end
