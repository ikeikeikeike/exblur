defmodule Entrybuilder.Build do
  use Exblur.Web, :build
  alias Exblur.Scrapy
  alias Exblur.Entry
  alias Translator, as: TL

  require Logger

  def run, do: run([])
  def run(args) do
    TL.configure

    limit = if length(args) > 0, do: List.first(args), else: 0

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

    # models =
      Enum.map(entries, fn(e) ->
        Repo.transaction fn ->
          case Entry.video_creater(e) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")
              nil

            {:ok, _model} ->
              Scrapy.already_post(e)
              nil

            {:new, model} ->
              Scrapy.already_post(e)
              model
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
      |> Enum.filter(&(&1 != nil))

    # Put built up document to Elasticsearch
    # IO.inspect models
    # if length(models) > 0 do
      # Es.Entry.reindex
      # Logger.debug("finish reindex")
    # end

    Logger.info "Finish to build scrapy"
  end
end
