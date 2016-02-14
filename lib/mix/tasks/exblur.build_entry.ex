defmodule Mix.Tasks.Exblur.BuildEntry do
  use Exblur.Web, :task
  alias Exblur.Entry
  alias Exblur.VideoEntry
  alias Translator, as: Tlor

  require Logger

  @shortdoc "Sends a greeting to us from Hello Phoenix"

  @moduledoc """
    This is where we would put any long form documentation or doctests.
  """
  def run(args) do
    setup

    limit = if length(args) > 0, do: List.first(args), else: 0

    entries =
      Entry.query
      # |> Entry.xvideos
      |> Entry.reserved
      |> limit([_e], ^limit)
      |> Mongo.all

    entries =
      Enum.map entries, fn(e) ->
        e = %{e | tags: Enum.join(Enum.map(e.tags, &Tlor.tag(Tlor.translate(&1.tag))), ",")}
        e = %{e | title: Tlor.sentence(Tlor.tag(Tlor.translate(e.title)))}
        e = %{e | content: Tlor.sentence(Tlor.tag(Tlor.translate(e.content)))}
        # e = %{e | embed_code: fix_embed_code(e.embed_code, e.title)

        # entry |> IO.inspect
        # abc = BingTranslator.translate(entry.title, to: "ja")
        # IO.inspect abc

        # ve.title = fixable.sentence(fixable.tag(bing.en_to_ja entry.title))
        # ve.content = fixable.sentence(fixable.tag(bing.en_to_ja entry.content))
        # ve.embed_code = fix_embed_code(ve.embed_code, ve.title)
        # ve.tag_list = entry.tags.map{|tag| fixable.tag(bing.en_to_ja tag)}.join(',')
        e
      end

    require IEx; IEx.pry

    models =
      Enum.map(entries, fn(e) ->
        Repo.transaction fn ->
          case VideoEntry.video_creater(e) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")
              nil

            {:ok, _model} ->
              Entry.already_post(e)
              nil

            {:new, model} ->
              Entry.already_post(e)
              model
          end
        end
      end)
      |> Enum.filter(fn(result) ->
        case result do
          {:ok, %Exblur.VideoEntry{}} ->
            true
          _ ->
            false
        end
      end)
      |> Enum.filter(&(&1 != nil))

    # Put built up document to Elasticsearch
    if length(models) > 0 do
      Es.VideoEntry.reindex
      Logger.debug("finish reindex")
    end

    Mix.shell.info "Finish to build entry"
  end

  def setup do
    Repo.start_link
    Mongo.start_link
    HTTPoison.start
    Tlor.configure
  end

  # We can define other functions as needed here.
end
