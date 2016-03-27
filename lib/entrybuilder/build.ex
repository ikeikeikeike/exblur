defmodule Entrybuilder.Build do
  use Exblur.Web, :build
  alias Exblur.Scrapy
  alias Exblur.Entry
  alias Translator, as: TL

  require Logger

  def run, do: run([])
  def run(args) do
    TL.configure

    limit = if length(args) > 0, do: List.first(args), else: 30

    entries =
      Scrapy.query
      # |> Scrapy.xvideos
      |> Scrapy.reserved
      |> limit([_e], ^limit)
      |> Mongo.all

    entries =
      Enum.map entries, fn(e) ->
        e = %{e | tags: Enum.map(e.tags, &TL.tag(TL.translate(&1)))}
        e = %{e | title: TL.sentence(TL.translate(e.title))}
        e = %{e | content: TL.sentence(TL.translate(e.content))}
        # e = %{e | embed_code: fix_embed_code(e.embed_code, e.title)
        e
      end

    models =
      entries
      |> filter_less_than
      |> filter_include_url
      |> entry_record

    # Put built up document to Elasticsearch
    # IO.inspect models
    # if length(models) > 0 do
      # Es.Entry.reindex
      # Logger.debug("finish reindex")
    # end

    Logger.info "Finish to build scrapy #{length models} records."
  end

  # Clean video: Physical delete entries coz before publishing those.
  # Entrybuilder::Query.chinese_spams(
    # entries: reserve_entries).delete_all

  #: over the 2 minutes.
  defp filter_less_than(entries, time \\ 120) do
    Enum.filter(entries, fn(e) ->
      e.time > time
    end)
  end

  defp filter_include_url(entries) do
    Enum.filter(entries, fn(e) ->
      ! Regex.match?(~r/ttps?:\/\//i, e.content || "")
    end)
  end

  defp entry_record(entries) do
    entries
    |> Enum.map(fn(e) ->
      Repo.transaction fn ->
        try do
          case Entry.video_creater(e) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")

            {:ok, _model} -> nil

            {:new, model} -> model
          end
        rescue
          # skip entry
          reason in Postgrex.Error ->
            Repo.rollback(reason)
            Logger.error("#{inspect reason}")
        after
          Scrapy.already_post(e)
        end
      end
    end)
    |> Enum.filter(fn(result) ->
      case result do
        {:ok, %Exblur.Entry{}} ->
          true
        _ ->
          false
      end
    end)
  end
end
