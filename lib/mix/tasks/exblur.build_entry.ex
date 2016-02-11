defmodule Mix.Tasks.Exblur.BuildEntry do
  use Exblur.Web, :task
  alias Exblur.Entry
  alias Exblur.VideoEntry

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

    models =
      Enum.map(entries, fn(entry) ->
        # entry |> IO.inspect
        # abc = BingTranslator.translate(entry.title, to: "ja")
        # IO.inspect abc

        # ve.title = fixable.sentence(fixable.tag(bing.en_to_ja entry.title))
        # ve.content = fixable.sentence(fixable.tag(bing.en_to_ja entry.content))
        # ve.embed_code = fix_embed_code(ve.embed_code, ve.title)
        # ve.tag_list = entry.tags.map{|tag| fixable.tag(bing.en_to_ja tag)}.join(',')

        Repo.transaction fn ->
          case VideoEntry.video_creater(entry) do
            {:error, reason} ->
              Repo.rollback(reason)
              Logger.error("#{inspect reason}")
              nil

            {:ok, _model} ->
              Entry.already_post(entry)
              nil

            {:new, model} ->
              Entry.already_post(entry)
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
    BingTranslator.configure
  end

  # We can define other functions as needed here.
end
